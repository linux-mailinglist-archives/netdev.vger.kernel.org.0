Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4306B313BD
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 19:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbfEaRYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 13:24:46 -0400
Received: from mga17.intel.com ([192.55.52.151]:32641 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfEaRYq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 13:24:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 10:24:45 -0700
X-ExtLoop1: 1
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 31 May 2019 10:24:43 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hWlGk-0004Aq-PE; Sat, 01 Jun 2019 01:24:42 +0800
Date:   Sat, 1 Jun 2019 01:24:01 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org,
        David Miller <davem@davemloft.net>, devicetree@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: [RFC PATCH] net: mdio: of: of_find_mii_timestamper() can be static
Message-ID: <20190531172401.GA73874@lkp-kbuild06>
References: <a375c2b73288184fe86155707ba150daaf946943.1559281985.git.richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a375c2b73288184fe86155707ba150daaf946943.1559281985.git.richardcochran@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 500a41a402da ("net: mdio: of: Register discovered MII time stampers.")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 of_mdio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/of_mdio.c b/drivers/of/of_mdio.c
index 255f47d..1251d73 100644
--- a/drivers/of/of_mdio.c
+++ b/drivers/of/of_mdio.c
@@ -43,7 +43,7 @@ static int of_get_phy_id(struct device_node *device, u32 *phy_id)
 	return -EINVAL;
 }
 
-struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
+static struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
 {
 	struct of_phandle_args arg;
 	int err;
