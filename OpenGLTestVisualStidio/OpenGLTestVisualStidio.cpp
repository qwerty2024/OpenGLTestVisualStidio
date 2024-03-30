#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>
#include <fstream>
#include <filesystem>


std::string readFile(std::filesystem::path path)
{
    std::ifstream in(path, std::ios::binary);
    const auto sz = std::filesystem::file_size(path);
    std::string result(sz, '\0');
    in.read(result.data(), sz);

    return result;
}

GLuint compileShader(unsigned int shaderType, std::string &src)
{
    GLuint  id = glCreateShader(shaderType);
    const char* raw = src.c_str();
    glShaderSource(id, 1, &raw, nullptr);
    glCompileShader(id);

    return id;
}

unsigned int createShader(std::string &vertex, std::string &fragment)
{
    GLuint  vs = compileShader(GL_VERTEX_SHADER, vertex);
    GLuint  fs = compileShader(GL_FRAGMENT_SHADER, fragment);

    GLuint program = glCreateProgram();

    glAttachShader(program, vs);
    glAttachShader(program, fs);
    glLinkProgram(program);
    glUseProgram(program);
    glValidateProgram(program);

    glDeleteShader(vs);
    glDeleteShader(fs);

    return program;
}


int main(void)
{
    GLFWwindow* window;

    /* Initialize the library */
    if (!glfwInit())
        return -1;

    /* Create a windowed mode window and its OpenGL context */
    window = glfwCreateWindow(800, 600, "OpenGL", nullptr, nullptr); // Windowed
    if (!window)
    {
        glfwTerminate();
        return -1;
    }

    /* Make the window's context current */
    glfwMakeContextCurrent(window);

    // Init Glad
    if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
        std::cout << "Failed to initalize OpenGL context" << std::endl;
        return -1;
    }

    float vertecies[] =
    {
        -1.0, -1.0,
        1.0, -1.0,
        1.0, 1.0,

        1.0, 1.0,
        -1.0, 1.0,
        -1.0, -1.0,
    };

    std::string vertex = readFile("Shaders\\v.shader");
    std::string fragment = readFile("Shaders\\f.shader");
    

    GLuint VBO;
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, 6 * 2 * sizeof(float), vertecies, GL_STATIC_DRAW);
    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 2 * sizeof(float), 0);
    
    glEnableVertexAttribArray(0);

    unsigned int shader = createShader(vertex, fragment);

    glUseProgram(shader);

    glUniform2f(glGetUniformLocation(shader, "resolution"), 1280, 720);

    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
        if (glfwGetKey(window, GLFW_KEY_SPACE) == GLFW_PRESS)
            glfwSetWindowShouldClose(window, GL_TRUE);

        glUniform1f(glGetUniformLocation(shader, "time"), glfwGetTime());

        glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);


        glDrawArrays(GL_TRIANGLES, 0, 6);

        glfwSwapBuffers(window);
        glfwPollEvents();
    }


    glDeleteProgram(shader);
    glfwTerminate();
    return 0;
}