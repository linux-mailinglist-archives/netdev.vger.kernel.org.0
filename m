Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D08817978B
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730085AbgCDSHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:07:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8682 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727543AbgCDSHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:07:50 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 024I7dgk014977
        for <netdev@vger.kernel.org>; Wed, 4 Mar 2020 10:07:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2Hju96B+BmrqNX7ssIxx9VlnARZah3csAK7Ni9krg30=;
 b=S2V1PzXiBMHTpnEMZErDmfJxug5w3p73qsBAtZInbWUSq+8EsA3k21CnJiKDxg9U6P9D
 f2P9+slrJ1ptouxl6zrpjYTf5WzA4BHktJh0PLlMjsGLGPSEns1DcgKLSHBB+j+8qMCC
 iZzOmrVuwTIVLzTqvGYdOK4R+rjqZhaUIT4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yhwxxnu7m-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:07:49 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 4 Mar 2020 10:07:19 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id A565F62E3375; Wed,  4 Mar 2020 10:07:18 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 2/4] bpftool: Documentation for bpftool prog profile
Date:   Wed, 4 Mar 2020 10:07:08 -0800
Message-ID: <20200304180710.2677695-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304180710.2677695-1-songliubraving@fb.com>
References: <20200304180710.2677695-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-04_07:2020-03-04,2020-03-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 adultscore=0 phishscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003040124
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

