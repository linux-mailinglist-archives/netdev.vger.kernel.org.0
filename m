Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 735C221325
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 06:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfEQEeQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 May 2019 00:34:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726078AbfEQEeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 00:34:16 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4H4Qkhm030303
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 21:34:15 -0700
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2sh7c8b285-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 21:34:15 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 16 May 2019 21:34:14 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 7F6A5760DF6; Thu, 16 May 2019 21:34:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] selftests/bpf: fix bpf_get_current_task
Date:   Thu, 16 May 2019 21:34:11 -0700
Message-ID: <20190517043411.3796806-1-ast@kernel.org>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_02:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bpf_get_current_task() declaration.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/bpf_helpers.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/bpf_helpers.h b/tools/testing/selftests/bpf/bpf_helpers.h
index 6e80b66d7fb1..5f6f9e7aba2a 100644
--- a/tools/testing/selftests/bpf/bpf_helpers.h
+++ b/tools/testing/selftests/bpf/bpf_helpers.h
@@ -278,7 +278,7 @@ static int (*bpf_skb_change_type)(void *ctx, __u32 type) =
 	(void *) BPF_FUNC_skb_change_type;
 static unsigned int (*bpf_get_hash_recalc)(void *ctx) =
 	(void *) BPF_FUNC_get_hash_recalc;
-static unsigned long long (*bpf_get_current_task)(void *ctx) =
+static unsigned long long (*bpf_get_current_task)(void) =
 	(void *) BPF_FUNC_get_current_task;
 static int (*bpf_skb_change_tail)(void *ctx, __u32 len, __u64 flags) =
 	(void *) BPF_FUNC_skb_change_tail;
-- 
2.20.0

