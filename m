Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDDC34893B
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhCYGhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:37:39 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:14891 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbhCYGhH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:37:07 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4F5b2R5jMkzkfY4;
        Thu, 25 Mar 2021 14:35:27 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.498.0; Thu, 25 Mar 2021
 14:37:04 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <idryomov@gmail.com>, <jlayton@kernel.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ceph-devel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xiyou.wangcong@gmail.com>, <ap420073@gmail.com>,
        <linux-decnet-user@lists.sourceforge.net>, <andrew@lunn.ch>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <olteanv@gmail.com>, <steffen.klassert@secunet.com>,
        <herbert@gondor.apana.org.au>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>
Subject: [PATCH -next 5/5] net: ipv4: Fix some typos
Date:   Thu, 25 Mar 2021 14:38:25 +0800
Message-ID: <20210325063825.228167-6-luwei32@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210325063825.228167-1-luwei32@huawei.com>
References: <20210325063825.228167-1-luwei32@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modify "accomodate" to "accommodate" in net/ipv4/esp4.c.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/ipv4/esp4.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index a3271ec3e162..1ae920b93f39 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -309,7 +309,7 @@ static struct ip_esp_hdr *esp_output_set_extra(struct sk_buff *skb,
 					       struct esp_output_extra *extra)
 {
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * encryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
@@ -854,7 +854,7 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
 	struct ip_esp_hdr *esph;
 
 	/* For ESN we move the header forward by 4 bytes to
-	 * accomodate the high bits.  We will move it back after
+	 * accommodate the high bits.  We will move it back after
 	 * decryption.
 	 */
 	if ((x->props.flags & XFRM_STATE_ESN)) {
-- 
2.17.1

