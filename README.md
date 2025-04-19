
# ✅ Task 8 – Java Maven Build in Jenkins (Docker-based)

## 🛠️ DevOps Internship Submission  
**Objective:** Run a Jenkins Freestyle job to build a basic Java application using Maven inside a preconfigured Dockerized Jenkins environment.

---

## 📌 Summary

This task demonstrates:
- Using a **custom Jenkins Docker image** preloaded with:
  - OpenJDK 11
  - Apache Maven 3.9.6
  - Docker CLI
- Setting up a **Jenkins Freestyle Job** to build a Java HelloWorld app
- Using the `clean package` Maven goal
- Validating the build via Jenkins console output

---

## 📦 Project Structure

```bash
hello-java-maven/
├── src/
│   └── main/
│       └── java/
│           └── HelloWorld.java
├── pom.xml
├── screenshot.png
└── README.md
```

---

## ☕ Java Source Code

**📄 `src/main/java/HelloWorld.java`**
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, Jenkins + Maven!");
    }
}
```

---

## 📜 Maven Configuration

**📄 `pom.xml`**
```xml
<project>
  <modelVersion>4.0.0</modelVersion>
  <groupId>com.example</groupId>
  <artifactId>hello</artifactId>
  <version>1.0</version>
  <build>
    <plugins>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <version>3.8.1</version>
        <configuration>
          <source>1.8</source>
          <target>1.8</target>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
```

---

## 🐳 Run Jenkins via Custom Docker Image

```bash
docker run -d \
  -p 8080:8080 \
  -v jenkins_home:/var/jenkins_home \
  --name internship-jenkins \
  jenkins-maven-docker
```

> Jenkins will be available at: [http://localhost:8080](http://localhost:8080)

📌 *Note:* This custom image already includes Java, Maven, and Docker CLI — no extra setup needed inside the container.

---

## ⚙️ Jenkins Setup

1. **Login to Jenkins**
   - Use the password from:
     ```bash
     cat /var/jenkins_home/secrets/initialAdminPassword
     ```
2. **Install Suggested Plugins**

3. **Add the JDK and MAVEN path in Dashboard > Manage Jenkins > Tools**
   - Under JDK Installations > Add JDK
     - Set `JAVA_HOME` to `/opt/java/openjdk`
   - Under Maven Installations > Add Maven
     - Set `MAVEN_HOME` to `/opt/maven`

4. **Create a Freestyle Project**
   - Job Name: `java-maven-build`
   - Source Code: Choose "None" or Git (optional)
   - **Build Step:**
     - Select: *Invoke top-level Maven targets*
     - Goals: `clean package`

5. **Save and Build the Job**

---

## ✅ Output Verification

The Jenkins build should end with:

```bash
[INFO] BUILD SUCCESS
```

📸 Screenshot:

![Jenkins Build Success](https://github.com/sppidy/elevate_internship_devops/blob/elevate-labs-task8/screenshot.png)

---
