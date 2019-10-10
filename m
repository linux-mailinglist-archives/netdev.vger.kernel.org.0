Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B64ED1FA5
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 06:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfJJEZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 00:25:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8034 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbfJJEZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 00:25:40 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9A4OlSq031949
        for <netdev@vger.kernel.org>; Wed, 9 Oct 2019 21:25:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=rFt+ElRDA7ZBEXGDS3tpQyrVLoVQSgrBjpwlYXwsh5Y=;
 b=hjymnCw/ipB0two007/sl+cIe72pyQ+BJybwG1bFLWMg0oVtoOQdubZqwPvj0m7FtsUn
 lx7qv/ruN1gKrWdh5EGCEAKhaWZ8Ptt8wza1jl+VPmt3i65hQGpwymjNalPER0f00IMt
 WDh2/U4fhykP4bgGmM0Sf2ILfC797HpXsEc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vht50gkvu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 09 Oct 2019 21:25:38 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Oct 2019 21:25:37 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 0D2048618C9; Wed,  9 Oct 2019 21:25:36 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] scripts/bpf: fix xdp_md forward declaration typo
Date:   Wed, 9 Oct 2019 21:25:34 -0700
Message-ID: <20191010042534.290562-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_02:2019-10-08,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 mlxlogscore=762 phishscore=0 impostorscore=0 suspectscore=9
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910100039
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix typo in struct xpd_md, generated from bpf_helpers_doc.py, which is
causing compilation warnings for programs using bpf_helpers.h

Fixes: 7a387bed47f7 ("scripts/bpf: teach bpf_helpers_doc.py to dump BPF helper definitions")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 scripts/bpf_helpers_doc.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 15d3d83d6297..7df9ce598ff9 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -418,7 +418,7 @@ class PrinterHelpers(Printer):
 
             'struct __sk_buff',
             'struct sk_msg_md',
-            'struct xpd_md',
+            'struct xdp_md',
     ]
     known_types = {
             '...',
-- 
2.17.1

