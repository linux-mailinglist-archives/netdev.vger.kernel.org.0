Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB3EB1A8
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 14:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbfJaNxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 09:53:11 -0400
Received: from mailout3.hostsharing.net ([176.9.242.54]:32839 "EHLO
        mailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727511AbfJaNxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 09:53:11 -0400
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2019 09:53:10 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id F3212101E6A30;
        Thu, 31 Oct 2019 14:47:57 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 8B0C2613C8DC;
        Thu, 31 Oct 2019 14:47:57 +0100 (CET)
X-Mailbox-Line: From 442372563baf1a33ff48f8993be069960a7aea52 Mon Sep 17 00:00:00 2001
Message-Id: <442372563baf1a33ff48f8993be069960a7aea52.1572528496.git.lukas@wunner.de>
In-Reply-To: <cover.1572528496.git.lukas@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 31 Oct 2019 14:41:02 +0100
Subject: [PATCH nf-next,RFC 2/5] netfilter: Document ingress hook
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
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
 include/linux/netdevice.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3207e0b9ec4e..bc6914ea3faf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1701,6 +1701,7 @@ enum netdev_priv_flags {
  *	@miniq_ingress:		ingress/clsact qdisc specific data for
  *				ingress processing
  *	@ingress_queue:		XXX: need comments on this one
+ *	@nf_hooks_ingress:	netfilter hooks executed for ingress packets
  *	@broadcast:		hw bcast address
  *
  *	@rx_cpu_rmap:	CPU reverse-mapping for RX completion interrupts,
-- 
2.23.0

