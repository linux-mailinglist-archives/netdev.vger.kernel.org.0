Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E2816B8A2
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728897AbgBYE62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:58:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:3608 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgBYE62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 23:58:28 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Feb 2020 20:58:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,482,1574150400"; 
   d="scan'208";a="350071330"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 24 Feb 2020 20:58:23 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1j6SIY-0000sJ-PE; Tue, 25 Feb 2020 12:58:22 +0800
Date:   Tue, 25 Feb 2020 12:58:12 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        xiaoliang.yang_1@nxp.com, yangbo.lu@nxp.com, po.liu@nxp.com,
        jiri@mellanox.com, idosch@idosch.org, kuba@kernel.org
Subject: [RFC PATCH] net: mscc: ocelot: vsc7514_vcap_is2_keys[] can be static
Message-ID: <20200225045810.GA17545@e50d7db646c3>
References: <20200224130831.25347-6-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224130831.25347-6-olteanv@gmail.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: b33f9830eb55 ("net: mscc: ocelot: don't rely on preprocessor for vcap key/action packing")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 ocelot_board.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index 8b83a10083e2e..186f181deffee 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -263,7 +263,7 @@ static const struct ocelot_ops ocelot_ops = {
 	.reset			= ocelot_reset,
 };
 
-struct vcap_field vsc7514_vcap_is2_keys[] = {
+static struct vcap_field vsc7514_vcap_is2_keys[] = {
 	/* Common: 46 bits */
 	[VCAP_IS2_TYPE]				= {  0,   4},
 	[VCAP_IS2_HK_FIRST]			= {  4,   1},
@@ -343,7 +343,7 @@ struct vcap_field vsc7514_vcap_is2_keys[] = {
 	[VCAP_IS2_HK_OAM_IS_Y1731]		= {187,   1},
 };
 
-struct vcap_field vsc7514_vcap_is2_actions[] = {
+static struct vcap_field vsc7514_vcap_is2_actions[] = {
 	[VCAP_IS2_ACT_HIT_ME_ONCE]		= {  0,  1},
 	[VCAP_IS2_ACT_CPU_COPY_ENA]		= {  1,  1},
 	[VCAP_IS2_ACT_CPU_QU_NUM]		= {  2,  3},
