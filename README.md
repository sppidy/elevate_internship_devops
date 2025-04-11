## Task 4 - Implementing Git Workflow Best Practices

### Objective
Demonstrate efficient Git processes such as feature branching, pull requests, and structured documentation by managing your DevOps tasks within this repo.

### Repository Details
This repo ([elevate_internship_devops](https://github.com/sppidy/elevate_internship_devops)) contains branches for each task as provided by Elevate Labs. Instead of a main branch, we maintain:
- `elevate-labs-task1`
- `elevate-labs-task2`
- `elevate-labs-task3`
- `elevate-labs-task4`

Each branch represents a complete task-based milestone.

### Sample Pull Request
A prime example of the workflow is [PR #1](https://github.com/sppidy/elevate_internship_devops/pull/1), which illustrates:
- **Feature Branching:** Work on `elevate-labs-task4` is isolated from the others.
- **Pull Request Process:** Changes are submitted via PRs to allow for review before integration.
- **Commit Discipline:** Each commit carries clear, descriptive messages for accountability.

### Versioning & Tags
After completing the task on the `elevate-labs-task4` branch and merging any necessary changes, you can tag the final version (e.g., `v1.0-task4`) to mark the milestone completion.

### .gitignore Setup
Your repo leverages a standard `.gitignore` to filter out:
```gitignore
node_modules/
.env
__pycache__/
*.log
.vscode/
.DS_Store
