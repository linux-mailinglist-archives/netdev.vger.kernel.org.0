Return-Path: <netdev+bounces-9360-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F17EF72896F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:28:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4FDA2817C2
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:28:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC2F31F1A;
	Thu,  8 Jun 2023 20:27:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7F72D279
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:27:07 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF9B030D6
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:26:57 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 633733F36A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686256016;
	bh=0r3w+p7lLL3IiUaSzQ8Wv51gElYa/s7NhvJj2biMB0Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version;
	b=GSPXOJ8DRBd8f2rmVZ8U+Hz+L0sB5qEy6rPp83xRC/f0KJe3dn8Bo3bSIxUlKkwjI
	 LmDNg7Ru7S9wDcPDllNXEXxqsqZQnJPjgUQTt1BScXmcC8qGn2KGpiELHxGyPK9IXw
	 xY0BSnpRdofl6X/DDsggxYBEcjz7eVSztmPykAXWNSRCqJTqSXbLnfuqWhYFW1mTQV
	 0R44XI0V4Uidmc0+dcuq4ComvUNNOX74qut8Md91nUsdXxKxFWCBH43OtRmhu0AVQS
	 4yrvmDlMgvLlAccmuW18wqA41gfHXC3QxIStyr6AuYMH200X7Z7zMaSToJuU+nuOuc
	 fMmIasqLSBjJA==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-97542592eb9so95564766b.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 13:26:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686256015; x=1688848015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0r3w+p7lLL3IiUaSzQ8Wv51gElYa/s7NhvJj2biMB0Y=;
        b=geL3ZjxgB1QEKiVv2D66ZHMDG7o1o8oloehy3lQLQNIve1gamp6hJoGFUg1H7tyKa9
         3m6KKM1h5FrhwuPL3QCyhQ7Ppzw2MfPxI9E6DlIQ3MNpiX4K1mQtvNBtFEuIBHqlqsoY
         TxB3XfpM0ct+7BWTYDDOyoVtJ1t6pqta5MojbAl4A4ehcYY+mPUtxSjDUvmBE4GOYFHh
         N8WLopCZzi5fI2xd2Q0wPk0oaIOzfQ5uCO9zSIxnLkmXfPPPJslrn4uOfLKPw/fvckop
         8+BIuaIiQaB87mnia9WJgIRYb0WFUT6Im1ozFXDC+358Jk9fLCUl2bC1m+q1mMF97sZo
         pNsw==
X-Gm-Message-State: AC+VfDyphKJ4jh+M59mNVH03giQ4/nQTKRlUDetaWbr497aL2DqjS02o
	7KV60FipGh1LK+WeA6nUwlbP2JnmePiwsIht0kZvCBapD2lTjcMC/Grr/56SV/Cgo7s8ZUj63H9
	t1VcAiSyX6SQlYLH9Td2vY0SRhRjyJLCNjw==
X-Received: by 2002:a17:907:944b:b0:973:d7cd:44ac with SMTP id dl11-20020a170907944b00b00973d7cd44acmr176707ejc.54.1686256015070;
        Thu, 08 Jun 2023 13:26:55 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5OqIkjFjFu8cNVyETJd9yeOg3BSteHd7YbZqtC7eBIZ/A0y8zQDmeLZwaSdcHhPJF/CeHYYA==
X-Received: by 2002:a17:907:944b:b0:973:d7cd:44ac with SMTP id dl11-20020a170907944b00b00973d7cd44acmr176695ejc.54.1686256014830;
        Thu, 08 Jun 2023 13:26:54 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id b16-20020a170906491000b0095342bfb701sm315592ejq.16.2023.06.08.13.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jun 2023 13:26:54 -0700 (PDT)
From: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <brauner@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	linux-arch@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH net-next v7 3/4] selftests: net: add SCM_PIDFD / SO_PEERPIDFD test
Date: Thu,  8 Jun 2023 22:26:27 +0200
Message-Id: <20230608202628.837772-4-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230608202628.837772-1-aleksandr.mikhalitsyn@canonical.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Basic test to check consistency between:
- SCM_CREDENTIALS and SCM_PIDFD
- SO_PEERCRED and SO_PEERPIDFD

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
v3:
	- started using kselftest lib (thanks to Kuniyuki Iwashima for suggestion/review)
	- now test covers abstract sockets too and SOCK_DGRAM sockets
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/af_unix/Makefile  |   3 +-
 .../testing/selftests/net/af_unix/scm_pidfd.c | 430 ++++++++++++++++++
 3 files changed, 433 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/af_unix/scm_pidfd.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index f27a7338b60e..501854a89cc0 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -29,6 +29,7 @@ reuseport_bpf_numa
 reuseport_dualstack
 rxtimestamp
 sctp_hello
+scm_pidfd
 sk_bind_sendto_listen
 sk_connect_zero_addr
 socket
