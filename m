Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994FF615E35
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 09:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbiKBIrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 04:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiKBIqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 04:46:50 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C773225EA8;
        Wed,  2 Nov 2022 01:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667378809; x=1698914809;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AM3wxcIpyZwmmirPgp+DGaGwq9/8bJtoYhTS98E9VB4=;
  b=uQm7fZNQB5B+WcXQUVfC6j/JjzggSfs8Ao4rBHIzYFl8sgr2FH1fvRUk
   BqqcOcS50iEbaYBojBOcYh519pw9AXStTLbnJHoq4Ymtzgp/B9rJI08Nz
   rOi+JaefrugmI4Fta73IYs3okSB0Gx9KzPPNsvgktL3VqyyDw9OebCPW8
   Jq9u1pMvy6696aEAN5dCr48Nxt8HzjDavPnBQC+xhAlJOZ1mB86sgRTiT
   e/rIeLE8MKEdsIvksnXy+a4SBNIBo1gPLDa+1xyXPYCJoU8huP7FPL6xR
   nGjQuy3hPYxM11gmo4s0fKE1U6R3FpHJb/DAb+lc7FpMDoYQ2GjsCBR6q
   A==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="txt'?scan'208";a="187255307"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Nov 2022 01:46:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 2 Nov 2022 01:46:47 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Wed, 2 Nov 2022 01:46:43 -0700
Date:   Wed, 2 Nov 2022 14:16:42 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <pabeni@redhat.com>, <edumazet@google.com>, <olteanv@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V5] net: lan743x: Add support to SGMII register
 dump for PCI11010/PCI11414 chips
Message-ID: <20221102084642.GA27153@raju-project-pc>
References: <20221102052802.5460-1-Raju.Lakkaraju@microchip.com>
 <20221102083154.jjf5ht5s7ekvwd4n@soft-dev3-1>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20221102083154.jjf5ht5s7ekvwd4n@soft-dev3-1>
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline

Hi Horatiu,

Thank you for review comments.

