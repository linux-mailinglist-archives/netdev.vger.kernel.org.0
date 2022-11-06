Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A7161E2CC
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 15:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiKFO4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 09:56:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiKFO4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 09:56:41 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D742ADF
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 06:56:40 -0800 (PST)
Received: from gmx.fr ([181.118.49.178]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1N7R1T-1p5Yh10C7R-017ihJ for
 <netdev@vger.kernel.org>; Sun, 06 Nov 2022 15:56:38 +0100
Date:   Sun, 6 Nov 2022 10:56:30 -0400
From:   Jamie Gloudon <jamie.gloudon@gmx.fr>
To:     netdev@vger.kernel.org
Subject: [PATCH] Correct mistake order of checking in if statement. Make sure
 t->dev->flags & IFF_UP is check first.
Message-ID: <Y2fLHktrN7+Budg/@gmx.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Provags-ID: V03:K1:hRohGqWD/YqTYo2PmMzOXfXHlA0kdl34PWR8PVA3L6Idimo7VDp
 Bsr89/VDrAhoupE3sGyEgUD2mdaBTVawLu96PIyzTTMvFk6Y/jGLX8/r4txCRmV2vfBzR3o
 MwYZZXnxFOUsnyeotGPF5UEDLijqTllLRWSUIdnbwAdZL8i/XQHXmLEbpRw5hzKvad5S2w7
 ldvsTPZBUXIKDW7sK8rJw==
UI-OutboundReport: notjunk:1;M01:P0:ySQpcUEYdYg=;Iu+QjdfRA2tWRi2us7j8O6GWZ7o
 MFBCZzLAd61xIE/ZtgDTbx33aT9ObNq2AZXeGQz5BiLE778n+F7SycZHNZ5cOF2ocWcfUIWZi
 h4GrfNav1SEnLc5gH4kv8obMa2sy/d2XqAIveMcj3pgFXvX2LlctJ3s7dFMC4G2MfhDCx2wJJ
 3EjWtkDkjocFWSpTvEfHMfd23AP/YMfJjCV1equKfO1LcBmgNaKcTjNeufRmIUYjOqsMWakiJ
 vkvaYt6YymqA4pnQBn6Y6PJzt5LzYq42krhlI9Xsvl3KczX2aK7Rb9m2kNOZxS4ZXJl2xlt5z
 CZ3w5IlBu7xkrESxIEJyK37rU3TjbsHCmY9H07TSOc5+IY8HqBj9xmTar+dpN13PS0vHOs5ce
 EA5rpdzCRyfEMTbYtQpjVPqKqOp5fbmUUO3hk4o4cfqFa56Gv7PfRqGzO3x4PSYBCaL/8iUXN
 hhxfDr1frmVKIKylDR5g3wBWl3Tk2zQCqYmtUbISfRMYuwu7S7sV4Kot3X3kyJX7Df5FWuL5m
 HsktSahqYyWWUSRegw4uVwmg9Ye5AO1+QXNb5bP7cjzJJJF1skspRHTF5wJceGEdHMIvCrVyu
 /fehhpP2R/2hGUQM/L0zvpDbsR1ZUJe/igLNvozAsGEXjIfqz8OrlMmC7UEcoEo6sNyjAMHaT
 oolE+vIIYRK26lcQutas3bqjnyizPT+6juNL8HBnKjPp/pLlJnF9Mdwr0r5aSrRlHfn0XERz1
 mydug0Rg9N6i4XOS/CD/nfjW2dKBgjfJ0c9x9d8YpIu9joFhxfx6oOepwsDyoLehQTARLoDjQ
 09eLiQunlywl8XcQx6x1p63ji4iGgLJy01lGwgXCXdoNOhWDXMGwNWPVMJPQ9X5oyUakBdlBA
 NSw5WpDYP49xMFagUIkAaq0cZQZeDOri+IXmaR+RY92Nv3ZzHYq2ScBEnLsYM+BmQ1QNpYrah
 96Pa+Q==
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,FREEMAIL_FROM,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 net/ipv6/ip6_tunnel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2fb4c6ad7243..22c71f991bb7 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -162,7 +162,7 @@ ip6_tnl_lookup(struct net *net, int link,
 		return cand;
 
 	t = rcu_dereference(ip6n->collect_md_tun);
-	if (t && t->dev->flags & IFF_UP)
+	if (t && (t->dev->flags & IFF_UP))
 		return t;
 
 	t = rcu_dereference(ip6n->tnls_wc[0]);
-- 
2.28.0

