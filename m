Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 393E325B22
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 02:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbfEVAZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 20:25:13 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39923 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfEVAZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 20:25:12 -0400
Received: by mail-pf1-f194.google.com with SMTP id z26so314637pfg.6
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 17:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WKdP+UEeopxgjQSMgreuh4UMPqlIGzPch7aMirej5P8=;
        b=FOEQ3T6KV+Zm+HLCKhE9E2PDvii1TMhAmtQjDsikEJm1s79QoDSjDJt4Cad3R7+9rc
         HE/Uv371YdzVJl1/pypCWFd8ppLHjPnuIm4TYAZZcrvGVt5zXy2Y5SI6MD88+AGN2sK5
         PDo4NCIE46howHVdeHO+6mccbk5izq8VH8M2CAPim7qqJU9Zya8I0kF0pG5umeuL0A9s
         cess3wJ8fj7tRqXYspbTwBIXNdr7hljz9xfwjfivfJKIs8wlctNJanbKm5iqejiEO5mA
         BDx/gFR9HBgNCib6r1N1DW+ZoFghU7ymdwK3OU9sOK18yY5T/WtCVQd7xat6kaL+sPVY
         MNIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WKdP+UEeopxgjQSMgreuh4UMPqlIGzPch7aMirej5P8=;
        b=GvgQgD2g701uMt4r+ZRL/gmPyUv6SDhsvtgUt+PeVuXMOJu9eBCiJVwYqpAwyxBOcw
         03I1TdkIaoKy4bWrDbgatP8sjfKXmjt/bEl7VmA7TJJJUkqjEz/gLqhZ6+UguLWSvnIc
         OiYcf5lI2QAguVMkBTz7pya3+NJS6/ZMEdMXAhViuYVr7RM5x8xfhM+9ypq6K5wndXzs
         JY62DO0+OKi1w76Lj+wdK1+lg5c2gwYQ6xWvkS98Dbp7Hya8tlYaWO0GHo7ZzannqvH7
         QdtlVSqZiaVWLk/Cqd0zJOmCnnH5DXAp5fiRI3vJyNmE6Qyt4qyxqd90W823Ae3dJP5g
         163A==
X-Gm-Message-State: APjAAAVNmxmH7U8l3R6Uu9OwsK+hOHJ2dBFlMe2ECyfZp3rhjprHwFdG
        sFyxcn9SXqiQIb4vusdXaTNG7s2vbg==
X-Google-Smtp-Source: APXvYqxA6xx2iNLtVXLyRD2XgE8zWijBHNWThbYBKbfZqEpDfWQXud+Y5KN8sozkyN9pvUmOppA7uw==
X-Received: by 2002:a62:4e86:: with SMTP id c128mr91271980pfb.39.1558484711831;
        Tue, 21 May 2019 17:25:11 -0700 (PDT)
Received: from localhost.localdomain ([114.71.48.108])
        by smtp.gmail.com with ESMTPSA id e24sm35488433pgl.94.2019.05.21.17.25.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 17:25:10 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH] samples: bpf: fix style in bpf_load
Date:   Wed, 22 May 2019 09:24:57 +0900
Message-Id: <20190522002457.10181-1-danieltimlee@gmail.com>
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

