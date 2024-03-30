#include <iostream>
#include <GLFW\glfw3.h>
//#include <glad/glad.h>


int main(void)
{
    GLFWwindow* window;

    /* Initialize the library */
    if (!glfwInit())
        return -1;

    /* Create a windowed mode window and its OpenGL context */
    window = glfwCreateWindow(640, 480, "Hello World", NULL, NULL);
    if (!window)
    {
        glfwTerminate();
        return -1;
    }

    /* Make the window's context current */
    glfwMakeContextCurrent(window);

    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
        glBegin(GL_TRIANGLES);

        /* Render here */
        glClear(GL_COLOR_BUFFER_BIT);

        glVertex2d(0.0, 1.0);
        glVertex2d(1.0, -1.0);
        glVertex2d(-1.0, -1.0);

        glEnd();

        /* Swap front and back buffers */
        glfwSwapBuffers(window);

        /* Poll for and process events */
        glfwPollEvents();
    }

    glfwTerminate();
    return 0;
}