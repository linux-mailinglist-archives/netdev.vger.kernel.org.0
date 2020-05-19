Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D08C21D950D
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 13:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgESLRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 07:17:08 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:46215 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgESLRI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 07:17:08 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee35ec3c013ca6-513bb; Tue, 19 May 2020 19:16:36 +0800 (CST)
X-RM-TRANSID: 2ee35ec3c013ca6-513bb
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea5ec3c0115f0-070af;
        Tue, 19 May 2020 19:16:36 +0800 (CST)
X-RM-TRANSID: 2eea5ec3c0115f0-070af
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net/amd: Fix indentation to put on one line affected code
Date:   Tue, 19 May 2020 19:17:21 +0800
Message-Id: <20200519111721.14240-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks better and has improved readability without additional
line breaks.

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/amd/au1000_eth.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/au1000_eth.c b/drivers/net/ethernet/amd/au1000_eth.c
index 7988e7df1..5f91e717b 100644
--- a/drivers/net/ethernet/amd/au1000_eth.c
+++ b/drivers/net/ethernet/amd/au1000_eth.c
@@ -390,8 +390,7 @@ static void au1000_enable_rx_tx(struct net_device *dev)
 	mdelay(10);
 }
 
-static void
-au1000_adjust_link(struct net_device *dev)
+static void au1000_adjust_link(struct net_device *dev)
 {
 	struct au1000_private *aup = netdev_priv(dev);
 	struct phy_device *phydev = dev->phydev;
-- 
2.20.1.windows.1



