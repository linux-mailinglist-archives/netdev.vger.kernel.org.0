Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715CF15CCD2
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 22:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgBMVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 16:01:33 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1574 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728053AbgBMVBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 16:01:30 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01DKwp2B030291
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Qow9JKY4oE3pQAjHYvfF82onevFNQU6h376iKCnwHIg=;
 b=Ahn3aNRi9jRjCEikkfhTvST4iph2slUyyXuBfLRoCLSAusDF5UTewwhb4M2Jf+YL8kIt
 5IFfErDEJW0u11KDxKjTMNyWU86evOHzZ05g+TXG3ZI2YSZSwhjCOopciRU0zLxvvNED
 poEHFstnDn3cvLLVtETa1PczTgDkW6OlgiY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2y53j937u2-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 13:01:29 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Thu, 13 Feb 2020 13:01:28 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 51DFD62E2004; Thu, 13 Feb 2020 13:01:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC bpf-next 4/4] bpftool: Documentation for bpftool prog profile
Date:   Thu, 13 Feb 2020 13:01:15 -0800
Message-ID: <20200213210115.1455809-5-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200213210115.1455809-1-songliubraving@fb.com>
References: <20200213210115.1455809-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-13_08:2020-02-12,2020-02-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 spamscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002130150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the new bpftool prog profile command.

Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpf/bpftool/Documentation/bpftool-prog.rst  | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 64ddf8a4c518..22ff0df327a1 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -30,6 +30,7 @@ PROG COMMANDS
 |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
 |	**bpftool** **prog tracelog**
 |	**bpftool** **prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
+|	**bpftool** **prog profile** *DURATION* *PROG* *METRICs*
 |	**bpftool** **prog help**
 |
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
@@ -47,6 +48,9 @@ PROG COMMANDS
 |       *ATTACH_TYPE* := {
 |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
 |	}
+|	*METRIC* := {
+|		**cycles** | **instructions** | **l1d_loads** | **llc_misses**
+|	}
 
 
 DESCRIPTION
@@ -188,6 +192,10 @@ DESCRIPTION
 		  not all of them can take the **ctx_in**/**ctx_out**
 		  arguments. bpftool does not perform checks on program types.
 
+	**bpftool prog profile** *DURATION* *PROG* *METRICs*
+		  Profile *METRICs* for bpf program *PROG* for *DURATION*
+		  seconds.
+
 	**bpftool prog help**
 		  Print short help message.
 
@@ -310,6 +318,15 @@ EXAMPLES
 
 **# rm /sys/fs/bpf/xdp1**
 
+|
+| **# bpftool prog profile 20 id 810 cycles instructions**
+
+::
+    cycles: duration 20 run_cnt 1368 miss_cnt 665
+            counter 503377 enabled 668202 running 351857
+    instructions: duration 20 run_cnt 1368 miss_cnt 707
+	    counter 398625 enabled 502330 running 272014
+
 SEE ALSO
 ========
 	**bpf**\ (2),
-- 
2.17.1

