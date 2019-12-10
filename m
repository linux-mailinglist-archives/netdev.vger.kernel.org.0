Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F110117D08
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfLJBPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:15:30 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26152 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727773AbfLJBP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:15:27 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA1BCof019450
        for <netdev@vger.kernel.org>; Mon, 9 Dec 2019 17:15:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=qoQnl4Q8PMXkMLEQ3ky0X4fTwA8dHghjtxQU5dM5zG4=;
 b=eGCQ7s7ltyB/5IxXqNCTi2RYCq37wyaxMtal7XgnDV429bm8nL7wWCRZT1kmeV6AwKbZ
 UGRMsUosL5tBKj+qc0C9YCj9Dc/UlavXgPn3JGpqgCFR61XAnhPYgNSL/T86z9InZAzk
 qH64py9rE72ukCudLqS9AR5Hz/o7IDUeVwI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wt0cx09vh-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 17:15:26 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 17:15:22 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 928D12EC16B5; Mon,  9 Dec 2019 17:15:20 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 15/15] bpftool: add `gen skeleton` BASH completions
Date:   Mon, 9 Dec 2019 17:14:38 -0800
Message-ID: <20191210011438.4182911-16-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210011438.4182911-1-andriin@fb.com>
References: <20191210011438.4182911-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 lowpriorityscore=0 mlxlogscore=918
 clxscore=1015 malwarescore=0 spamscore=0 phishscore=0 suspectscore=8
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912100009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add BASH completions for gen sub-command.

Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/bash-completion/bpftool | 11 +++++++++++
 tools/bpf/bpftool/main.c                  |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
index 70493a6da206..986519cc58d1 100644
--- a/tools/bpf/bpftool/bash-completion/bpftool
+++ b/tools/bpf/bpftool/bash-completion/bpftool
@@ -716,6 +716,17 @@ _bpftool()
                     ;;
             esac
             ;;
+        gen)
+            case $command in
+                skeleton)
+                    _filedir
+		    ;;
+                *)
+                    [[ $prev == $object ]] && \
+                        COMPREPLY=( $( compgen -W 'skeleton help' -- "$cur" ) )
+                    ;;
+            esac
+            ;;
         cgroup)
             case $command in
                 show|list|tree)
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 758b294e8a7d..1fe91c558508 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -58,7 +58,7 @@ static int do_help(int argc, char **argv)
 		"       %s batch file FILE\n"
 		"       %s version\n"
 		"\n"
-		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf }\n"
+		"       OBJECT := { prog | map | cgroup | perf | net | feature | btf | gen }\n"
 		"       " HELP_SPEC_OPTIONS "\n"
 		"",
 		bin_name, bin_name, bin_name);
-- 
2.17.1

