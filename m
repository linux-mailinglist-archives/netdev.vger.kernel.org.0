Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7039AE42B9
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 06:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391353AbfJYEzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 00:55:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5292 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733019AbfJYEzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 00:55:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9P4qxCe030652
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 21:55:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zcsbUGKA5Tuu/D5R+w2r5vRZEW/enRkqli2tntJvlBQ=;
 b=ksKdgdaMWJKNurnZCV3w8Z5mq6JYmFRI2f1EETqf7MhW1D5PrzCFuK6qT2cxXOUBbvRZ
 toEKvHQGg7n+xUlefYKMnJD1JQZstSqk3QnNhD3g67+3M4exrxTqkpwzdvO0XKzHFoEU
 WRoeW7NlbCuL4t0Xivn/IduI/BiCkbqPknU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vujkhsr4p-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 21:55:12 -0700
Received: from 2401:db00:12:9028:face:0:29:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Oct 2019 21:55:10 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 164998630DE; Thu, 24 Oct 2019 21:55:05 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <yhs@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] selftests/bpf: fix .gitignore to ignore no_alu32/
Date:   Thu, 24 Oct 2019 21:55:03 -0700
Message-ID: <20191025045503.3043427-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-25_02:2019-10-23,2019-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 malwarescore=0 bulkscore=0 clxscore=1015 suspectscore=9 priorityscore=1501
 mlxscore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxlogscore=858 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910250046
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When switching to alu32 by default, no_alu32/ subdirectory wasn't added
to .gitignore. Fix it.

Fixes: e13a2fe642bd ("tools/bpf: Turn on llvm alu32 attribute by default")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 6f46170e09c1..4865116b96c7 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -37,5 +37,5 @@ libbpf.so.*
 test_hashmap
 test_btf_dump
 xdping
-/alu32
+/no_alu32
 /bpf_gcc
-- 
2.17.1

