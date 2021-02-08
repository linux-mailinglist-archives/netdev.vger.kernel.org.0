Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 527FC312B3B
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 08:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhBHHsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 02:48:21 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:11188 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhBHHsU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 02:48:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612770499; x=1644306499;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bQDgjZGs3K7YBKjwl0I+8ePEFmSBGZnt2EZpaNfIK9Q=;
  b=gn5V4PMv5ZL4S8PVl7i2LK1W9Qa+09Ys1czHf1RlzEbVKVCKyLnnq7Te
   JUqgHr1Zu84hw9tYpMlMPc2oGmLGJPB2K/lKorvoESx/w2UTAc4Bq6yKR
   SuPY5n/eExsFnZOjFxbh9KpN8IIAXKFGuEPfeKEyvZqpqORHmTFY7jZCE
   MxNScsmmxMLBWEY5iHDoJ75ut4xlyrlLptchyTB8TPTtWXUAdpCoy3iUf
   /OQSN9kJ0zTD/GfArRo6Bi3HzMLnn0+/p8+KvJktI6c3fce1ZgY/1wP3C
   olR2dBI+bhUHTgD138PQjzJWc5YemE3kpy41Zk59xSExgJPIkEiPO3l8y
   w==;
IronPort-SDR: 1kOSpgx1R0/NQAhcwZ31rMMeww8wucVbneeTsIswuD38ylHAF8+y7F3Pgyw5Wp5iK58i/TWbcP
 Z1DsBzOW9gMyphhzhWTrURlQwwDz9Pk20UtAkFChYMmxHrndGPp5ENK865/DkOMKHvVb7bBr82
 xWpotveEm1QjGqkN64mmTf/swrFUWf4KLz2u3khHzrlIDT6LFLUyBmqeZjVme79Ii7y2hikUA5
 f19YWrUTO9D8g8XhIwcJMtx5vMBYCRXPVg7OMyoRXarYuHBiotoN6LZSfnOF2Jy4vKY0AwmeB4
 qg4=
X-IronPort-AV: E=Sophos;i="5.81,161,1610434800"; 
   d="scan'208";a="105794403"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Feb 2021 00:47:01 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 8 Feb 2021 00:47:01 -0700
