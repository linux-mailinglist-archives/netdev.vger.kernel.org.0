Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53405A947
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 08:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfF2Gkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 02:40:39 -0400
Received: from mga14.intel.com ([192.55.52.115]:40046 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbfF2Gkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jun 2019 02:40:39 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Jun 2019 23:40:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,430,1557212400"; 
   d="scan'208";a="164862111"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 28 Jun 2019 23:40:37 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hh72J-0004PI-Sa; Sat, 29 Jun 2019 14:40:35 +0800
Date:   Sat, 29 Jun 2019 14:40:04 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Catherine Sullivan <csully@google.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        Catherine Sullivan <csully@google.com>,
        Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Subject: [RFC PATCH] gve: gve_get_channels() can be static
Message-ID: <20190629064004.GA17772@lkp-kbuild18>
References: <20190626185251.205687-5-csully@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190626185251.205687-5-csully@google.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: ac0744578517 ("gve: Add ethtool support")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 gve_ethtool.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 8e6863c..036389c 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -144,7 +144,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	}
 }
 
-void gve_get_channels(struct net_device *netdev, struct ethtool_channels *cmd)
+static void gve_get_channels(struct net_device *netdev, struct ethtool_channels *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 
@@ -158,7 +158,7 @@ void gve_get_channels(struct net_device *netdev, struct ethtool_channels *cmd)
 	cmd->combined_count = 0;
 }
 
-int gve_set_channels(struct net_device *netdev, struct ethtool_channels *cmd)
+static int gve_set_channels(struct net_device *netdev, struct ethtool_channels *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 	struct gve_queue_config new_tx_cfg = priv->tx_cfg;
@@ -188,8 +188,8 @@ int gve_set_channels(struct net_device *netdev, struct ethtool_channels *cmd)
 	return gve_adjust_queues(priv, new_rx_cfg, new_tx_cfg);
 }
 
-void gve_get_ringparam(struct net_device *netdev,
-		       struct ethtool_ringparam *cmd)
+static void gve_get_ringparam(struct net_device *netdev,
+			      struct ethtool_ringparam *cmd)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 
@@ -199,7 +199,7 @@ void gve_get_ringparam(struct net_device *netdev,
 	cmd->tx_pending = priv->tx_desc_cnt;
 }
 
-int gve_user_reset(struct net_device *netdev, u32 *flags)
+static int gve_user_reset(struct net_device *netdev, u32 *flags)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 
