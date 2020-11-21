Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457D52BBEC4
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 12:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727669AbgKULpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 06:45:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbgKULpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 06:45:20 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5595C0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 03:45:19 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1605959117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q+hXuJEgz6pEnLz875u2iEmpdvqOwFo8FjGghOzXquo=;
        b=1q1b+WcGi/Z1xVv+jiFTordf79XAzMtFve9JxqsWS9N4DO9EOot/akT9G6I4RF0NiQkDZ0
        rtnjK5iS9IWgURk2osjwXW/NQpfAe205HQSh2lu+zWxyHCpM2iX3iKuu8fCFyY3U3Vwrfh
        S5XYDiY3p0MVyzT9QsMBlBnDbVWYTjHlw1GKtl9TMkmO+3tItfs7rsH7WeLgwhakJxspZC
        F6f62aF51sXfdI9N+qN4DaFiDEGw3eQrvP0AqGm9gAdXcQqiFoFmG6+Auux/COIeY5cQz8
        aIfLIkEj4n0IUV0eFWz2Wuk9wGpcvEomLl3OyInEbeGZOh7vsQf3qxZ1wDe4fA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1605959117;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q+hXuJEgz6pEnLz875u2iEmpdvqOwFo8FjGghOzXquo=;
        b=vOMM+gA++oDa4NKmF0M91VyeW1q3iPRLO6tzUs6/OC34PVqFldqHpBFn8uXppZaDgrS1c7
        NNqz3w5dxEFXy9DA==
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next 1/2] net: dsa: tag_hellcreek: Cleanup includes
Date:   Sat, 21 Nov 2020 12:44:54 +0100
Message-Id: <20201121114455.22422-2-kurt@linutronix.de>
In-Reply-To: <20201121114455.22422-1-kurt@linutronix.de>
References: <20201121114455.22422-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused and add needed includes. No functional change.

Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 net/dsa/tag_hellcreek.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 2061de06eafb..a09805c8e1ab 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -8,9 +8,7 @@
  * Based on tag_ksz.c.
  */
 
-#include <linux/etherdevice.h>
-#include <linux/list.h>
-#include <linux/slab.h>
+#include <linux/skbuff.h>
 #include <net/dsa.h>
 
 #include "dsa_priv.h"
-- 
2.20.1

