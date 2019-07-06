Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC8A60F26
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 08:02:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726095AbfGFGCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 02:02:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46058 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725970AbfGFGCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 02:02:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x665xojQ004391
        for <netdev@vger.kernel.org>; Fri, 5 Jul 2019 23:02:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=qhThk0tuwFPln/ZyPJ9/BCvDuQDm0tsSao7La1AqfkU=;
 b=hYn95/srk5APsAQEogXIAABQeAy2suXGOUp8YALdFpVWx41lVfg9h/DdEh1Mf3LPuq2E
 3yDnZQ+eHwHNEsHxPUwYgWpVjLYcyn6hiEbott8cVmkf2EcAa/bI9SDz6gVxPpatxXWw
 yGaCYp/OMXs0atEkSOm/LtzR/XgKBgNi7nw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tj2kqbk15-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 23:02:36 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 5 Jul 2019 23:02:34 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 9766B86161D; Fri,  5 Jul 2019 23:02:34 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v6 bpf-next 5/5] libbpf: add perf_buffer_ prefix to README
Date:   Fri, 5 Jul 2019 23:02:20 -0700
Message-ID: <20190706060220.1801632-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190706060220.1801632-1-andriin@fb.com>
References: <20190706060220.1801632-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060078
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

perf_buffer "object" is part of libbpf API now, add it to the list of
libbpf function prefixes.

Suggested-by: Daniel Borkman <daniel@iogearbox.net>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/README.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/README.rst b/tools/lib/bpf/README.rst
index cef7b77eab69..8928f7787f2d 100644
--- a/tools/lib/bpf/README.rst
+++ b/tools/lib/bpf/README.rst
@@ -9,7 +9,8 @@ described here. It's recommended to follow these conventions whenever a
 new function or type is added to keep libbpf API clean and consistent.
 
 All types and functions provided by libbpf API should have one of the
-following prefixes: ``bpf_``, ``btf_``, ``libbpf_``, ``xsk_``.
+following prefixes: ``bpf_``, ``btf_``, ``libbpf_``, ``xsk_``,
+``perf_buffer_``.
 
 System call wrappers
 --------------------
-- 
2.17.1

