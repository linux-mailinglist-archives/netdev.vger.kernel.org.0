Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5682174369
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 00:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgB1XlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 18:41:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58358 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726277AbgB1XlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 18:41:08 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SNehbH004304
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:41:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=j/6SXOvCctfR5eluAvXtIqLImVqnk3gXRJKCdN6HMh8=;
 b=Al7MtMtk4rc4VIIw2XYLxA/qaCPLo+IfepRZ7ep/lP9JzHkcPoaj8SSdzfivuz4lFDbR
 hXOzcY7TwKnWajq61qKnaYPQWwaBW+kLCEHVJ21GfE7gnAAqvBDYPQmXzBI/fPz6+i/q
 OyTymlf/qlIRAVEXhyCmW4azK4PJFlz7BUo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yepvgx4xt-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 15:41:06 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 28 Feb 2020 15:41:05 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 3600B62E0BA7; Fri, 28 Feb 2020 15:41:05 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Song Liu <songliubraving@fb.com>
Smtp-Origin-Hostname: devbig006.ftw2.facebook.com
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <arnaldo.melo@gmail.com>, <jolsa@kernel.org>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/2] bpftool: Documentation for bpftool prog profile
Date:   Fri, 28 Feb 2020 15:40:58 -0800
Message-ID: <20200228234058.634044-3-songliubraving@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200228234058.634044-1-songliubraving@fb.com>
References: <20200228234058.634044-1-songliubraving@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_09:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002280172
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
index 46862e85fed2..1e2549dcd926 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-prog.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-prog.rst
@@ -30,6 +30,7 @@ PROG COMMANDS
 |	**bpftool** **prog detach** *PROG* *ATTACH_TYPE* [*MAP*]
 |	**bpftool** **prog tracelog**
 |	**bpftool** **prog run** *PROG* **data_in** *FILE* [**data_out** *FILE* [**data_size_out** *L*]] [**ctx_in** *FILE* [**ctx_out** *FILE* [**ctx_size_out** *M*]]] [**repeat** *N*]
+|	**bpftool** **prog profile** [*DURATION*] *PROG* *METRICs*
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
@@ -189,6 +193,10 @@ DESCRIPTION
 		  not all of them can take the **ctx_in**/**ctx_out**
 		  arguments. bpftool does not perform checks on program types.
 
+	**bpftool prog profile** *DURATION* *PROG* *METRICs*
+		  Profile *METRICs* for bpf program *PROG* for *DURATION*
+		  seconds.
+
 	**bpftool prog help**
 		  Print short help message.
 
@@ -311,6 +319,15 @@ EXAMPLES
 
 **# rm /sys/fs/bpf/xdp1**
 
+|
+| **# bpftool prog profile 10 id 337 cycles instructions llc_misses**
+
+::
+         51397 run_cnt
+      40176203 cycles                                                 (83.05%)
+      42518139 instructions    #   1.06 insn per cycle                (83.39%)
+           123 llc_misses      #   2.89 LLC misses per million isns   (83.15%)
+
 SEE ALSO
 ========
 	**bpf**\ (2),
-- 
2.17.1

