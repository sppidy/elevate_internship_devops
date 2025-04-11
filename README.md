# Elevate Labs DevOps Internship – Git Workflow Tasks

Welcome to my Elevate Internship DevOps repository. This project showcases Git best practices and task-based branching for each deliverable provided during the internship.

---

## 📁 Repository Structure

This repository does **not use a `main` branch**. Instead, each task is isolated in its own dedicated branch to demonstrate modular version control.

| Branch    | Description                              |
|-----------|------------------------------------------|
| `elevate-labs-task1`  | Initial DevOps setup                     |
| `elevate-labs-task2`  | CI/CD and automation basics              |
| `elevate-labs-task3`  | Infrastructure-as-Code (IaC) task        |
| `elevate-labs-task4`  | Git workflow and version control best practices ✅ |

---

## 🔧 Task 4 – Git Best Practices

### ✅ Objective

Implement a complete Git workflow:
- Branching Strategy
- Pull Requests
- Commit Hygiene
- Tagging
- README Documentation
- `.gitignore` usage

### ✅ Branch Used
- `elevate-labs-task4`

### ✅ Sample Pull Request
🔗 [PR #1: Add Git best practices for task 4](https://github.com/sppidy/elevate_internship_devops/pull/1)

This PR demonstrates:
- Feature isolation using `elevate-labs-task4`
- Clean commit messages
- Pull request usage for peer review simulation

### ✅ Git Tag
```bash
git tag -a v1.0-task4 -m "Completed Task 4 – Git Workflow Implementation"
git push origin v1.0-task4
```

### ✅ .gitignore
```gitignore
node_modules/
.env
__pycache__/
*.log
.vscode/
.DS_Store
```

---

## 🚀 Git Workflow Summary

1. **Each task has its own branch** (no `main`)
2. Work is isolated per branch to avoid interference
3. PRs simulate collaborative code review
4. Tags mark version milestones
5. Documentation provided in `README.md`

---

## 🤝 Connect

This repository demonstrates real-world version control discipline—an essential DevOps skill. Feel free to check out each branch to explore the task-specific solutions.

Happy DevOpsing! 🛠️

— Spidy 🕸️