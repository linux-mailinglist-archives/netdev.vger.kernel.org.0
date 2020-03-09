Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6577617E5C0
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 18:32:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgCIRcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 13:32:33 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22094 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727313AbgCIRcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 13:32:33 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029HQDhC007995
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 10:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2Hju96B+BmrqNX7ssIxx9VlnARZah3csAK7Ni9krg30=;
 b=C+23i7NDvbZ2J1Xg/micKuh4knuOPK67M/vzBy9Q4eZcRo4vBDRU8ybmlXwJ7ka/JH7Z
 3UvngCKBYdjNnYXEq6zT8BYOMjYQE1KYqET4Q83jeujM4+y7Z+ZiwOrNxkoFVdBHBQhu
 giDlA/h7tSKdG87Rmj+S0mTOGDzl7KrOUZo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymv6jnrxd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 10:32:32 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 10:32:31 -0700
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id CCE6962E27FD; Mon,  9 Mar 2020 10:32:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v6 bpf-next 2/4] bpftool: Documentation for bpftool prog profile
Date:   Mon, 9 Mar 2020 10:32:16 -0700
Message-ID: <20200309173218.2739965-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200309173218.2739965-1-songliubraving@fb.com>
References: <20200309173218.2739965-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003090110
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add documentation for the new bpftool prog profile command.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
---
 .../bpftool/Documentation/bpftool-prog.rst    | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-prog.rst b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
index 46862e85fed2..9f19404f470e 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -30,6 +30,7 @@ PROG COMMANDS
 |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
 |	**bpftool** **prog tracelog**
 |	**bpftool** **prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
+|	**bpftool** **prog profile** *PROG* [**duration** *DURATION*] *METRICs*
 |	**bpftool** **prog help**
 |
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
@@ -48,6 +49,9 @@ PROG COMMANDS
 |       *ATTACH_TYPE* := {
 |		**msg_verdict** | **stream_verdict** | **stream_parser** | **flow_dissector**
 |	}
+|	*METRIC* := {
+|		**cycles** | **instructions** | **l1d_loads** | **llc_misses**
+|	}
 
 
 DESCRIPTION
@@ -189,6 +193,12 @@ DESCRIPTION
 		  not all of them can take the **ctx_in**/**ctx_out**
 		  arguments. bpftool does not perform checks on program types.
 
+	**bpftool prog profile** *PROG* [**duration** *DURATION*] *METRICs*
+		  Profile *METRICs* for bpf program *PROG* for *DURATION*
+		  seconds or until user hits Ctrl-C. *DURATION* is optional.
+		  If *DURATION* is not specified, the profiling will run up to
+		  UINT_MAX seconds.
+
 	**bpftool prog help**
 		  Print short help message.
 
@@ -311,6 +321,15 @@ EXAMPLES
 
 **# rm /sys/fs/bpf/xdp1**
 
+|
+| **# bpftool prog profile id 337 duration 10 cycles instructions llc_misses**
+
+::
+         51397 run_cnt
+      40176203 cycles                                                 (83.05%)
+      42518139 instructions    #   1.06 insns per cycle               (83.39%)
+           123 llc_misses      #   2.89 LLC misses per million insns  (83.15%)
+
 SEE ALSO
 ========
 	**bpf**\ (2),
-- 
2.17.1

