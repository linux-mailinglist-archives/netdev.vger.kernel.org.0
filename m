Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4AE44233E
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 23:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbhKAWS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 18:18:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:59212 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbhKAWSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 18:18:23 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6C5AF63F4E;
        Mon,  1 Nov 2021 23:13:55 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/2] ipvs: autoload ipvs on genl access
Date:   Mon,  1 Nov 2021 23:15:28 +0100
Message-Id: <20211101221528.236114-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211101221528.236114-1-pablo@netfilter.org>
References: <20211101221528.236114-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

The kernel provides the functionality to automatically load modules
providing genl families. Use this to remove the need for users to
manually load the module.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Acked-by: Julian Anastasov <ja@ssi.bg>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 29ec3ef63edc..0ff94c66641f 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -48,6 +48,8 @@
 
 #include <net/ip_vs.h>
 
+MODULE_ALIAS_GENL_FAMILY(IPVS_GENL_NAME);
+
 /* semaphore for IPVS sockopts. And, [gs]etsockopt may sleep. */
 static DEFINE_MUTEX(__ip_vs_mutex);
 
-- 
2.30.2

