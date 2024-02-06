//const { Octokit } = require("@octokit/rest");
//const github = require('@actions/github');
//const core = require('@actions/core');
//const githubToken = process.env.GITHUB_TOKEN;
//const octokit = new Octokit({ auth: githubToken });
//
//async function postComment(owner, repo, issue_number, message) {
//  await octokit.issues.createComment({
//    owner,
//    repo,
//    issue_number,
//    body: message,
//  });
//}
//
//async function checkForTestCases(owner, repo, pullNumber) {
//  try {
//    const { data: pr } = await octokit.pulls.get({
//      owner,
//      repo,
//      pull_number: pullNumber,
//    });
//
//    const hasSkipLabel = pr.labels.some(label => label.name === 'qa_2.0_skip');
//    if (hasSkipLabel) {
//      console.log("**Skipping test case check due to 'qa_2.0_skip' label.**");
//      await postComment(owner, repo, pullNumber, "**Skipping Cucmber test case check due to 'qa_2.0_skip' label.**");
//      return;
//    }
//
//    const { data: files } = await octokit.pulls.listFiles({
//      owner,
//      repo,
//      pull_number: pullNumber,
//    });
//
//    const hasRelevantTests = files.some(file =>
//      (file.status === 'added' || file.status === 'modified') &&
//      file.filename.startsWith('local-tests/features/')
//    );
//
//    if (hasRelevantTests) {
//      console.log("**Relevant Cucumber test cases have been found in the PR.**");
//      await postComment(owner, repo, pullNumber, "**Relevant Cucumber test cases have been found in the PR. QA_2.0 Checkpoint Passed**");
//    } else {
//      const message = "**No relevant Cucumber test cases found. Please add or update test cases for new features.**";
//      console.log(message);
//      await postComment(owner, repo, pullNumber, message);
//      core.setFailed(message); // Fail the workflow if no test cases are found
//    }
//  } catch (error) {
//    console.error("**An error occurred while checking for Cucumber test cases:**", error);
//    core.setFailed(error.message); // Use setFailed to fail the workflow on error
//  }
//}
//
//if (github.context.payload.pull_request) {
//  const pullNumber = github.context.payload.pull_request.number;
//  const owner = github.context.repo.owner;
//  const repo = github.context.repo.repo;
//  checkForTestCases(owner, repo, pullNumber);
//} else {
//  console.log("**This action runs only on pull request events.**");
//}

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

        // Check if changes were made in src/main/java
        const changesInJava = files.some(file =>
            file.filename.startsWith('src/main/java') &&
            (file.status === 'added' || file.status === 'modified')
        );

        if (!changesInJava) {
            // If no changes in src/main/java, post a comment and exit
            await postComment(owner, repo, pullNumber, "No changes made in the code so cucumber test cases checkpoint is ok.");
            return;
        }

        // If changes were made in src/main/java, check for test case updates
        const hasRelevantTests = files.some(file =>
            file.filename.startsWith('local-tests/features/') &&
            (file.status === 'added' || file.status === 'modified')
        );

        let message;
        if (hasRelevantTests) {
            message = "Relevant Cucumber test cases have been found in the PR.";
        } else {
            message = "No relevant Cucumber test cases found. Please add or update test cases for new features.";
            core.setFailed(message); // Optionally, fail the action if no test cases are found
        }
        await postComment(owner, repo, pullNumber, message);

    } catch (error) {
        console.error("An error occurred while checking for Cucumber test cases:", error);
        core.setFailed(error.message);
    }
}

if (github.context.payload.pull_request) {
    const pullNumber = github.context.payload.pull_request.number;
    const owner = github.context.repo.owner;
    const repo = github.context.repo.repo;
    checkForTestCases(owner, repo, pullNumber);
} else {
    console.log("This action runs only on pull request events.");
}

