Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B814534A552
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 11:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCZKLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 06:11:04 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:14564 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbhCZKKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 06:10:32 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4F6Hj92z0vzPmls;
        Fri, 26 Mar 2021 18:07:57 +0800 (CST)
Received: from huawei.com (10.175.103.91) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.498.0; Fri, 26 Mar 2021
 18:10:25 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH -next 3/3] net: llc: Correct function name llc_pdu_set_pf_bit() in header
Date:   Fri, 26 Mar 2021 18:13:50 +0800
Message-ID: <20210326101350.2519614-4-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210326101350.2519614-1-yangyingliang@huawei.com>
References: <20210326101350.2519614-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following make W=1 kernel build warning:

 net/llc/llc_pdu.c:36: warning: expecting prototype for pdu_set_pf_bit(). Prototype was for llc_pdu_set_pf_bit() instead

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 net/llc/llc_pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/llc/llc_pdu.c b/net/llc/llc_pdu.c
index 792d195c8bae..63749dde542f 100644
--- a/net/llc/llc_pdu.c
+++ b/net/llc/llc_pdu.c
@@ -24,7 +24,7 @@ void llc_pdu_set_cmd_rsp(struct sk_buff *skb, u8 pdu_type)
 }
 
 /**
- *	pdu_set_pf_bit - sets poll/final bit in LLC header
+ *	llc_pdu_set_pf_bit - sets poll/final bit in LLC header
  *	@skb: Frame to set bit in
  *	@bit_value: poll/final bit (0 or 1).
  *
-- 
2.25.1