diff --git a/tools/testing/selftests/net/af_unix/Makefile b/tools/testing/selftests/net/af_unix/Makefile
index 1e4b397cece6..221c387a7d7f 100644
--- a/tools/testing/selftests/net/af_unix/Makefile
+++ b/tools/testing/selftests/net/af_unix/Makefile
@@ -1,3 +1,4 @@
-TEST_GEN_PROGS := diag_uid test_unix_oob unix_connect
+CFLAGS += $(KHDR_INCLUDES)
+TEST_GEN_PROGS := diag_uid test_unix_oob unix_connect scm_pidfd
 
 include ../../lib.mk
diff --git a/tools/testing/selftests/net/af_unix/scm_pidfd.c b/tools/testing/selftests/net/af_unix/scm_pidfd.c
new file mode 100644
index 000000000000..a86222143d79
--- /dev/null
+++ b/tools/testing/selftests/net/af_unix/scm_pidfd.c
@@ -0,0 +1,430 @@
+// SPDX-License-Identifier: GPL-2.0 OR MIT
+#define _GNU_SOURCE
+#include <error.h>
+#include <limits.h>
+#include <stddef.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/socket.h>
+#include <linux/socket.h>
+#include <unistd.h>
+#include <string.h>
+#include <errno.h>
+#include <sys/un.h>
+#include <sys/signal.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "../../kselftest_harness.h"
+
+#define clean_errno() (errno == 0 ? "None" : strerror(errno))
+#define log_err(MSG, ...)                                                   \
+	fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", __FILE__, __LINE__, \
+		clean_errno(), ##__VA_ARGS__)
+
+#ifndef SCM_PIDFD
+#define SCM_PIDFD 0x04
+#endif
+
+static void child_die()
+{
+	exit(1);
+}
+
+static int safe_int(const char *numstr, int *converted)
+{
+	char *err = NULL;
+	long sli;
+
+	errno = 0;
+	sli = strtol(numstr, &err, 0);
+	if (errno == ERANGE && (sli == LONG_MAX || sli == LONG_MIN))
+		return -ERANGE;
+
+	if (errno != 0 && sli == 0)
+		return -EINVAL;
+
+	if (err == numstr || *err != '\0')
+		return -EINVAL;
+
+	if (sli > INT_MAX || sli < INT_MIN)
+		return -ERANGE;
+
+	*converted = (int)sli;
+	return 0;
+}
+
+static int char_left_gc(const char *buffer, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (buffer[i] == ' ' || buffer[i] == '\t')
+			continue;
+
+		return i;
+	}
+
+	return 0;
+}
+
+static int char_right_gc(const char *buffer, size_t len)
+{
+	int i;
+
+	for (i = len - 1; i >= 0; i--) {
+		if (buffer[i] == ' ' || buffer[i] == '\t' ||
+		    buffer[i] == '\n' || buffer[i] == '\0')
+			continue;
+
+		return i + 1;
+	}
+
+	return 0;
+}
+
+static char *trim_whitespace_in_place(char *buffer)
+{
+	buffer += char_left_gc(buffer, strlen(buffer));
+	buffer[char_right_gc(buffer, strlen(buffer))] = '\0';
+	return buffer;
+}
+
+/* borrowed (with all helpers) from pidfd/pidfd_open_test.c */
+static pid_t get_pid_from_fdinfo_file(int pidfd, const char *key, size_t keylen)
+{
+	int ret;
+	char path[512];
+	FILE *f;
+	size_t n = 0;
+	pid_t result = -1;
+	char *line = NULL;
+
+	snprintf(path, sizeof(path), "/proc/self/fdinfo/%d", pidfd);
+
+	f = fopen(path, "re");
+	if (!f)
+		return -1;
+
+	while (getline(&line, &n, f) != -1) {
+		char *numstr;
+
+		if (strncmp(line, key, keylen))
+			continue;
+
+		numstr = trim_whitespace_in_place(line + 4);
+		ret = safe_int(numstr, &result);
+		if (ret < 0)
+			goto out;
+
+		break;
+	}
+
+out:
+	free(line);
+	fclose(f);
+	return result;
+}
+
+static int cmsg_check(int fd)
+{
+	struct msghdr msg = { 0 };
+	struct cmsghdr *cmsg;
+	struct iovec iov;
+	struct ucred *ucred = NULL;
+	int data = 0;
+	char control[CMSG_SPACE(sizeof(struct ucred)) +
+		     CMSG_SPACE(sizeof(int))] = { 0 };
+	int *pidfd = NULL;
+	pid_t parent_pid;
+	int err;
+
+	iov.iov_base = &data;
+	iov.iov_len = sizeof(data);
+
+	msg.msg_iov = &iov;
+	msg.msg_iovlen = 1;
+	msg.msg_control = control;
+	msg.msg_controllen = sizeof(control);
+
+	err = recvmsg(fd, &msg, 0);
+	if (err < 0) {
+		log_err("recvmsg");
+		return 1;
+	}
+
+	if (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC)) {
+		log_err("recvmsg: truncated");
+		return 1;
+	}
+
+	for (cmsg = CMSG_FIRSTHDR(&msg); cmsg != NULL;
+	     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
+		if (cmsg->cmsg_level == SOL_SOCKET &&
+		    cmsg->cmsg_type == SCM_PIDFD) {
+			if (cmsg->cmsg_len < sizeof(*pidfd)) {
+				log_err("CMSG parse: SCM_PIDFD wrong len");
+				return 1;
+			}
+
+			pidfd = (void *)CMSG_DATA(cmsg);
+		}
+
+		if (cmsg->cmsg_level == SOL_SOCKET &&
+		    cmsg->cmsg_type == SCM_CREDENTIALS) {
+			if (cmsg->cmsg_len < sizeof(*ucred)) {
+				log_err("CMSG parse: SCM_CREDENTIALS wrong len");
+				return 1;
+			}
+
+			ucred = (void *)CMSG_DATA(cmsg);
+		}
+	}
+
+	/* send(pfd, "x", sizeof(char), 0) */
+	if (data != 'x') {
+		log_err("recvmsg: data corruption");
+		return 1;
+	}
+
+	if (!pidfd) {
+		log_err("CMSG parse: SCM_PIDFD not found");
+		return 1;
+	}
+
+	if (!ucred) {
+		log_err("CMSG parse: SCM_CREDENTIALS not found");
+		return 1;
+	}
+
+	/* pidfd from SCM_PIDFD should point to the parent process PID */
+	parent_pid =
+		get_pid_from_fdinfo_file(*pidfd, "Pid:", sizeof("Pid:") - 1);
+	if (parent_pid != getppid()) {
+		log_err("wrong SCM_PIDFD %d != %d", parent_pid, getppid());
+		return 1;
+	}
+
+	return 0;
+}
+
+struct sock_addr {
+	char sock_name[32];
+	struct sockaddr_un listen_addr;
+	socklen_t addrlen;
+};
+
+FIXTURE(scm_pidfd)
+{
+	int server;
+	pid_t client_pid;
+	int startup_pipe[2];
+	struct sock_addr server_addr;
+	struct sock_addr *client_addr;
+};
+
+FIXTURE_VARIANT(scm_pidfd)
+{
+	int type;
+	bool abstract;
+};
+
+FIXTURE_VARIANT_ADD(scm_pidfd, stream_pathname)
+{
+	.type = SOCK_STREAM,
+	.abstract = 0,
+};
+
+FIXTURE_VARIANT_ADD(scm_pidfd, stream_abstract)
+{
+	.type = SOCK_STREAM,
+	.abstract = 1,
+};
+
+FIXTURE_VARIANT_ADD(scm_pidfd, dgram_pathname)
+{
+	.type = SOCK_DGRAM,
+	.abstract = 0,
+};
+
+FIXTURE_VARIANT_ADD(scm_pidfd, dgram_abstract)
+{
+	.type = SOCK_DGRAM,
+	.abstract = 1,
+};
+
+FIXTURE_SETUP(scm_pidfd)
+{
+	self->client_addr = mmap(NULL, sizeof(*self->client_addr), PROT_READ | PROT_WRITE,
+				 MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	ASSERT_NE(MAP_FAILED, self->client_addr);
+}
+
+FIXTURE_TEARDOWN(scm_pidfd)
+{
+	close(self->server);
+
+	kill(self->client_pid, SIGKILL);
+	waitpid(self->client_pid, NULL, 0);
+
+	if (!variant->abstract) {
+		unlink(self->server_addr.sock_name);
+		unlink(self->client_addr->sock_name);
+	}
+}
+
+static void fill_sockaddr(struct sock_addr *addr, bool abstract)
+{
+	char *sun_path_buf = (char *)&addr->listen_addr.sun_path;
+
+	addr->listen_addr.sun_family = AF_UNIX;
+	addr->addrlen = offsetof(struct sockaddr_un, sun_path);
+	snprintf(addr->sock_name, sizeof(addr->sock_name), "scm_pidfd_%d", getpid());
+	addr->addrlen += strlen(addr->sock_name);
+	if (abstract) {
+		*sun_path_buf = '\0';
+		addr->addrlen++;
+		sun_path_buf++;
+	} else {
+		unlink(addr->sock_name);
+	}
+	memcpy(sun_path_buf, addr->sock_name, strlen(addr->sock_name));
+}
+
+static void client(FIXTURE_DATA(scm_pidfd) *self,
+		   const FIXTURE_VARIANT(scm_pidfd) *variant)
+{
+	int err;
+	int cfd;
+	socklen_t len;
+	struct ucred peer_cred;
+	int peer_pidfd;
+	pid_t peer_pid;
+	int on = 0;
+
+	cfd = socket(AF_UNIX, variant->type, 0);
+	if (cfd < 0) {
+		log_err("socket");
+		child_die();
+	}
+
+	if (variant->type == SOCK_DGRAM) {
+		fill_sockaddr(self->client_addr, variant->abstract);
+
+		if (bind(cfd, (struct sockaddr *)&self->client_addr->listen_addr, self->client_addr->addrlen)) {
+			log_err("bind");
+			child_die();
+		}
+	}
+
+	if (connect(cfd, (struct sockaddr *)&self->server_addr.listen_addr,
+		    self->server_addr.addrlen) != 0) {
+		log_err("connect");
+		child_die();
+	}
+
+	on = 1;
+	if (setsockopt(cfd, SOL_SOCKET, SO_PASSCRED, &on, sizeof(on))) {
+		log_err("Failed to set SO_PASSCRED");
+		child_die();
+	}
+
+	if (setsockopt(cfd, SOL_SOCKET, SO_PASSPIDFD, &on, sizeof(on))) {
+		log_err("Failed to set SO_PASSPIDFD");
+		child_die();
+	}
+
+	close(self->startup_pipe[1]);
+
+	if (cmsg_check(cfd)) {
+		log_err("cmsg_check failed");
+		child_die();
+	}
+
+	/* skip further for SOCK_DGRAM as it's not applicable */
+	if (variant->type == SOCK_DGRAM)
+		return;
+
+	len = sizeof(peer_cred);
+	if (getsockopt(cfd, SOL_SOCKET, SO_PEERCRED, &peer_cred, &len)) {
+		log_err("Failed to get SO_PEERCRED");
+		child_die();
+	}
+
+	len = sizeof(peer_pidfd);
+	if (getsockopt(cfd, SOL_SOCKET, SO_PEERPIDFD, &peer_pidfd, &len)) {
+		log_err("Failed to get SO_PEERPIDFD");
+		child_die();
+	}
+
+	/* pid from SO_PEERCRED should point to the parent process PID */
+	if (peer_cred.pid != getppid()) {
+		log_err("peer_cred.pid != getppid(): %d != %d", peer_cred.pid, getppid());
+		child_die();
+	}
+
+	peer_pid = get_pid_from_fdinfo_file(peer_pidfd,
+					    "Pid:", sizeof("Pid:") - 1);
+	if (peer_pid != peer_cred.pid) {
+		log_err("peer_pid != peer_cred.pid: %d != %d", peer_pid, peer_cred.pid);
+		child_die();
+	}
+}
+
+TEST_F(scm_pidfd, test)
+{
+	int err;
+	int pfd;
+	int child_status = 0;
+
+	self->server = socket(AF_UNIX, variant->type, 0);
+	ASSERT_NE(-1, self->server);
+
+	fill_sockaddr(&self->server_addr, variant->abstract);
+
+	err = bind(self->server, (struct sockaddr *)&self->server_addr.listen_addr, self->server_addr.addrlen);
+	ASSERT_EQ(0, err);
+
+	if (variant->type == SOCK_STREAM) {
+		err = listen(self->server, 1);
+		ASSERT_EQ(0, err);
+	}
+
+	err = pipe(self->startup_pipe);
+	ASSERT_NE(-1, err);
+
+	self->client_pid = fork();
+	ASSERT_NE(-1, self->client_pid);
+	if (self->client_pid == 0) {
+		close(self->server);
+		close(self->startup_pipe[0]);
+		client(self, variant);
+		exit(0);
+	}
+	close(self->startup_pipe[1]);
+
+	if (variant->type == SOCK_STREAM) {
+		pfd = accept(self->server, NULL, NULL);
+		ASSERT_NE(-1, pfd);
+	} else {
+		pfd = self->server;
+	}
+
+	/* wait until the child arrives at checkpoint */
+	read(self->startup_pipe[0], &err, sizeof(int));
+	close(self->startup_pipe[0]);
+
+	if (variant->type == SOCK_DGRAM) {
+		err = sendto(pfd, "x", sizeof(char), 0, (struct sockaddr *)&self->client_addr->listen_addr, self->client_addr->addrlen);
+		ASSERT_NE(-1, err);
+	} else {
+		err = send(pfd, "x", sizeof(char), 0);
+		ASSERT_NE(-1, err);
+	}
+
+	close(pfd);
+	waitpid(self->client_pid, &child_status, 0);
+	ASSERT_EQ(0, WIFEXITED(child_status) ? WEXITSTATUS(child_status) : 1);
+}
+
+TEST_HARNESS_MAIN
-- 
2.34.1