The 11/02/2022 09:31, Horatiu Vultur wrote:
> The 11/02/2022 10:58, Raju Lakkaraju wrote:
> 
> Hi Raju,
> 
> > Add support to SGMII register dump
> > 
> > Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> > ---
> > Change List:
> > ============
> > V4 -> V5:
> >  - Remove the debug read function macro
> >  - Add auto variable structure to handle register definitions
> > 
> > V3 -> V4:
> >  - No changes. Patch on tags 6.1-rc1
> > 
> > V2 -> V3:
> >  - Remove the private flag option.
> >    As per review comment, use -w/-W to configure dump flag.
> >    But, change to -w/-W option, EEPROM/OTP data might be corrupt
> >    in case of wrong flag input.
> >    Need to fix this properly in future development.
> > 
> > V1 -> V2:
> >  - Add set_dump and get_dump_flag functions
> > 
> > V0 -> V1:
> >  - Removed unwanted code
> > 
> >  .../net/ethernet/microchip/lan743x_ethtool.c  | 113 ++++++++++++++++--
> >  .../net/ethernet/microchip/lan743x_ethtool.h  |  71 ++++++++++-
> >  drivers/net/ethernet/microchip/lan743x_main.c |   2 +-
> >  drivers/net/ethernet/microchip/lan743x_main.h |   1 +
> >  4 files changed, 178 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> > index 88f9484cc2a7..0624ce24b44e 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
> > +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
> > @@ -1190,15 +1190,11 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
> >  }
> >  #endif /* CONFIG_PM */
> >  
> > -static void lan743x_common_regs(struct net_device *dev,
> > -				struct ethtool_regs *regs, void *p)
> > -
> > +static void lan743x_common_regs(struct net_device *dev, void *p)
> >  {
> 
> This change shouldn't be part of a different patch? Because this change
> doesn't have anything to do with the SGMII register dump, you just
> remove unused parameter.
> 

Yes.
I thought, it's minor change.
O.K. I will split into 2 patches and send again.

> >  	struct lan743x_adapter *adapter = netdev_priv(dev);
> >  	u32 *rb = p;
> >  
> > -	memset(p, 0, (MAX_LAN743X_ETH_REGS * sizeof(u32)));
> > -
> >  	rb[ETH_PRIV_FLAGS] = adapter->flags;
> >  	rb[ETH_ID_REV]     = lan743x_csr_read(adapter, ID_REV);
> >  	rb[ETH_FPGA_REV]   = lan743x_csr_read(adapter, FPGA_REV);
> > @@ -1220,17 +1216,120 @@ static void lan743x_common_regs(struct net_device *dev,
> >  	rb[ETH_WK_SRC]     = lan743x_csr_read(adapter, MAC_WK_SRC);
> >  }
> >  
> > +static void lan743x_sgmii_regs(struct net_device *dev, void *p)
> > +{
> > +	struct lan743x_adapter *adp = netdev_priv(dev);
> > +	u32 *rb = p;
> > +	u16 idx;
> > +	int val;
> > +	struct {
> > +		u8 id;
> > +		u8 dev;
> > +		u16 addr;
> > +	} regs[] = {
> > +		{ ETH_SR_VSMMD_DEV_ID1,                MDIO_MMD_VEND1, 0x0002},
> > +		{ ETH_SR_VSMMD_DEV_ID2,                MDIO_MMD_VEND1, 0x0003},
> > +		{ ETH_SR_VSMMD_PCS_ID1,                MDIO_MMD_VEND1, 0x0004},
> > +		{ ETH_SR_VSMMD_PCS_ID2,                MDIO_MMD_VEND1, 0x0005},
> > +		{ ETH_SR_VSMMD_STS,                    MDIO_MMD_VEND1, 0x0008},
> > +		{ ETH_SR_VSMMD_CTRL,                   MDIO_MMD_VEND1, 0x0009},
> > +		{ ETH_SR_MII_CTRL,                     MDIO_MMD_VEND2, 0x0000},
> > +		{ ETH_SR_MII_STS,                      MDIO_MMD_VEND2, 0x0001},
> > +		{ ETH_SR_MII_DEV_ID1,                  MDIO_MMD_VEND2, 0x0002},
> > +		{ ETH_SR_MII_DEV_ID2,                  MDIO_MMD_VEND2, 0x0003},
> > +		{ ETH_SR_MII_AN_ADV,                   MDIO_MMD_VEND2, 0x0004},
> > +		{ ETH_SR_MII_LP_BABL,                  MDIO_MMD_VEND2, 0x0005},
> > +		{ ETH_SR_MII_EXPN,                     MDIO_MMD_VEND2, 0x0006},
> > +		{ ETH_SR_MII_EXT_STS,                  MDIO_MMD_VEND2, 0x000F},
> > +		{ ETH_SR_MII_TIME_SYNC_ABL,            MDIO_MMD_VEND2, 0x0708},
> > +		{ ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR, MDIO_MMD_VEND2, 0x0709},
> > +		{ ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR, MDIO_MMD_VEND2, 0x070A},
> > +		{ ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR, MDIO_MMD_VEND2, 0x070B},
> > +		{ ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR, MDIO_MMD_VEND2, 0x070C},
> > +		{ ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR, MDIO_MMD_VEND2, 0x070D},
> > +		{ ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR, MDIO_MMD_VEND2, 0x070E},
> > +		{ ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR, MDIO_MMD_VEND2, 0x070F},
> > +		{ ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR, MDIO_MMD_VEND2, 0x0710},
> > +		{ ETH_VR_MII_DIG_CTRL1,                MDIO_MMD_VEND2, 0x8000},
> > +		{ ETH_VR_MII_AN_CTRL,                  MDIO_MMD_VEND2, 0x8001},
> > +		{ ETH_VR_MII_AN_INTR_STS,              MDIO_MMD_VEND2, 0x8002},
> > +		{ ETH_VR_MII_TC,                       MDIO_MMD_VEND2, 0x8003},
> > +		{ ETH_VR_MII_DBG_CTRL,                 MDIO_MMD_VEND2, 0x8005},
> > +		{ ETH_VR_MII_EEE_MCTRL0,               MDIO_MMD_VEND2, 0x8006},
> > +		{ ETH_VR_MII_EEE_TXTIMER,              MDIO_MMD_VEND2, 0x8008},
> > +		{ ETH_VR_MII_EEE_RXTIMER,              MDIO_MMD_VEND2, 0x8009},
> > +		{ ETH_VR_MII_LINK_TIMER_CTRL,          MDIO_MMD_VEND2, 0x800A},
> > +		{ ETH_VR_MII_EEE_MCTRL1,               MDIO_MMD_VEND2, 0x800B},
> > +		{ ETH_VR_MII_DIG_STS,                  MDIO_MMD_VEND2, 0x8010},
> > +		{ ETH_VR_MII_ICG_ERRCNT1,              MDIO_MMD_VEND2, 0x8011},
> > +		{ ETH_VR_MII_GPIO,                     MDIO_MMD_VEND2, 0x8015},
> > +		{ ETH_VR_MII_EEE_LPI_STATUS,           MDIO_MMD_VEND2, 0x8016},
> > +		{ ETH_VR_MII_EEE_WKERR,                MDIO_MMD_VEND2, 0x8017},
> > +		{ ETH_VR_MII_MISC_STS,                 MDIO_MMD_VEND2, 0x8018},
> > +		{ ETH_VR_MII_RX_LSTS,                  MDIO_MMD_VEND2, 0x8020},
> > +		{ ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0,    MDIO_MMD_VEND2, 0x8038},
> > +		{ ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0,    MDIO_MMD_VEND2, 0x803A},
> > +		{ ETH_VR_MII_GEN2_GEN4_TXGENCTRL0,     MDIO_MMD_VEND2, 0x803C},
> > +		{ ETH_VR_MII_GEN2_GEN4_TXGENCTRL1,     MDIO_MMD_VEND2, 0x803D},
> > +		{ ETH_VR_MII_GEN4_TXGENCTRL2,          MDIO_MMD_VEND2, 0x803E},
> > +		{ ETH_VR_MII_GEN2_GEN4_TX_STS,         MDIO_MMD_VEND2, 0x8048},
> > +		{ ETH_VR_MII_GEN2_GEN4_RXGENCTRL0,     MDIO_MMD_VEND2, 0x8058},
> > +		{ ETH_VR_MII_GEN2_GEN4_RXGENCTRL1,     MDIO_MMD_VEND2, 0x8059},
> > +		{ ETH_VR_MII_GEN4_RXEQ_CTRL,           MDIO_MMD_VEND2, 0x805B},
> > +		{ ETH_VR_MII_GEN4_RXLOS_CTRL0,         MDIO_MMD_VEND2, 0x805D},
> > +		{ ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0,     MDIO_MMD_VEND2, 0x8078},
> > +		{ ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1,     MDIO_MMD_VEND2, 0x8079},
> > +		{ ETH_VR_MII_GEN2_GEN4_MPLL_STS,       MDIO_MMD_VEND2, 0x8088},
> > +		{ ETH_VR_MII_GEN2_GEN4_LVL_CTRL,       MDIO_MMD_VEND2, 0x8090},
> > +		{ ETH_VR_MII_GEN4_MISC_CTRL2,          MDIO_MMD_VEND2, 0x8093},
> > +		{ ETH_VR_MII_GEN2_GEN4_MISC_CTRL0,     MDIO_MMD_VEND2, 0x8099},
> > +		{ ETH_VR_MII_GEN2_GEN4_MISC_CTRL1,     MDIO_MMD_VEND2, 0x809A},
> > +		{ ETH_VR_MII_SNPS_CR_CTRL,             MDIO_MMD_VEND2, 0x80A0},
> > +		{ ETH_VR_MII_SNPS_CR_ADDR,             MDIO_MMD_VEND2, 0x80A1},
> > +		{ ETH_VR_MII_SNPS_CR_DATA,             MDIO_MMD_VEND2, 0x80A2},
> > +		{ ETH_VR_MII_DIG_CTRL2,                MDIO_MMD_VEND2, 0x80E1},
> > +		{ ETH_VR_MII_DIG_ERRCNT,               MDIO_MMD_VEND2, 0x80E2},
> > +	};
> > +
> > +	for (idx = 0; idx < ARRAY_SIZE(regs) / sizeof(regs[0]); idx++) {
> 
> Is this correct?

Yes.

> You have 62 entries but you go only over the first 15. Or am I
> misunderstood something?

Your ethtool application don't have SGMII register dump register
definitions.
Once This patch accept by Linux community, I will submit ethtool application
changes to "Ethtool development community".

For your reference, Please find the attached file
(sgmii_sgmii_regdump_cmd.txt).
> 
> > +		val = lan743x_sgmii_read(adp, regs[idx].dev, regs[idx].addr);
> > +		if (val < 0)
> > +			rb[regs[idx].id] = 0xFFFF;
> > +		else
> > +			rb[regs[idx].id] = val;
> > +	}
> > +}
> > +
> >  static int lan743x_get_regs_len(struct net_device *dev)
> >  {
> > -	return MAX_LAN743X_ETH_REGS * sizeof(u32);
> > +	struct lan743x_adapter *adapter = netdev_priv(dev);
> > +	u32 num_regs = MAX_LAN743X_ETH_COMMON_REGS;
> > +
> > +	if (adapter->is_sgmii_en)
> > +		num_regs += MAX_LAN743X_ETH_SGMII_REGS;
> > +
> > +	return num_regs * sizeof(u32);
> >  }
> >  
> >  static void lan743x_get_regs(struct net_device *dev,
> >  			     struct ethtool_regs *regs, void *p)
> >  {
> > +	struct lan743x_adapter *adapter = netdev_priv(dev);
> > +	int regs_len;
> > +
> > +	regs_len = lan743x_get_regs_len(dev);
> > +	memset(p, 0, regs_len);
> > +
> >  	regs->version = LAN743X_ETH_REG_VERSION;
> > +	regs->len = regs_len;
> >  
> > -	lan743x_common_regs(dev, regs, p);
> > +	lan743x_common_regs(dev, p);
> > +	p = (u32 *)p + MAX_LAN743X_ETH_COMMON_REGS;
> > +
> > +	if (adapter->is_sgmii_en) {
> > +		lan743x_sgmii_regs(dev, p);
> > +		p = (u32 *)p + MAX_LAN743X_ETH_SGMII_REGS;
> > +	}
> >  }
> >  
> >  static void lan743x_get_pauseparam(struct net_device *dev,
> > diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.h b/drivers/net/ethernet/microchip/lan743x_ethtool.h
> > index 7f5996a52488..267d5035b8ad 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_ethtool.h
> > +++ b/drivers/net/ethernet/microchip/lan743x_ethtool.h
> > @@ -29,7 +29,76 @@ enum {
> >  	ETH_WK_SRC,
> >  
> >  	/* Add new registers above */
> > -	MAX_LAN743X_ETH_REGS
> > +	MAX_LAN743X_ETH_COMMON_REGS
> > +};
> > +
> > +enum {
> > +	/* SGMII Register */
> > +	ETH_SR_VSMMD_DEV_ID1,
> > +	ETH_SR_VSMMD_DEV_ID2,
> > +	ETH_SR_VSMMD_PCS_ID1,
> > +	ETH_SR_VSMMD_PCS_ID2,
> > +	ETH_SR_VSMMD_STS,
> > +	ETH_SR_VSMMD_CTRL,
> > +	ETH_SR_MII_CTRL,
> > +	ETH_SR_MII_STS,
> > +	ETH_SR_MII_DEV_ID1,
> > +	ETH_SR_MII_DEV_ID2,
> > +	ETH_SR_MII_AN_ADV,
> > +	ETH_SR_MII_LP_BABL,
> > +	ETH_SR_MII_EXPN,
> > +	ETH_SR_MII_EXT_STS,
> > +	ETH_SR_MII_TIME_SYNC_ABL,
> > +	ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_LWR,
> > +	ETH_SR_MII_TIME_SYNC_TX_MAX_DLY_UPR,
> > +	ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_LWR,
> > +	ETH_SR_MII_TIME_SYNC_TX_MIN_DLY_UPR,
> > +	ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_LWR,
> > +	ETH_SR_MII_TIME_SYNC_RX_MAX_DLY_UPR,
> > +	ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_LWR,
> > +	ETH_SR_MII_TIME_SYNC_RX_MIN_DLY_UPR,
> > +	ETH_VR_MII_DIG_CTRL1,
> > +	ETH_VR_MII_AN_CTRL,
> > +	ETH_VR_MII_AN_INTR_STS,
> > +	ETH_VR_MII_TC,
> > +	ETH_VR_MII_DBG_CTRL,
> > +	ETH_VR_MII_EEE_MCTRL0,
> > +	ETH_VR_MII_EEE_TXTIMER,
> > +	ETH_VR_MII_EEE_RXTIMER,
> > +	ETH_VR_MII_LINK_TIMER_CTRL,
> > +	ETH_VR_MII_EEE_MCTRL1,
> > +	ETH_VR_MII_DIG_STS,
> > +	ETH_VR_MII_ICG_ERRCNT1,
> > +	ETH_VR_MII_GPIO,
> > +	ETH_VR_MII_EEE_LPI_STATUS,
> > +	ETH_VR_MII_EEE_WKERR,
> > +	ETH_VR_MII_MISC_STS,
> > +	ETH_VR_MII_RX_LSTS,
> > +	ETH_VR_MII_GEN2_GEN4_TX_BSTCTRL0,
> > +	ETH_VR_MII_GEN2_GEN4_TX_LVLCTRL0,
> > +	ETH_VR_MII_GEN2_GEN4_TXGENCTRL0,
> > +	ETH_VR_MII_GEN2_GEN4_TXGENCTRL1,
> > +	ETH_VR_MII_GEN4_TXGENCTRL2,
> > +	ETH_VR_MII_GEN2_GEN4_TX_STS,
> > +	ETH_VR_MII_GEN2_GEN4_RXGENCTRL0,
> > +	ETH_VR_MII_GEN2_GEN4_RXGENCTRL1,
> > +	ETH_VR_MII_GEN4_RXEQ_CTRL,
> > +	ETH_VR_MII_GEN4_RXLOS_CTRL0,
> > +	ETH_VR_MII_GEN2_GEN4_MPLL_CTRL0,
> > +	ETH_VR_MII_GEN2_GEN4_MPLL_CTRL1,
> > +	ETH_VR_MII_GEN2_GEN4_MPLL_STS,
> > +	ETH_VR_MII_GEN2_GEN4_LVL_CTRL,
> > +	ETH_VR_MII_GEN4_MISC_CTRL2,
> > +	ETH_VR_MII_GEN2_GEN4_MISC_CTRL0,
> > +	ETH_VR_MII_GEN2_GEN4_MISC_CTRL1,
> > +	ETH_VR_MII_SNPS_CR_CTRL,
> > +	ETH_VR_MII_SNPS_CR_ADDR,
> > +	ETH_VR_MII_SNPS_CR_DATA,
> > +	ETH_VR_MII_DIG_CTRL2,
> > +	ETH_VR_MII_DIG_ERRCNT,
> > +
> > +	/* Add new registers above */
> > +	MAX_LAN743X_ETH_SGMII_REGS
> >  };
> >  
> >  extern const struct ethtool_ops lan743x_ethtool_ops;
> > diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> > index c0f8ba601c01..534840f9a7ca 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_main.c
> > +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> > @@ -939,7 +939,7 @@ static int lan743x_sgmii_wait_till_not_busy(struct lan743x_adapter *adapter)
> >  	return ret;
> >  }
> >  
> > -static int lan743x_sgmii_read(struct lan743x_adapter *adapter, u8 mmd, u16 addr)
> > +int lan743x_sgmii_read(struct lan743x_adapter *adapter, u8 mmd, u16 addr)
> >  {
> >  	u32 mmd_access;
> >  	int ret;
> > diff --git a/drivers/net/ethernet/microchip/lan743x_main.h b/drivers/net/ethernet/microchip/lan743x_main.h
> > index bc5eea4c7b40..8438c3dbcf36 100644
> > --- a/drivers/net/ethernet/microchip/lan743x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan743x_main.h
> > @@ -1161,5 +1161,6 @@ int lan743x_hs_syslock_acquire(struct lan743x_adapter *adapter, u16 timeout);
> >  void lan743x_hs_syslock_release(struct lan743x_adapter *adapter);
> >  void lan743x_mac_flow_ctrl_set_enables(struct lan743x_adapter *adapter,
> >  				       bool tx_enable, bool rx_enable);
> > +int lan743x_sgmii_read(struct lan743x_adapter *adapter, u8 mmd, u16 addr);
> >  
> >  #endif /* _LAN743X_H */
> > -- 
> > 2.25.1
> > 
> 
> -- 
> /Horatiu

--------
Thanks,
Raju

--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset="utf-8"
Content-Disposition: attachment; filename="sgmii_sgmii_regdump_cmd.txt"

$ ethtool -d enp6s0 
LAN743x Registers:
------------------
CHIP_ID_REV  = 0xA04100A0
FPGA_REV     = 0x00000000
STRAP_READ   = 0x00000040
INT_STS      = 0x00000230
HW_CFG       = 0x00000000
PMT_CTRL     = 0x000001A0
E2P_CMD      = 0x00000000
E2P_DATA     = 0x00000000

MAC Registers:
--------------
MAC_CR       = 0x0008600E
MAC_RX       = 0x05EE0069
MAC_TX       = 0x00000041
FLOW         = 0x6000FFFF
MII_ACC      = 0x00000B80
MII_DATA     = 0x00000003
WUCSR        = 0x00000000
WK_SRC       = 0x00000000
EEE_TX_LPI_REQ_DLY = 0x00000000

SGMII Register Dump:
-------------------
SR_VSMMD_DEV_ID1                [1E:0002] = 0x00000000
SR_VSMMD_DEV_ID2                [1E:0003] = 0x00000000
SR_VSMMD_PCS_ID1                [1E:0004] = 0x00007996
SR_VSMMD_PCS_ID2                [1E:0005] = 0x0000CED0
SR_VSMMD_STS                    [1E:0008] = 0x00008000
SR_VSMMD_CTRL                   [1E:0009] = 0x00000004
SR_MII_CTRL                     [1F:0000] = 0x00000140
SR_MII_STS                      [1F:0001] = 0x0000018D
SR_MII_DEV_ID1                  [1F:0002] = 0x00007996
SR_MII_DEV_ID2                  [1F:0003] = 0x0000CED0
SR_MII_AN_ADV                   [1F:0004] = 0x00000020
SR_MII_LP_BABL                  [1F:0005] = 0x00000000
SR_MII_EXPN                     [1F:0006] = 0x00000000
SR_MII_EXT_STS                  [1F:000F] = 0x0000C000
SR_MII_TIME_SYNC_ABL            [1F:0708] = 0x00000003
SR_MII_TIME_SYNC_TX_MAX_DLY_LWR [1F:0709] = 0x00000000
SR_MII_TIME_SYNC_TX_MAX_DLY_UPR [1F:070A] = 0x00000000
SR_MII_TIME_SYNC_TX_MIN_DLY_LWR [1F:070B] = 0x00000000
SR_MII_TIME_SYNC_TX_MIN_DLY_UPR [1F:070C] = 0x00000000
SR_MII_TIME_SYNC_RX_MAX_DLY_LWR [1F:070D] = 0x00000000
SR_MII_TIME_SYNC_RX_MAX_DLY_UPR [1F:070E] = 0x00000000
SR_MII_TIME_SYNC_RX_MIN_DLY_LWR [1F:070F] = 0x00000000
SR_MII_TIME_SYNC_RX_MIN_DLY_UPR [1F:0710] = 0x00000000
VR_MII_DIG_CTRL1                [1F:8000] = 0x00000000
VR_MII_AN_CTRL                  [1F:8001] = 0x00000000
VR_MII_AN_INTR_STS              [1F:8002] = 0x00000000
VR_MII_TC                       [1F:8003] = 0x00000000
VR_MII_DBG_CTRL                 [1F:8005] = 0x00000000
VR_MII_EEE_MCTRL0               [1F:8006] = 0x00000000
VR_MII_EEE_TXTIMER              [1F:8008] = 0x00000000
VR_MII_EEE_RXTIMER              [1F:8009] = 0x00000000
VR_MII_LINK_TIMER_CTRL          [1F:800A] = 0x00000000
VR_MII_EEE_MCTRL1               [1F:800B] = 0x00000000
VR_MII_DIG_STS                  [1F:8010] = 0x00000000
VR_MII_ICG_ERRCNT1              [1F:8011] = 0x00000000
VR_MII_GPIO                     [1F:8015] = 0x00000000
VR_MII_EEE_LPI_STATUS           [1F:8016] = 0x00000000
VR_MII_EEE_WKERR                [1F:8017] = 0x00000000
VR_MII_MISC_STS                 [1F:8018] = 0x00000000
VR_MII_RX_LSTS                  [1F:8020] = 0x00000000
VR_MII_Gen2_Gen4_TX_BSTCTRL0    [1F:8038] = 0x00000000
VR_MII_Gen2_Gen4_TX_LVLCTRL0    [1F:803A] = 0x00000000
VR_MII_Gen2_Gen4_TXGENCTRL0     [1F:803C] = 0x00000000
VR_MII_Gen2_Gen4_TXGENCTRL1     [1F:803D] = 0x00000000
VR_MII_Gen4_TXGENCTRL2          [1F:803E] = 0x00000000
VR_MII_Gen2_Gen4_TX_STS         [1F:8048] = 0x00000000
VR_MII_Gen2_Gen4_RXGENCTRL0     [1F:8058] = 0x00000000
VR_MII_Gen2_Gen4_RXGENCTRL1     [1F:8059] = 0x00000000
VR_MII_Gen4_RXEQ_CTRL           [1F:805B] = 0x00000000
VR_MII_Gen4_RXLOS_CTRL0         [1F:805D] = 0x00000000
VR_MII_Gen2_Gen4_MPLL_CTRL0     [1F:8078] = 0x00000000
VR_MII_Gen2_Gen4_MPLL_CTRL1     [1F:8079] = 0x00000000
VR_MII_Gen2_Gen4_MPLL_STS       [1F:8088] = 0x00000000
VR_MII_Gen2_Gen4_LVL_CTRL       [1F:8090] = 0x00000000
VR_MII_Gen4_MISC_CTRL2          [1F:8093] = 0x00000000
VR_MII_Gen2_Gen4_MISC_CTRL0     [1F:8099] = 0x00000000
VR_MII_Gen2_Gen4_MISC_CTRL1     [1F:809A] = 0x00000000
VR_MII_SNPS_CR_CTRL             [1F:80A0] = 0x00000000
VR_MII_SNPS_CR_ADDR             [1F:80A1] = 0x00000000
VR_MII_SNPS_CR_DATA             [1F:80A2] = 0x00000000
VR_MII_DIG_CTRL2                [1F:80E1] = 0x00000000
VR_MII_DIG_ERRCNT               [1F:80E2] = 0x00000000


--7AUc2qLy4jB3hD7Z--
