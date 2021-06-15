Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83043A8182
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFON7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:59:01 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:4789 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhFON66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 09:58:58 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G48r614jdzXfym;
        Tue, 15 Jun 2021 21:51:50 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 15
 Jun 2021 21:56:47 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf-next] samples/bpf: Add missing option to xdp_fwd usage
Date:   Tue, 15 Jun 2021 21:55:54 +0800
Message-ID: <20210615135554.29158-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_fwd usage() is missing the introduction of the "-S"
and "-F" options, this patch adds it.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 samples/bpf/xdp_fwd_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index 74a4583d0d86..00061261a8da 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -67,6 +67,8 @@ static void usage(const char *prog)
 		"usage: %s [OPTS] interface-list\n"
 		"\nOPTS:\n"
 		"    -d    detach program\n"
+		"    -S    use skb-mode\n"
+		"    -F    force loading prog\n"
 		"    -D    direct table lookups (skip fib rules)\n",
 		prog);
 }
-- 
2.17.1

