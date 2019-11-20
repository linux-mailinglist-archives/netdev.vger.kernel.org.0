Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CAA21038D1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 12:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729245AbfKTLgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 06:36:18 -0500
Received: from mailout1.hostsharing.net ([83.223.95.204]:53355 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727586AbfKTLgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 06:36:18 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id ED415101933DF;
        Wed, 20 Nov 2019 12:36:16 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id A808660E00CD;
        Wed, 20 Nov 2019 12:36:16 +0100 (CET)
X-Mailbox-Line: From 348a3eb1c4348391e1836d858f24bd118934703f Mon Sep 17 00:00:00 2001
Message-Id: <348a3eb1c4348391e1836d858f24bd118934703f.1574247360.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Wed, 20 Nov 2019 12:33:59 +0100
Subject: [PATCH nf-next] netfilter: Document ingress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Amend kerneldoc of struct net_device to fix a "make htmldocs" warning:

include/linux/netdevice.h:2045: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
Resending this patch without RFC tag on Pablo's request since it's just
an uncontroversial cleanup.

Previous submission:
https://lore.kernel.org/netfilter-devel/442372563baf1a33ff48f8993be069960a7aea52.1572528496.git.lukas@wunner.de/

 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9e6fb8524d91..4b2f40f3a588 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1703,6 +1703,7 @@ enum netdev_priv_flags {
  *	@miniq_ingress:		ingress/clsact qdisc specific data for
  *				ingress processing
  *	@ingress_queue:		XXX: need comments on this one
+ *	@nf_hooks_ingress:	netfilter hooks executed for ingress packets
  *	@broadcast:		hw bcast address
  *
  *	@rx_cpu_rmap:	CPU reverse-mapping for RX completion interrupts,
-- 
2.24.0

