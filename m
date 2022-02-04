Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5413A4A9BD0
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359636AbiBDPTV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:21 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50396 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359630AbiBDPTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:17 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1AA83601A0;
        Fri,  4 Feb 2022 16:19:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 5/6] MAINTAINERS: netfilter: update git links
Date:   Fri,  4 Feb 2022 16:19:02 +0100
Message-Id: <20220204151903.320786-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

nf and nf-next have a new location.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb83dcbcb619..3a9cb567d47c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13297,8 +13297,8 @@ W:	http://www.iptables.org/
 W:	http://www.nftables.org/
 Q:	http://patchwork.ozlabs.org/project/netfilter-devel/list/
 C:	irc://irc.libera.chat/netfilter
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git
 F:	include/linux/netfilter*
 F:	include/linux/netfilter/
 F:	include/net/netfilter/
-- 
2.30.2

