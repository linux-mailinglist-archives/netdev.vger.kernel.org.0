Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A943FF71F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 00:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347659AbhIBW07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 18:26:59 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:32908
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231642AbhIBW05 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 18:26:57 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 7E5923F33E;
        Thu,  2 Sep 2021 22:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630621557;
        bh=kfwb3fgdKLU7ink68zjUIyiYNzChTEoc7/7Uc+lGVGw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=BI4vakcFz6PXBTMh+9ZxQJHpD6sKVryZWSbZnLeEsWzJH39qFYApomjZNFZ0QTj2c
         dR+7hrwX7Y8zkx2C5wjmUf3WzqUKDG4Pvx2+8LcDOscUESfTCpaaOEfqHNsDPyR7Z6
         aeu6zaNEBiRwdYN/JS6LxhqlqfRKjSCLYz8V9/dcLbFcnGE9p+T6FRQc8YuLsyWvRD
         8dPdjvHjOUCPAEQeUDkAj2uSDMNy9LzXO6juMeAI4YNJfm00ZpQiXmI/OzCXP0cr5d
         PYFinAyY1HHk98NAlzkHG9E8Qv29EQbYx6a+B6jf2w/iFTZvyGhT+LRQFutcQgqNca
         b7H8mxwDISySw==
From:   Colin King <colin.king@canonical.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers: net: smc911x: clean up inconsistent indenting
Date:   Thu,  2 Sep 2021 23:25:57 +0100
Message-Id: <20210902222557.56483-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are various function arguments that are not indented correctly,
clean these up with correct indentation.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/smsc/smc911x.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 22cdbf12c823..b38056ed8371 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -1550,7 +1550,7 @@ static int smc911x_ethtool_getregslen(struct net_device *dev)
 }
 
 static void smc911x_ethtool_getregs(struct net_device *dev,
-										 struct ethtool_regs* regs, void *buf)
+				    struct ethtool_regs *regs, void *buf)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	unsigned long flags;
@@ -1600,7 +1600,7 @@ static int smc911x_ethtool_wait_eeprom_ready(struct net_device *dev)
 }
 
 static inline int smc911x_ethtool_write_eeprom_cmd(struct net_device *dev,
-													int cmd, int addr)
+						   int cmd, int addr)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	int ret;
@@ -1614,7 +1614,7 @@ static inline int smc911x_ethtool_write_eeprom_cmd(struct net_device *dev,
 }
 
 static inline int smc911x_ethtool_read_eeprom_byte(struct net_device *dev,
-													u8 *data)
+						   u8 *data)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	int ret;
@@ -1626,7 +1626,7 @@ static inline int smc911x_ethtool_read_eeprom_byte(struct net_device *dev,
 }
 
 static inline int smc911x_ethtool_write_eeprom_byte(struct net_device *dev,
-													 u8 data)
+						    u8 data)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	int ret;
@@ -1638,7 +1638,7 @@ static inline int smc911x_ethtool_write_eeprom_byte(struct net_device *dev,
 }
 
 static int smc911x_ethtool_geteeprom(struct net_device *dev,
-									  struct ethtool_eeprom *eeprom, u8 *data)
+				     struct ethtool_eeprom *eeprom, u8 *data)
 {
 	u8 eebuf[SMC911X_EEPROM_LEN];
 	int i, ret;
@@ -1654,7 +1654,7 @@ static int smc911x_ethtool_geteeprom(struct net_device *dev,
 }
 
 static int smc911x_ethtool_seteeprom(struct net_device *dev,
-									   struct ethtool_eeprom *eeprom, u8 *data)
+				     struct ethtool_eeprom *eeprom, u8 *data)
 {
 	int i, ret;
 
-- 
2.32.0

