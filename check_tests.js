const { Octokit } = require("@octokit/rest");
const github = require('@actions/github');
const core = require('@actions/core');
const githubToken = process.env.GITHUB_TOKEN;
const octokit = new Octokit({ auth: githubToken });

async function postComment(owner, repo, issue_number, message) {
    await octokit.issues.createComment({
        owner,
        repo,
        issue_number,
        body: message,
    });
}

async function checkForTestCases(owner, repo, pullNumber) {
    try {
        const { data: files } = await octokit.pulls.listFiles({
            owner,
            repo,
            pull_number: pullNumber,
        });

        // Check if changes were made in src/main/java or /internal
        const changesInRelevantAreas = files.some(file =>
            (file.filename.startsWith('src/main/java') || file.filename.startsWith('internal/')) &&
            (file.status === 'added' || file.status === 'modified')
        );

        if (!changesInRelevantAreas) {
            // If no changes in src/main/java or /internal, post a comment and exit
            await postComment(owner, repo, pullNumber, "**No significant code changes detected, So the check for Cucumber test cases is bypassed**");
            return;
        }

        // If changes were made in src/main/java or /internal, check for test case updates
        const hasRelevantTests = files.some(file =>
            file.filename.startsWith('local-tests/features/') &&
            (file.status === 'added' || file.status === 'modified')
        );

        let message;
        if (hasRelevantTests) {
            message = "**🚀 Excellent! Cucumber test cases have been identified in this PR, aligning with Shift Left testing principles. This proactive approach ensures that new features are thoroughly tested early in the development cycle, enhancing code quality and reducing future defects. Great job on maintaining high standards for testing!**";
        } else {
            message = "**Changes detected in critical code areas without corresponding updates in Cucumber test cases. To align with Shift Left testing principles, please ensure that new or modified features are accompanied by relevant test cases. This helps in identifying and addressing issues early in the development process, improving code quality and efficiency.**";
            core.setFailed(message); // Optionally, fail the action if no test cases are found
        }
        await postComment(owner, repo, pullNumber, message);

    } catch (error) {
        console.error("**An error occurred while checking for Cucumber test cases:**", error);
        core.setFailed(error.message);
    }
}

if (github.context.payload.pull_request) {
    const pullNumber = github.context.payload.pull_request.number;
    const owner = github.context.repo.owner;
    const repo = github.context.repo.repo;
    checkForTestCases(owner, repo, pullNumber);
} else {
    console.log("**This action runs only on pull request events.**");
}

