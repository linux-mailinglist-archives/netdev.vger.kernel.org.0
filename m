Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB67C1F82F
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 18:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfEOQJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 12:09:02 -0400
Received: from inva021.nxp.com ([92.121.34.21]:39106 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726590AbfEOQJB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 12:09:01 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id C3EA620003A;
        Wed, 15 May 2019 18:08:59 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id B6D9820000E;
        Wed, 15 May 2019 18:08:59 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 878A120625;
        Wed, 15 May 2019 18:08:59 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net 3/3] enetc: Add missing link state info for ethtool
Date:   Wed, 15 May 2019 19:08:58 +0300
Message-Id: <1557936538-23691-3-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557936538-23691-1-git-send-email-claudiu.manoil@nxp.com>
References: <1557936538-23691-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just hook get_link to standard ethtool_op_get_link,
nothing special needed at this point.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 1ecad9ffabae..b9519b6ad727 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -570,6 +570,7 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.get_ringparam = enetc_get_ringparam,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+	.get_link = ethtool_op_get_link,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
@@ -584,6 +585,7 @@ static const struct ethtool_ops enetc_vf_ethtool_ops = {
 	.get_rxfh = enetc_get_rxfh,
 	.set_rxfh = enetc_set_rxfh,
 	.get_ringparam = enetc_get_ringparam,
+	.get_link = ethtool_op_get_link,
 };
 
 void enetc_set_ethtool_ops(struct net_device *ndev)
-- 
2.17.1

