Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7681629D3B6
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 22:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbgJ1VqW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Oct 2020 17:46:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:55768 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726348AbgJ1VqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 17:46:17 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 09SHxEYM019649
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 11:12:18 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 34f0jn3x9x-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 11:12:17 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 28 Oct 2020 11:12:13 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 46A902EC875F; Wed, 28 Oct 2020 11:12:09 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next] bpf: add struct bpf_redir_neigh forward declaration to BPF helper defs
Date:   Wed, 28 Oct 2020 11:12:04 -0700
Message-ID: <20201028181204.111241-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-28_08:2020-10-28,2020-10-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=628 phishscore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0
 suspectscore=9 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010280118
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forward-declare struct bpf_redir_neigh in bpf_helper_defs.h to avoid
compiler warning about unknown structs.

Fixes: ba452c9e996d ("bpf: Fix bpf_redirect_neigh helper api to support supplying nexthop")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 scripts/bpf_helpers_doc.py | 1 +
 1 file changed, 1 insertion(+)

diff --git a/scripts/bpf_helpers_doc.py b/scripts/bpf_helpers_doc.py
index 6769caae142f..31484377b8b1 100755
--- a/scripts/bpf_helpers_doc.py
+++ b/scripts/bpf_helpers_doc.py
@@ -408,6 +408,7 @@ class PrinterHelpers(Printer):
             'struct bpf_perf_event_data',
             'struct bpf_perf_event_value',
             'struct bpf_pidns_info',
+            'struct bpf_redir_neigh',
             'struct bpf_sock',
             'struct bpf_sock_addr',
             'struct bpf_sock_ops',
-- 
2.24.1

