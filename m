Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6E02FFF46
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 10:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbhAVJdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 04:33:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727427AbhAVJUE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 04:20:04 -0500
X-Greylist: delayed 429 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 22 Jan 2021 01:08:03 PST
Received: from mailout3.hostsharing.net (mailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f236:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD6DC061788;
        Fri, 22 Jan 2021 01:08:03 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by mailout3.hostsharing.net (Postfix) with ESMTPS id B5E4D102949FE;
        Fri, 22 Jan 2021 10:00:52 +0100 (CET)
Received: from localhost (unknown [89.246.108.87])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by h08.hostsharing.net (Postfix) with ESMTPSA id 465766017D32;
        Fri, 22 Jan 2021 10:00:52 +0100 (CET)
X-Mailbox-Line: From 0528ee3a3696c7c34744ff3f359817f751a52335 Mon Sep 17 00:00:00 2001
Message-Id: <0528ee3a3696c7c34744ff3f359817f751a52335.1611304190.git.lukas@wunner.de>
In-Reply-To: <cover.1611304190.git.lukas@wunner.de>
References: <cover.1611304190.git.lukas@wunner.de>
From:   Lukas Wunner <lukas@wunner.de>
Date:   Fri, 22 Jan 2021 09:47:02 +0100
Subject: [PATCH nf-next v4 2/5] netfilter: Rename ingress hook include file
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>,
        Laura Garcia Liebana <nevola@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for addition of a netfilter egress hook by renaming
<linux/netfilter_ingress.h> to <linux/netfilter_netdev.h>.

The egress hook also necessitates a refactoring of the include file,
but that is done in a separate commit to ease reviewing.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
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
index 4c16b9932823..98c5abf22e63 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -137,7 +137,7 @@
 #include <linux/if_macvlan.h>
 #include <linux/errqueue.h>
 #include <linux/hrtimer.h>
-#include <linux/netfilter_ingress.h>
+#include <linux/netfilter_netdev.h>
 #include <linux/crash_dump.h>
 #include <linux/sctp.h>
 #include <net/udp_tunnel.h>
-- 
2.29.2

