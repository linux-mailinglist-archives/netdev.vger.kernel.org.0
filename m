Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F09BB28BB8
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388301AbfEWUmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:42:54 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41366 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388267AbfEWUmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:42:51 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4NKdKFg008070
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2LziJTaXAaHqKEJHXUW/lkbgqv3ba2lyRBedUCowivE=;
 b=Z7ri1ay2emm+n66a+xb1iPgFmCvGbSz6MWmzXRNF5ak/8ALu6w4rOGW3yXjk+bwFCJSc
 tHRCeuSae1P94/RUSXuFglIU6/HSqEsMy2JbFq3C+Ovs7x84rRzeIae2QMJI2vbGmrx5
 6/Dpxs+1wyRAHCiqr4WWTTwAGkS/U90mP6c= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2snvfs9h5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 May 2019 13:42:49 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 23 May 2019 13:42:48 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 26580861799; Thu, 23 May 2019 13:42:48 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 11/12] bpftool/docs: add description of btf dump C option
Date:   Thu, 23 May 2019 13:42:21 -0700
Message-ID: <20190523204222.3998365-12-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190523204222.3998365-1-andriin@fb.com>
References: <20190523204222.3998365-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-23_17:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=777 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905230133
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document optional **c** option for btf dump subcommand.

Cc: Quentin Monnet <quentin.monnet@netronome.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/Documentation/bpftool-btf.rst | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
index 2dbc1413fabd..1aec7dc039e9 100644
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
+|       *FORMAT* := { **raw** | **c** }
 |	*MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
 |	*PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
 
@@ -49,6 +50,10 @@ DESCRIPTION
                   .BTF section with well-defined BTF binary format data,
                   typically produced by clang or pahole.
 
+                  **format** option can be used to override default (raw)
+                  output format. Raw (**raw**) or C-syntax (**c**) output
+                  formats are supported.
+
 	**bpftool btf help**
 		  Print short help message.
 
-- 
2.17.1

