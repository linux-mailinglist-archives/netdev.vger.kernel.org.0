Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF37E61EC
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 11:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfJ0KC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 06:02:57 -0400
Received: from mga06.intel.com ([134.134.136.31]:15262 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfJ0KC4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 06:02:56 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Oct 2019 03:02:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,235,1569308400"; 
   d="scan'208";a="350425807"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 27 Oct 2019 03:02:52 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iOfNs-000DpG-2v; Sun, 27 Oct 2019 18:02:52 +0800
Date:   Sun, 27 Oct 2019 18:02:06 +0800
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
Subject: [RFC PATCH] net: ethernet: ti: cpsw: cpsw_ale_set_vlan_untag() can
 be static
Message-ID: <20191027100206.hjpsvdjeophopzmg@4978f4969bb8>
References: <20191024100914.16840-2-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024100914.16840-2-grygorii.strashko@ti.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: 7e6abf354826 ("net: ethernet: ti: cpsw: allow untagged traffic on host port")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 cpsw_ale.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 23e7714ebee7b..3ed5ad372c1cb 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -417,8 +417,8 @@ static void cpsw_ale_set_vlan_mcast(struct cpsw_ale *ale, u32 *ale_entry,
 	writel(unreg_mcast, ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
 }
 
-void cpsw_ale_set_vlan_untag(struct cpsw_ale *ale, u32 *ale_entry,
-			     u16 vid, int untag_mask)
+static void cpsw_ale_set_vlan_untag(struct cpsw_ale *ale, u32 *ale_entry,
+				    u16 vid, int untag_mask)
 {
 	cpsw_ale_set_vlan_untag_force(ale_entry,
 				      untag_mask, ale->vlan_field_bits);
