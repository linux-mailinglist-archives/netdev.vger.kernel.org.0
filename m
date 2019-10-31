Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E327CEB204
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 15:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfJaOB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 10:01:56 -0400
Received: from mailout1.hostsharing.net ([83.223.95.204]:59663 "EHLO
        mailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfJaOB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 10:01:56 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Oct 2019 10:01:54 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by mailout1.hostsharing.net (Postfix) with ESMTPS id 48833101933FD;
        Thu, 31 Oct 2019 14:53:25 +0100 (CET)
Received: from localhost (pd95be530.dip0.t-ipconnect.de [217.91.229.48])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id EC858613C8DC;
        Thu, 31 Oct 2019 14:53:24 +0100 (CET)
X-Mailbox-Line: From 06a0bd4f0b94d3078e1c3762f255a089835c8863 Mon Sep 17 00:00:00 2001
Message-Id: <06a0bd4f0b94d3078e1c3762f255a089835c8863.1572528497.git.lukas@wunner.de>
In-Reply-To: <cover.1572528496.git.lukas@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Thu, 31 Oct 2019 14:41:03 +0100
Subject: [PATCH nf-next,RFC 3/5] netfilter: Rename ingress hook include file
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

Prepare for addition of a netfilter egress hook by renaming
<linux/netfilter_ingress.h> to <linux/netfilter_netdev.h>.

The egress hook also necessitates a refactoring of the include file,
but that is done in a separate commit to ease reviewing.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/{netfilter_ingress.h => netfilter_netdev.h} | 0
 net/core/dev.c                                            | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename include/linux/{netfilter_ingress.h => netfilter_netdev.h} (100%)

diff --git a/include/linux/netfilter_ingress.h b/include/linux/netfilter_netdev.h
similarity index 100%
rename from include/linux/netfilter_ingress.h
rename to include/linux/netfilter_netdev.h
diff --git a/net/core/dev.c b/net/core/dev.c
index e555a8656c47..c698a0fcfa02 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -135,7 +135,7 @@
 #include <linux/if_macvlan.h>
 #include <linux/errqueue.h>
 #include <linux/hrtimer.h>
-#include <linux/netfilter_ingress.h>
+#include <linux/netfilter_netdev.h>
 #include <linux/crash_dump.h>
 #include <linux/sctp.h>
 #include <net/udp_tunnel.h>
-- 
2.23.0

