Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3996230C96
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 16:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730486AbgG1OjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 10:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730443AbgG1OjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 10:39:16 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DD7C061794;
        Tue, 28 Jul 2020 07:39:16 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so5738780iow.11;
        Tue, 28 Jul 2020 07:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=wJ8v23x7Y2FC0aWK8XYKTzplRSBW0CXrOa5CKTnOUmI=;
        b=EOeeoRSo+IhFvKV8BzKlXCxJo4XJ/o0IIegGIfU7zQXBNCkKLUcCp/whNH4nS6KtEr
         COdTyN7/4/nq8fLvzw2fkzM/b5pPi4TMGrTwLUIRrywjZcQS9T4q7cidBYZyQKpUY22+
         UudGuwkQcZwqrgMIvENsOLejh3/FhQixPA2JR+YvVs+ORMrA3ANi1+QWN2jXHSB02sEy
         9yqDHujzU6rWAbkkyBDI4hOS8qdWvx5jMRkvm+9U1tfoUeMG0/FkA2WWYL6HC8A5Qm/6
         XDk3/WKH0rURjG8gsBd8V2ZmU9VBMv1XJLDgu+7ZO1juYpSwe9ZOEeHVnsIEZZYuunKe
         i4sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=wJ8v23x7Y2FC0aWK8XYKTzplRSBW0CXrOa5CKTnOUmI=;
        b=DFAFRJ+oAL4R9RecquSSS+G3sD3Lixt2g75aRPn5lSbnqrgRwObVTzzruMRKuo+nsW
         MayTOjTCXkb5LJDTgEGKFw3SMUFBobuLdSo3PM8/T3zJ04+bJO7KioN9HAb+Ub3YjD2B
         UNOkp90+gF5c0bdYTcZJQTusyRtKuy/bLOA/U6Th0lw9HgTeteUPRxuSTO//DENzmzyC
         O7XOARd2jsxO0gZT3AtbS3xL5tkuv/L7usE/Ks4TfTgkakMJq6KTqKcXq8/kTWj/ebwl
         YetDcWQSbGgPgNjWRZv5N8M8Ypoc58Fm3LmkjpwZW5YdGaQnskUcw41+3CJ2e/cjwc3y
         gzSQ==
X-Gm-Message-State: AOAM5319so+vmROlqg2xnsJ8RhWvhxifxp2N7DTru3JkjBp9IxzIE0NC
        oLF6o/zFznbPYcmdM5TZA48=
X-Google-Smtp-Source: ABdhPJx00jogK9RmLYmrWmKR5skEV1C0MDFSimYum2tWoFsDg4YGxS9ONivu4m6jhwGxm084T8RB5g==
X-Received: by 2002:a05:6638:2493:: with SMTP id x19mr33968122jat.53.1595947156224;
        Tue, 28 Jul 2020 07:39:16 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id x88sm3357294ilk.81.2020.07.28.07.39.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 07:39:15 -0700 (PDT)
Subject: [bpf-next PATCH] bpf,
 selftests: use ::1 for localhost in tcp_server.py
From:   John Fastabend <john.fastabend@gmail.com>
To:     john.fastabend@gmail.com, guro@fb.com, daniel@iogearbox.net,
        ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Date:   Tue, 28 Jul 2020 07:39:02 -0700
Message-ID: <159594714197.21431.10113693935099326445.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using localhost requires the host to have a /etc/hosts file with that
specific line in it. By default my dev box did not, they used
ip6-localhost, so the test was failing. To fix remove the need for any
/etc/hosts and use ::1.

I could just add the line, but this seems easier.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/testing/selftests/bpf/tcp_client.py |    2 +-
 tools/testing/selftests/bpf/tcp_server.py |    2 +-
 tools/testing/selftests/bpf/test_netcnt.c |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/tcp_client.py b/tools/testing/selftests/bpf/tcp_client.py
index a53ed58..bfff82b 100755
--- a/tools/testing/selftests/bpf/tcp_client.py
+++ b/tools/testing/selftests/bpf/tcp_client.py
@@ -34,7 +34,7 @@ serverPort = int(sys.argv[1])
 # create active socket
 sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
 try:
-    sock.connect(('localhost', serverPort))
+    sock.connect(('::1', serverPort))
 except socket.error as e:
     sys.exit(1)
 
diff --git a/tools/testing/selftests/bpf/tcp_server.py b/tools/testing/selftests/bpf/tcp_server.py
index 0ca60d1..42ab888 100755
--- a/tools/testing/selftests/bpf/tcp_server.py
+++ b/tools/testing/selftests/bpf/tcp_server.py
@@ -38,7 +38,7 @@ serverSocket = None
 # create passive socket
 serverSocket = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
 
-try: serverSocket.bind(('localhost', 0))
+try: serverSocket.bind(('::1', 0))
 except socket.error as msg:
     print('bind fails: ' + str(msg))
 
diff --git a/tools/testing/selftests/bpf/test_netcnt.c b/tools/testing/selftests/bpf/test_netcnt.c
index c1da540..7a68c90 100644
--- a/tools/testing/selftests/bpf/test_netcnt.c
+++ b/tools/testing/selftests/bpf/test_netcnt.c
@@ -82,9 +82,9 @@ int main(int argc, char **argv)
 	}
 
 	if (system("which ping6 &>/dev/null") == 0)
-		assert(!system("ping6 localhost -c 10000 -f -q > /dev/null"));
+		assert(!system("ping6 ::1 -c 10000 -f -q > /dev/null"));
 	else
-		assert(!system("ping -6 localhost -c 10000 -f -q > /dev/null"));
+		assert(!system("ping -6 ::1 -c 10000 -f -q > /dev/null"));
 
 	if (bpf_prog_query(cgroup_fd, BPF_CGROUP_INET_EGRESS, 0, NULL, NULL,
 			   &prog_cnt)) {

