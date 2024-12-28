#include <netdb.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/wait.h>

int main(int argc, char const *argv[]) {
    int port = 80;
    if (argc > 1) {
        port = atoi(argv[1]);
    }

    int sockfd;
    if ((sockfd = socket(AF_INET6, SOCK_STREAM, 0)) == -1) {
        perror("socket error");
        return 1;
    }

    int opt = 1;
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1) {
        perror("setsockopt error");
        return 1;
    }

    struct sockaddr_in6 sockaddr;
    memset(&sockaddr, 0, sizeof(sockaddr));
    sockaddr.sin6_family = AF_INET6;
    sockaddr.sin6_addr = in6addr_any;
    sockaddr.sin6_port = htons(port);

    if (bind(sockfd, (struct sockaddr *)&sockaddr, sizeof(sockaddr)) == -1) {
        perror("bind error");
        return 1;
    }

    if (listen(sockfd, SOMAXCONN) == -1) {
        perror("listen error");
        return 1;
    }

    while (1) {
        int sock;
        struct sockaddr_in client;
        int client_len = sizeof(client);

        if ((sock = accept(sockfd, (struct sockaddr *)&client, (socklen_t *)&client_len)) == -1) {
            perror("accept error");
            continue;
        }

        close(sock);
    }

    close(sockfd);

    return 0;
}
