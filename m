Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A60A91794FC
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 17:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgCDQYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 11:24:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:42052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728278AbgCDQYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 11:24:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 35991B486;
        Wed,  4 Mar 2020 16:24:00 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id DE240E037F; Wed,  4 Mar 2020 17:23:59 +0100 (CET)
Message-Id: <5f657d86c0f96899921970161e957356f2cf51e9.1583337972.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583337972.git.mkubecek@suse.cz>
References: <cover.1583337972.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 1/5] tun: fix misleading comment format
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Wed,  4 Mar 2020 17:23:59 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The comment above tun_flow_save_rps_rxhash() starts with "/**" which
makes it look like kerneldoc comment and results in warnings when
building with W=1. Fix the format to make it look like a normal comment.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/tun.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 79f248cb282d..ea64c311a554 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -546,8 +546,7 @@ static void tun_flow_update(struct tun_struct *tun, u32 rxhash,
 	rcu_read_unlock();
 }
 
-/**
- * Save the hash received in the stack receive path and update the
+/* Save the hash received in the stack receive path and update the
  * flow_hash table accordingly.
  */
 static inline void tun_flow_save_rps_rxhash(struct tun_flow_entry *e, u32 hash)
-- 
2.25.1

