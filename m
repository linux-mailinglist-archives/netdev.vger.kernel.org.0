Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CED93A8197
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbhFOOAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 10:00:34 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6509 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhFOOA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 10:00:27 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4G48wF2gk2zZhS5;
        Tue, 15 Jun 2021 21:55:25 +0800 (CST)
Received: from huawei.com (10.175.104.82) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 15
 Jun 2021 21:58:17 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <hawk@kernel.org>,
        <john.fastabend@gmail.com>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH bpf-next] samples/bpf: Add missing option to xdp_sample_pkts usage
Date:   Tue, 15 Jun 2021 21:57:24 +0800
Message-ID: <20210615135724.29528-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xdp_sample_pkts usage() is missing the introduction of the
"-S" option, this patch adds it.

Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 samples/bpf/xdp_sample_pkts_user.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
index 706475e004cb..495e09897bd3 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -103,7 +103,8 @@ static void usage(const char *prog)
 	fprintf(stderr,
 		"%s: %s [OPTS] <ifname|ifindex>\n\n"
 		"OPTS:\n"
-		"    -F    force loading prog\n",
+		"    -F    force loading prog\n"
+		"    -S    use skb-mode\n",
 		__func__, prog);
 }
 
-- 
2.17.1

