Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F2914A87
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 15:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726085AbfEFNDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 09:03:41 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:46612 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfEFNDl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 09:03:41 -0400
Received: by mail-pg1-f196.google.com with SMTP id t187so2310601pgb.13
        for <netdev@vger.kernel.org>; Mon, 06 May 2019 06:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WKdP+UEeopxgjQSMgreuh4UMPqlIGzPch7aMirej5P8=;
        b=AV5QDLEu1wdmXRBBfi8ckacZGpEIKwp1xLQmzL8b8Thy5LjDNjHtGYlFTVplHlKepR
         ux9pKBXBdBITSsr7NnPcSLbveiO052ZLiv2q5ebVPRDHMf4fg5UkRr9lYKr0ekED5ffL
         00ps7VA7RweK/2HfSKvmeiImOJQrwhnjnb13rIaOWpomuiQSMNNrpg+J4b0fT/ajHl6m
         jp7Nw7eV6obaZOGJFmkwGBfYPeWy9XZDD5yTsjlwRx1jms+G8m9kXYXepSPDRlEHAWYo
         VeG6MDWV6Pn4QiZC5WDgOH1Q3M9EFrAQjDrAZLqpk5chnPzpSOb1PTlpL2JBaHNlctQz
         nU2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WKdP+UEeopxgjQSMgreuh4UMPqlIGzPch7aMirej5P8=;
        b=kQftVwVANCQSjvtA93fxHPnYzJWY6n6aY0taLwBGg+sf4mlk1+J5KMyJXvdNLa81iW
         NK206/DFMz0Eh2fDqr3q7A7h+ZvXGTzsGwYG8Z2Eg+rE6K5bKx9t7HIVnlVl1Ec6lBLE
         8GDElIJ4B5aWqdcJzZ96uqy9vRLMTQw1ggczMLJ0JGVWmqTfJ8l6KMNqXitYj1t7AAv1
         nZOJzdcY3Q0JmlLIISnzXvhoBS6+wAMlXCf1T69D9+Y7TNeTHxcla/gThgCxXOXL4uEa
         edyWOXTIR+loYCyP1U0wxGMY8HOrdoNst5mH+jRDGnZd5bgNEWistgpd+DxInFjA/tn7
         FExA==
X-Gm-Message-State: APjAAAWGUHCW9/ikFEyhUjZZ73e/O8M92arQgID0h7CAyKt5QmCobOd4
        m1A6yei7Jre/j83jjOdnDxA9bwuywA==
X-Google-Smtp-Source: APXvYqyYnHvbEaiBPBiZj2us4ArsiPRnQGVQhihFfrBhwbS29nZiaoHjBTPdBWoD2YfoLCezUaj7Qw==
X-Received: by 2002:a65:4b88:: with SMTP id t8mr31654704pgq.374.1557147820449;
        Mon, 06 May 2019 06:03:40 -0700 (PDT)
Received: from localhost.localdomain ([114.71.48.108])
        by smtp.gmail.com with ESMTPSA id h4sm110128pgn.13.2019.05.06.06.03.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 May 2019 06:03:39 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] samples: bpf: fix style in bpf_load
Date:   Mon,  6 May 2019 22:03:10 +0900
Message-Id: <20190506130310.12803-1-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes style problem in samples/bpf/bpf_load.c

Styles that have been changed are:
 - Magic string use of 'DEBUGFS'
 - Useless zero initialization of a global variable
 - Minor style fix with whitespace

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/bpf_load.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/bpf_load.c b/samples/bpf/bpf_load.c
index eae7b635343d..e71d23d2a0ff 100644
--- a/samples/bpf/bpf_load.c
+++ b/samples/bpf/bpf_load.c
@@ -40,7 +40,7 @@ int prog_cnt;
 int prog_array_fd = -1;
 
 struct bpf_map_data map_data[MAX_MAPS];
-int map_data_count = 0;
+int map_data_count;
 
 static int populate_prog_array(const char *event, int prog_fd)
 {
@@ -57,6 +57,7 @@ static int populate_prog_array(const char *event, int prog_fd)
 static int write_kprobe_events(const char *val)
 {
 	int fd, ret, flags;
+	char buf[256];
 
 	if (val == NULL)
 		return -1;
@@ -65,7 +66,9 @@ static int write_kprobe_events(const char *val)
 	else
 		flags = O_WRONLY | O_APPEND;
 
-	fd = open("/sys/kernel/debug/tracing/kprobe_events", flags);
+	strcpy(buf, DEBUGFS);
+	strcat(buf, "kprobe_events");
+	fd = open(buf, flags);
 
 	ret = write(fd, val, strlen(val));
 	close(fd);
@@ -490,8 +493,8 @@ static int load_elf_maps_section(struct bpf_map_data *maps, int maps_shndx,
 
 		/* Verify no newer features were requested */
 		if (validate_zero) {
-			addr = (unsigned char*) def + map_sz_copy;
-			end  = (unsigned char*) def + map_sz_elf;
+			addr = (unsigned char *) def + map_sz_copy;
+			end  = (unsigned char *) def + map_sz_elf;
 			for (; addr < end; addr++) {
 				if (*addr != 0) {
 					free(sym);
-- 
2.17.1

