Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554B4234712
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 15:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732771AbgGaNiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 09:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgGaNiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 09:38:21 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [IPv6:2001:4b98:dc0:41:216:3eff:fe52:be3b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37BB0C061574
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 06:38:21 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH net-next 1/2] ipv6/addrconf: call addrconf_ifdown with consistent values
Date:   Fri, 31 Jul 2020 15:32:06 +0200
Message-Id: <20200731133207.26964-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Second parameter of addrconf_ifdown "how" is used as a boolean
internally. It does not make sense to call it with something different
of 0 or 1.

This value is set to 2 in all git history.

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 net/ipv6/addrconf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 840bfdb3d7bd..861265fa9d6d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7189,7 +7189,7 @@ void addrconf_cleanup(void)
 			continue;
 		addrconf_ifdown(dev, 1);
 	}
-	addrconf_ifdown(init_net.loopback_dev, 2);
+	addrconf_ifdown(init_net.loopback_dev, 1);
 
 	/*
 	 *	Check hash table.
-- 
2.20.1

