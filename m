Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E839A2BDCA
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 05:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbfE1Dgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 23:36:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:60844 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727320AbfE1Dgt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 May 2019 23:36:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 20:36:48 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 27 May 2019 20:36:46 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hVSus-0003kk-FG; Tue, 28 May 2019 11:36:46 +0800
Date:   Tue, 28 May 2019 11:36:41 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     kbuild-all@01.org, linux@armlinux.org.uk, f.fainelli@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com,
        maxime.chevallier@bootlin.com, olteanv@gmail.com,
        thomas.petazzoni@bootlin.com, davem@davemloft.net,
        vivien.didelot@gmail.com, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [RFC PATCH] net: dsa: dsa_port_phylink_register() can be static
Message-ID: <20190528033641.GA23494@lkp-kbuild06>
References: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1558992127-26008-11-git-send-email-ioana.ciornei@nxp.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 9dd6d07682b1 ("net: dsa: Use PHYLINK for the CPU/DSA ports")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 30d5b08..d74bc9d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -601,7 +601,7 @@ static int dsa_port_fixed_link_register_of(struct dsa_port *dp)
 	return 0;
 }
 
-int dsa_port_phylink_register(struct dsa_port *dp)
+static int dsa_port_phylink_register(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *port_dn = dp->dn;
