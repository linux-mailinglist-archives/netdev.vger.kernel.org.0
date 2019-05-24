Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9D829EAE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404104AbfEXS7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 14:59:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58674 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404067AbfEXS7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 14:59:38 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4OIoWJX029977
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=o8eq6+QeZPlzz5cn9BNN0t0qkUFqfKE/reMPobLAKRE=;
 b=lbsJrS07yazV+zq5+Gcwvgbsb7PiEsbCEdKbvoo7Nd/3sPXcyibLD7aPTVMDFyx9IrFj
 qXFoKUSVeDu02pCpMogzzCeBuvvdcLnGvye6f+W6KY8lLlEAdHec7v9rL3bmH/UW81jN
 Z3U3U+b1zWz9TLp8k7ts/lV3EHz+nAmI1x8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2spgw719bv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 11:59:37 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 24 May 2019 11:59:35 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 2AB6D8613DC; Fri, 24 May 2019 11:59:33 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 11/12] bpftool/docs: add description of btf dump C option
Date:   Fri, 24 May 2019 11:59:06 -0700
Message-ID: <20190524185908.3562231-12-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190524185908.3562231-1-andriin@fb.com>
References: <20190524185908.3562231-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-24_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=949 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905240122
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document optional **c** option for btf dump subcommand.

Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../bpf/bpftool/Documentation/bpftool-btf.rst | 35 +++++++++++--------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 2dbc1413fabd..3daed9eba766 100644
--- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
+++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
@@ -19,10 +19,11 @@ SYNOPSIS
 BTF COMMANDS
 =============
 
-|	**bpftool** **btf dump** *BTF_SRC*
+|	**bpftool** **btf dump** *BTF_SRC* [**format** *FORMAT*]
 |	**bpftool** **btf help**
 |
 |	*BTF_SRC* := { **id** *BTF_ID* | **prog** *PROG* | **map** *MAP* [{**key** | **value** | **kv** | **all**}] | **file** *FILE* }
+|	*FORMAT* := { **raw** | **c** }
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 
@@ -31,23 +32,27 @@ DESCRIPTION
 	**bpftool btf dump** *BTF_SRC*
 		  Dump BTF entries from a given *BTF_SRC*.
 
-                  When **id** is specified, BTF object with that ID will be
-                  loaded and all its BTF types emitted.
+		  When **id** is specified, BTF object with that ID will be
+		  loaded and all its BTF types emitted.
 
-                  When **map** is provided, it's expected that map has
-                  associated BTF object with BTF types describing key and
-                  value. It's possible to select whether to dump only BTF
-                  type(s) associated with key (**key**), value (**value**),
-                  both key and value (**kv**), or all BTF types present in
-                  associated BTF object (**all**). If not specified, **kv**
-                  is assumed.
+		  When **map** is provided, it's expected that map has
+		  associated BTF object with BTF types describing key and
+		  value. It's possible to select whether to dump only BTF
+		  type(s) associated with key (**key**), value (**value**),
+		  both key and value (**kv**), or all BTF types present in
+		  associated BTF object (**all**). If not specified, **kv**
+		  is assumed.
 
-                  When **prog** is provided, it's expected that program has
-                  associated BTF object with BTF types.
+		  When **prog** is provided, it's expected that program has
+		  associated BTF object with BTF types.
 
-                  When specifying *FILE*, an ELF file is expected, containing
-                  .BTF section with well-defined BTF binary format data,
-                  typically produced by clang or pahole.
+		  When specifying *FILE*, an ELF file is expected, containing
+		  .BTF section with well-defined BTF binary format data,
+		  typically produced by clang or pahole.
+
+		  **format** option can be used to override default (raw)
+		  output format. Raw (**raw**) or C-syntax (**c**) output
+		  formats are supported.
 
 	**bpftool btf help**
 		  Print short help message.
-- 
2.17.1

