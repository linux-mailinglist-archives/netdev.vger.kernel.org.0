Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC97107AD8
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 23:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbfKVWvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 17:51:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:18066 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726526AbfKVWvP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 17:51:15 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Nov 2019 14:51:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,231,1571727600"; 
   d="scan'208";a="290778476"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 22 Nov 2019 14:51:13 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iYHlg-0009mT-GL; Sat, 23 Nov 2019 06:51:12 +0800
Date:   Sat, 23 Nov 2019 06:50:29 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     kbuild-all@lists.01.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH linux-next] net: dsa: ocelot: felix_txtstamp() can be
 static
Message-ID: <20191122225029.ckppkwdle3yzaoq7@4978f4969bb8>
References: <201911230623.rJBgtgcn%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911230623.rJBgtgcn%lkp@intel.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: c0bcf537667c ("net: dsa: ocelot: add hardware timestamping support for Felix")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 felix.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 167e41549cdd1..b7f92464815d7 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -348,8 +348,8 @@ static bool felix_rxtstamp(struct dsa_switch *ds, int port,
 	return false;
 }
 
-bool felix_txtstamp(struct dsa_switch *ds, int port,
-		    struct sk_buff *clone, unsigned int type)
+static bool felix_txtstamp(struct dsa_switch *ds, int port,
+			   struct sk_buff *clone, unsigned int type)
 {
 	struct ocelot *ocelot = ds->priv;
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
