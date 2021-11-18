Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B48C4565AC
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbhKRW3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:29:40 -0500
Received: from mail.netfilter.org ([217.70.188.207]:58276 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbhKRW3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:29:33 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 31884649B7;
        Thu, 18 Nov 2021 23:24:24 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 03/11] netfilter: nft_payload: Remove duplicated include in nft_payload.c
Date:   Thu, 18 Nov 2021 23:26:10 +0100
Message-Id: <20211118222618.433273-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211118222618.433273-1-pablo@netfilter.org>
References: <20211118222618.433273-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wan Jiabing <wanjiabing@vivo.com>

Fix following checkincludes.pl warning:
./net/netfilter/nft_payload.c: linux/ip.h is included more than once.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_payload.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index cbfe4e4a4ad7..bd689938a2e0 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -22,7 +22,6 @@
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <linux/ip.h>
 #include <net/sctp/checksum.h>
 
 static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
-- 
2.30.2

