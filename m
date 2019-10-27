Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BE2E6237
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 12:23:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfJ0LXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 07:23:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:6668 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfJ0LXV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 07:23:21 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 04:23:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,236,1569308400"; 
   d="scan'208";a="282691432"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 27 Oct 2019 04:23:18 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOgdh-0001AV-O0; Sun, 27 Oct 2019 19:23:17 +0800
Date:   Sun, 27 Oct 2019 19:22:56 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH] net: ethernet: ti: cpsw_port_offload_fwd_mark_update()
 can be static
Message-ID: <20191027112256.rnfy3y572ovdmn3h@4978f4969bb8>
References: <20191024100914.16840-8-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024100914.16840-8-grygorii.strashko@ti.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 9da120bc2cdf ("net: ethernet: ti: introduce cpsw switchdev based driver part 2 - switch")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 cpsw_new.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index f3606ccc747f4..5ff2d72db34c5 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1441,7 +1441,7 @@ bool cpsw_port_dev_check(const struct net_device *ndev)
 	return false;
 }
 
-void cpsw_port_offload_fwd_mark_update(struct cpsw_common *cpsw)
+static void cpsw_port_offload_fwd_mark_update(struct cpsw_common *cpsw)
 {
 	int set_val = 0;
 	int i;
