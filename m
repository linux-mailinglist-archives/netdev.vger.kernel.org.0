Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8833C201DF3
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729227AbgFSWUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:20:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729163AbgFSWU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 18:20:29 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 05JM3rp2003952
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 15:20:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=WK7HQ/LBtBVqfsOLYU2138qi2tabx0PY8d+lO7GdfPw=;
 b=kTtCrxBxxWJydKbiIw5mbeZiwB4KATttln/6aNYMxmkpJX4mGj4OKLuJUV3iKrVTTBu1
 DocId9BikxiikIpIpzK0GeL0anILrccYn0QOEW95UbX3oZMju7eM/yf5VpdTQW8xlyYl
 c9/pvxi3Rm1PTvL3hi218vRTG0P+2CKB1q4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 31q64572nx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 15:20:27 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 19 Jun 2020 15:20:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DE7EB2EC3537; Fri, 19 Jun 2020 15:20:25 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Quentin Monnet <quentin@isovalent.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] tools/bpftool: relicense bpftool's BPF profiler prog as dual-license GPL/BSD
Date:   Fri, 19 Jun 2020 15:20:24 -0700
Message-ID: <20200619222024.519774-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-19_22:2020-06-19,2020-06-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 impostorscore=0 cotscore=-2147483648 suspectscore=8 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=623 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006190155
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Relicense it to be compatible with the rest of bpftool files.

Cc: Song Liu <songliubraving@fb.com>
Suggested-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/skeleton/profiler.bpf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/bpf/bpftool/skeleton/profiler.bpf.c b/tools/bpf/bpftoo=
l/skeleton/profiler.bpf.c
index 20034c12f7c5..c9d196ddb670 100644
--- a/tools/bpf/bpftool/skeleton/profiler.bpf.c
+++ b/tools/bpf/bpftool/skeleton/profiler.bpf.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
 // Copyright (c) 2020 Facebook
 #include "profiler.h"
 #include <linux/bpf.h>
@@ -116,4 +116,4 @@ int BPF_PROG(fexit_XXX)
 	return 0;
 }
=20
-char LICENSE[] SEC("license") =3D "GPL";
+char LICENSE[] SEC("license") =3D "Dual BSD/GPL";
--=20
2.24.1

