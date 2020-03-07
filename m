Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD4B17C989
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 01:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbgCGAR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 19:17:28 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60154 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgCGAR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 19:17:28 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0270EW1f028158
        for <netdev@vger.kernel.org>; Fri, 6 Mar 2020 16:17:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2Hju96B+BmrqNX7ssIxx9VlnARZah3csAK7Ni9krg30=;
 b=n0i/0cYb/YgBgGEF2cX402++N+6NLkrx886jft1M3RKcjEJWaooo6Z+K20aDo2dgb645
 pzaRz/8dy/uETfk5dbUStfbnO0CE0JFpb0LSE5HVbeaiKQ0J+ekQ54ELzHw6z0wjuOQy
 GUBvMYm7lSR2c0h6nUe4HX5Y0I/qWdpsHeA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ykuub9fpv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 16:17:27 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 6 Mar 2020 16:17:26 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id C55F262E2880; Fri,  6 Mar 2020 16:17:24 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <quentin@isovalent.com>, <kernel-team@fb.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <arnaldo.melo@gmail.com>,
        <jolsa@kernel.org>, Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v5 bpf-next 2/4] bpftool: Documentation for bpftool prog profile
Date:   Fri, 6 Mar 2020 16:17:11 -0800
Message-ID: <20200307001713.3559880-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307001713.3559880-1-songliubraving@fb.com>
References: <20200307001713.3559880-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-06_09:2020-03-06,2020-03-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003070000
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