Received: from tyr.hegelund-hansen.dk (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Mon, 8 Feb 2021 00:46:59 -0700
Message-ID: <c23acd4f56519d53e2cff634f85ae6bed25b4b09.camel@microchip.com>
Subject: Re: [PATCH v13 3/4] phy: Add Sparx5 ethernet serdes PHY driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Vinod Koul <vkoul@kernel.org>
CC:     Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Date:   Mon, 8 Feb 2021 08:46:58 +0100
In-Reply-To: <20210204080107.GJ3079@vkoul-mobl.Dlink>
References: <20210129130748.373831-1-steen.hegelund@microchip.com>
         <20210129130748.373831-4-steen.hegelund@microchip.com>
         <20210204080107.GJ3079@vkoul-mobl.Dlink>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinod,

On Thu, 2021-02-04 at 13:31 +0530, Vinod Koul wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> On 29-01-21, 14:07, Steen Hegelund wrote:
> > Add the Microchip Sparx5 ethernet serdes PHY driver for the 6G, 10G
> > and 25G
> > interfaces available in the Sparx5 SoC.
> > 
> > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
> > ---
> > 

...

> > sdx5_rmw(SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN_SET(params-
> > >cfg_rxlb_en),
> > +              SD25G_LANE_LANE_1E_LN_CFG_RXLB_EN,
> > +              priv,
> > +              SD25G_LANE_LANE_1E(sd_index));
> > +
> > +     sdx5_rmw(SD25G_LANE_LANE_19_LN_CFG_TXLB_EN_SET(params-
> > >cfg_txlb_en),
> > +              SD25G_LANE_LANE_19_LN_CFG_TXLB_EN,
> > +              priv,
> > +              SD25G_LANE_LANE_19(sd_index));
> > +
> > +     sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(0),
> > +              SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
> > +              priv,
> > +              SD25G_LANE_LANE_2E(sd_index));
> > +
> > +     sdx5_rmw(SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG_SET(1),
> > +              SD25G_LANE_LANE_2E_LN_CFG_RSTN_DFEDIG,
> > +              priv,
> > +              SD25G_LANE_LANE_2E(sd_index));
> > +
> > +     sdx5_rmw(SD_LANE_25G_SD_LANE_CFG_MACRO_RST_SET(0),
> > +              SD_LANE_25G_SD_LANE_CFG_MACRO_RST,
> > +              priv,
> > +              SD_LANE_25G_SD_LANE_CFG(sd_index));
> > +
> > +     sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(0),
> > +              SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
> > +              priv,
> > +              SD25G_LANE_LANE_1C(sd_index));
> 
> This looks quite terrible :(
> 
> Can we do a table here for these and then write the configuration
> table,
> that may look better and easy to maintain ?

I will restructure this.

> 
> > +
> > +     usleep_range(1000, 2000);
> > +
> > +     sdx5_rmw(SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN_SET(1),
> > +              SD25G_LANE_LANE_1C_LN_CFG_CDR_RSTN,
> > +              priv,
> > +              SD25G_LANE_LANE_1C(sd_index));
> > +
> > +     usleep_range(10000, 20000);
> > +
> > +     sdx5_rmw(SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX_SET(0xff),
> > +              SD25G_LANE_CMU_FF_REGISTER_TABLE_INDEX,
> > +              priv,
> > +              SD25G_LANE_CMU_FF(sd_index));
> > +
> > +     value = sdx5_rd(priv, SD25G_LANE_CMU_C0(sd_index));
> > +     value = SD25G_LANE_CMU_C0_PLL_LOL_UDL_GET(value);
> > +
> > +     if (value) {
> > +             dev_err(macro->priv->dev, "25G PLL Loss of Lock:
> > 0x%x\n", value);
> > +             ret = -EINVAL;
> > +     }
> > +
> > +     value = sdx5_rd(priv, SD_LANE_25G_SD_LANE_STAT(sd_index));
> > +     value = SD_LANE_25G_SD_LANE_STAT_PMA_RST_DONE_GET(value);
> > +
> > +     if (value != 0x1) {
> > +             dev_err(macro->priv->dev, "25G PMA Reset failed:
> > 0x%x\n", value);
> > +             ret = -EINVAL;
> 
> continue on error..?

I will change that.

> 
> > +     }
> > +
> > +     sdx5_rmw(SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS_SET(0x1),
> > +              SD25G_LANE_CMU_2A_R_DBG_LOL_STATUS,
> > +              priv,
> > +              SD25G_LANE_CMU_2A(sd_index));
> > +
> > +     sdx5_rmw(SD_LANE_25G_SD_SER_RST_SER_RST_SET(0x0),
> > +              SD_LANE_25G_SD_SER_RST_SER_RST,
> > +              priv,
> > 

...

> > sdx5_inst_rmw(SD10G_LANE_LANE_0E_CFG_RXLB_EN_SET(params-
> > >cfg_rxlb_en) |
> > +                   SD10G_LANE_LANE_0E_CFG_TXLB_EN_SET(params-
> > >cfg_txlb_en),
> > +                   SD10G_LANE_LANE_0E_CFG_RXLB_EN |
> > +                   SD10G_LANE_LANE_0E_CFG_TXLB_EN,
> > +                   sd_inst,
> > +                   SD10G_LANE_LANE_0E(sd_index));
> > +
> > +     sdx5_rmw(SD_LANE_SD_LANE_CFG_MACRO_RST_SET(0),
> > +              SD_LANE_SD_LANE_CFG_MACRO_RST,
> > +              priv,
> > +              SD_LANE_SD_LANE_CFG(sd_lane_tgt));
> > +
> > +     sdx5_inst_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
> > +                   SD10G_LANE_LANE_50_CFG_SSC_RESETB,
> > +                   sd_inst,
> > +                   SD10G_LANE_LANE_50(sd_index));
> > +
> > +     sdx5_rmw(SD10G_LANE_LANE_50_CFG_SSC_RESETB_SET(1),
> > +              SD10G_LANE_LANE_50_CFG_SSC_RESETB,
> > +              priv,
> > +              SD10G_LANE_LANE_50(sd_index));
> > +
> > +     sdx5_rmw(SD_LANE_MISC_SD_125_RST_DIS_SET(params->fx_100),
> > +              SD_LANE_MISC_SD_125_RST_DIS,
> > +              priv,
> > +              SD_LANE_MISC(sd_lane_tgt));
> > +
> > +     sdx5_rmw(SD_LANE_MISC_RX_ENA_SET(params->fx_100),
> > +              SD_LANE_MISC_RX_ENA,
> > +              priv,
> > +              SD_LANE_MISC(sd_lane_tgt));
> > +
> > +     sdx5_rmw(SD_LANE_MISC_MUX_ENA_SET(params->fx_100),
> > +              SD_LANE_MISC_MUX_ENA,
> > +              priv,
> > +              SD_LANE_MISC(sd_lane_tgt));
> 
> Table for this set as well as other places please

I will restructure the code here as well.
> 
> --
> ~Vinod

Thank you for your comments.

BR
Steen



