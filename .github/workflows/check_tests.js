const { Octokit } = require("@octokit/rest");
const github = require('@actions/github');
const githubToken = process.env.GITHUB_TOKEN;
const octokit = new Octokit({ auth: githubToken });


async function checkForTestCases(owner, repo, pullNumber) {
  try {
    const { data: files } = await octokit.pulls.listFiles({
      owner,
      repo,
      pull_number: pullNumber,
    });

    // Check for files that are either added or modified in the PR, including subdirectories
    const hasRelevantTests = files.some(file =>
      (file.status === 'added' || file.status === 'modified') &&
      file.filename.startsWith('local-tests/features/') // Adjust path as necessary
    );

    if (hasRelevantTests) {
      console.log("Relevant Cucumber test cases have been found in the PR.");
    } else {
      console.log("No relevant Cucumber test cases found. Please add or update test cases for new features.");
      process.exit(1); // Exit with error if no test cases are found
    }
  } catch (error) {
    console.error("An error occurred while checking for Cucumber test cases:", error);
    process.exit(1); // Exit with error in case of API failure
  }
}

//// Example usage - ensure these values are dynamically set based on actual PR context
//const owner = 'Nalla';
//const repo = 'qa-automation';
//const pullNumber = 1; // Dynamically set this based on the PR event


const github = require('@actions/github');
const pullNumber = github.context.payload.pull_request.number;
const owner = github.context.repo.owner;
const repo = github.context.repo.repo;

checkForTestCases(owner, repo, pullNumber);
