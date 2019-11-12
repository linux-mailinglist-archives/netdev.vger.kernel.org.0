Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1343DF9D8F
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 23:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbfKLW6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 17:58:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:28388 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfKLW6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 17:58:35 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 14:58:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,298,1569308400"; 
   d="scan'208";a="202834742"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 12 Nov 2019 14:58:32 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iUf7I-000FVN-6h; Wed, 13 Nov 2019 06:58:32 +0800
Date:   Wed, 13 Nov 2019 06:57:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Po Liu <po.liu@nxp.com>
Cc:     kbuild-all@lists.01.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: [RFC PATCH] enetc: enetc_setup_tc_mqprio() can be static
Message-ID: <20191112225747.lhn47eykqljdzqwj@4978f4969bb8>
References: <20191111042715.13444-1-Po.Liu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191111042715.13444-1-Po.Liu@nxp.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 0ffc020dc8f3 ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 enetc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index d58dbc2c4270e..724dc90bf87a2 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1427,7 +1427,7 @@ int enetc_close(struct net_device *ndev)
 	return 0;
 }
 
-int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
+static int enetc_setup_tc_mqprio(struct net_device *ndev, void *type_data)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	struct tc_mqprio_qopt *mqprio = type_data;
