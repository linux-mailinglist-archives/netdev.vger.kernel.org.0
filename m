Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD00290A12
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 23:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfHPVN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 17:13:26 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40041 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbfHPVN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 17:13:26 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so5118798wmj.5;
        Fri, 16 Aug 2019 14:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mVl5EoVvdOkYf9ugb8wXKRRd2RZ+W3VB/nYz2/QB/4s=;
        b=IdcjvFf3l6hUnkRaA28bOhQbyDUUMrxLJxe8oPyzqyOALd0hx4wh3Mv+bcQ1WsGWva
         LXtir0U+qYlCQYqFoNwQRSwi7/Y6WJLScpkLGiMBYiu4cNuPw1I1lVyaNxq7Mpls7IZM
         U49YmmEy1rO0LbZ1rlDwcBnsk9cz9ZYRKw94ie19qcAiHQh5lNQ/y2nMtupmX2bNA8b0
         rO5RRWRnzTSejezsiz4G7j7TQK4NYnzucvN1mlOXB6JF92t5IQsURqsnzimGRzZZxchY
         zodtpQUVpMw3HTGbsgSITO7uYejhq0cQH/0VxnhV3nNe9iKI99HefNe1oSiBwBbwidr7
         Mg+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mVl5EoVvdOkYf9ugb8wXKRRd2RZ+W3VB/nYz2/QB/4s=;
        b=CdRTxBBwfyql44eDjPDnnbi/PiH6QwhXpxW3g2jcjm+sUAZHEgZGLFOlOm5SLjn3xo
         ey1e5DtarkAZLH+0JtTjTs4r8PJzEYpXW2LF/j4Nq6tVfhUBwi0KDnyhbSTBttwEhcYF
         XrIR0gpKaC+DVQhhpqbozPxt1Hw2LigY10d6O9giwrCjKz8IUUxvVyBgowaxhdQSV/Va
         FOQ2iEaL1zWBOSAETyYHupK1HHUqS+ff3xqXt+nZ6QSzoByzY8n1hCQu6+ic+R+2uUgi
         p66zm+EIrMakws4iqWiZFgY4bygWAsgUd7NLck9IG6sJ2RGVcYITNTFwNpldZ/THY3ud
         cSUg==
X-Gm-Message-State: APjAAAVeefMscSYhiaeCg/6FIdp2IHqmmOzaaSTh1xN3oZEPyWAmuN6w
        oFpNuiKnI5rMDTev655jLss1LTVg
X-Google-Smtp-Source: APXvYqzBeDQzbuaF63p2FB3zUwinNST2Zw3XDmr1sn2SAkQSi1DRpiAWdTHs6DDA79SaK7lRp2NShA==
X-Received: by 2002:a05:600c:24cb:: with SMTP id 11mr8788063wmu.94.1565990002145;
        Fri, 16 Aug 2019 14:13:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:4112:e131:7f21:ec09? (p200300EA8F2F32004112E1317F21EC09.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:4112:e131:7f21:ec09])
        by smtp.googlemail.com with ESMTPSA id t24sm4823560wmj.14.2019.08.16.14.13.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Aug 2019 14:13:21 -0700 (PDT)
Subject: Re: [PATCH net-next 1/1] Added BASE-T1 PHY support to PHY Subsystem
To:     Christian Herber <christian.herber@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20190815153209.21529-1-christian.herber@nxp.com>
 <20190815153209.21529-2-christian.herber@nxp.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <95eda63a-8202-3f49-c86a-e418162b2811@gmail.com>
Date:   Fri, 16 Aug 2019 23:13:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190815153209.21529-2-christian.herber@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.08.2019 17:32, Christian Herber wrote:
> BASE-T1 is a category of Ethernet PHYs.
> They use a single copper pair for transmission.
> This patch add basic support for this category of PHYs.
> It coveres the discovery of abilities and basic configuration.
> It includes setting fixed speed and enabling auto-negotiation.
> BASE-T1 devices should always Clause-45 managed.
> Therefore, this patch extends phy-c45.c.
> While for some functions like auto-neogtiation different registers are
> used, the layout of these registers is the same for the used fields.
> Thus, much of the logic of basic Clause-45 devices can be reused.
> 
> Signed-off-by: Christian Herber <christian.herber@nxp.com>
> ---
>  drivers/net/phy/phy-c45.c    | 113 +++++++++++++++++++++++++++++++----
>  drivers/net/phy/phy-core.c   |   4 +-
>  include/uapi/linux/ethtool.h |   2 +
>  include/uapi/linux/mdio.h    |  21 +++++++
>  4 files changed, 129 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
> index b9d4145781ca..9ff0b8c785de 100644
> --- a/drivers/net/phy/phy-c45.c
> +++ b/drivers/net/phy/phy-c45.c
> @@ -8,13 +8,23 @@
>  #include <linux/mii.h>
>  #include <linux/phy.h>
>  
> +#define IS_100BASET1(phy) (linkmode_test_bit( \
> +			   ETHTOOL_LINK_MODE_100baseT1_Full_BIT, \
> +			   (phy)->supported))
> +#define IS_1000BASET1(phy) (linkmode_test_bit( \
> +			    ETHTOOL_LINK_MODE_1000baseT1_Full_BIT, \
> +			    (phy)->supported))
> +
Why is there no such macro for 10BaseT1?

> +static u32 get_aneg_ctrl(struct phy_device *phydev);
> +static u32 get_aneg_stat(struct phy_device *phydev);
> +
>  /**
>   * genphy_c45_setup_forced - configures a forced speed
>   * @phydev: target phy_device struct
>   */
>  int genphy_c45_pma_setup_forced(struct phy_device *phydev)
>  {
> -	int ctrl1, ctrl2, ret;
> +	int ctrl1, ctrl2, base_t1_ctrl = 0, ret;
>  
>  	/* Half duplex is not supported */
>  	if (phydev->duplex != DUPLEX_FULL)
> @@ -28,6 +38,16 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
>  	if (ctrl2 < 0)
>  		return ctrl2;
>  
> +	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev)) {

10BaseT1 doesn't need to be considered here?
And maybe it would be better to have a flag for BaseT1 at phy_device level
(based on bit MDIO_PMA_EXTABLE_BASET1?) instead of checking whether certain
T1 modes are supported. Then we would be more future-proof in case of new
T1 modes.

> +		base_t1_ctrl = phy_read_mmd(phydev,
> +					    MDIO_MMD_PMAPMD,
> +					    MDIO_PMA_BASET1CTRL);
> +		if (base_t1_ctrl < 0)
> +			return base_t1_ctrl;
> +
> +		base_t1_ctrl &= ~(MDIO_PMA_BASET1CTRL_TYPE);
> +	}
> +
>  	ctrl1 &= ~MDIO_CTRL1_SPEEDSEL;
>  	/*
>  	 * PMA/PMD type selection is 1.7.5:0 not 1.7.3:0.  See 45.2.1.6.1
> @@ -41,12 +61,21 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
>  		break;
>  	case SPEED_100:
>  		ctrl1 |= MDIO_PMA_CTRL1_SPEED100;
> -		ctrl2 |= MDIO_PMA_CTRL2_100BTX;
> +		if (IS_100BASET1(phydev)) {
> +			ctrl2 |= MDIO_PMA_CTRL2_BT1;
> +			base_t1_ctrl |= MDIO_PMA_BASET1CTRL_TYPE_100BT1;
> +		} else {
> +			ctrl2 |= MDIO_PMA_CTRL2_100BTX;
> +		}
>  		break;
>  	case SPEED_1000:
>  		ctrl1 |= MDIO_PMA_CTRL1_SPEED1000;
> -		/* Assume 1000base-T */
> -		ctrl2 |= MDIO_PMA_CTRL2_1000BT;
> +		if (IS_1000BASET1(phydev)) {
> +			ctrl2 |= MDIO_PMA_CTRL2_BT1;
> +			base_t1_ctrl |= MDIO_PMA_BASET1CTRL_TYPE_1000BT1;
> +		} else {
> +			ctrl2 |= MDIO_PMA_CTRL2_1000BT;
> +		}
>  		break;
>  	case SPEED_2500:
>  		ctrl1 |= MDIO_CTRL1_SPEED2_5G;
> @@ -75,6 +104,14 @@ int genphy_c45_pma_setup_forced(struct phy_device *phydev)
>  	if (ret < 0)
>  		return ret;
>  
> +	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev)) {
> +		ret = phy_write_mmd(phydev,
> +				    MDIO_MMD_PMAPMD,
> +				    MDIO_PMA_BASET1CTRL,
> +				    base_t1_ctrl);
> +		if (ret < 0)
> +			return ret;
> +	}
>  	return genphy_c45_an_disable_aneg(phydev);
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_pma_setup_forced);
> @@ -135,8 +172,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_config_aneg);
>   */
>  int genphy_c45_an_disable_aneg(struct phy_device *phydev)
>  {
> -
> -	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
> +	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev),
>  				  MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
> @@ -151,7 +187,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_an_disable_aneg);
>   */
>  int genphy_c45_restart_aneg(struct phy_device *phydev)
>  {
> -	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1,
> +	return phy_set_bits_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev),
>  				MDIO_AN_CTRL1_ENABLE | MDIO_AN_CTRL1_RESTART);
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_restart_aneg);
> @@ -171,7 +207,7 @@ int genphy_c45_check_and_restart_aneg(struct phy_device *phydev, bool restart)
>  
>  	if (!restart) {
>  		/* Configure and restart aneg if it wasn't set before */
> -		ret = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_CTRL1);
> +		ret = phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_ctrl(phydev));
>  		if (ret < 0)
>  			return ret;
>  
> @@ -199,7 +235,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_check_and_restart_aneg);
>   */
>  int genphy_c45_aneg_done(struct phy_device *phydev)
>  {
> -	int val = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_STAT1);
> +	int val = phy_read_mmd(phydev, MDIO_MMD_AN, get_aneg_stat(phydev));
>  
>  	return val < 0 ? val : val & MDIO_AN_STAT1_COMPLETE ? 1 : 0;
>  }
> @@ -385,7 +421,9 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
>   * PMA Extended Abilities (1.11) register, indicating 1000BASET an 10G related
>   * modes. If bit 1.11.14 is set, then the list is also extended with the modes
>   * in the 2.5G/5G PMA Extended register (1.21), indicating if 2.5GBASET and
> - * 5GBASET are supported.
> + * 5GBASET are supported. If bit 1.11.11 is set, then the list is also extended
> + * with the modes in the BASE-T1 PMA Extended register (1.18), indicating if
> + * 10/100/1000BASET-1 are supported.
>   */
>  int genphy_c45_pma_read_abilities(struct phy_device *phydev)
>  {
> @@ -470,6 +508,29 @@ int genphy_c45_pma_read_abilities(struct phy_device *phydev)
>  					 phydev->supported,
>  					 val & MDIO_PMA_NG_EXTABLE_5GBT);
>  		}
> +
> +		if (val & MDIO_PMA_EXTABLE_BASET1) {
> +			val = phy_read_mmd(phydev, MDIO_MMD_PMAPMD,
> +					   MDIO_PMA_BASET1_EXTABLE);
> +			if (val < 0)
> +				return val;
> +
> +			linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT1_Full_BIT,
> +					 phydev->supported,
> +					 val & MDIO_PMA_BASET1_EXTABLE_100BT1);
> +
> +			linkmode_mod_bit(ETHTOOL_LINK_MODE_1000baseT1_Full_BIT,
> +					 phydev->supported,
> +					 val & MDIO_PMA_BASET1_EXTABLE_1000BT1);
> +
> +			linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1L_Full_BIT,
> +					 phydev->supported,
> +					 val & MDIO_PMA_BASET1_EXTABLE_10BT1L);
> +
> +			linkmode_mod_bit(ETHTOOL_LINK_MODE_10baseT1S_Full_BIT,
> +					 phydev->supported,
> +					 val & MDIO_PMA_BASET1_EXTABLE_10BT1S);
> +		}
>  	}
>  
>  	return 0;
> @@ -509,6 +570,38 @@ int genphy_c45_read_status(struct phy_device *phydev)
>  }
>  EXPORT_SYMBOL_GPL(genphy_c45_read_status);
>  
> +/**
> + * get_aneg_ctrl - Get the register address for auto-
> + * negotiation control register
> + * @phydev: target phy_device struct
> + *
> + */
> +static u32 get_aneg_ctrl(struct phy_device *phydev)
> +{
> +	u32 ctrl = MDIO_CTRL1;
> +
> +	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))
> +		ctrl = MDIO_AN_BT1_CTRL;
> +
AFAICS 10BaseT1 has separate aneg registers (526/527).
To be considered here?

> +	return ctrl;
> +}
> +
> +/**
> + * get_aneg_ctrl - Get the register address for auto-
> + * negotiation status register
> + * @phydev: target phy_device struct
> + *
> + */
> +static u32 get_aneg_stat(struct phy_device *phydev)
> +{
> +	u32 stat = MDIO_STAT1;
> +
> +	if (IS_100BASET1(phydev) || IS_1000BASET1(phydev))
> +		stat = MDIO_AN_BT1_STAT;
> +
> +	return stat;
> +}
> +
>  /* The gen10g_* functions are the old Clause 45 stub */
>  
>  int gen10g_config_aneg(struct phy_device *phydev)
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 369903d9b6ec..b50576f7709a 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -8,7 +8,7 @@
>  
>  const char *phy_speed_to_str(int speed)
>  {
> -	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 69,
> +	BUILD_BUG_ON_MSG(__ETHTOOL_LINK_MODE_MASK_NBITS != 71,
>  		"Enum ethtool_link_mode_bit_indices and phylib are out of sync. "
>  		"If a speed or mode has been added please update phy_speed_to_str "
>  		"and the PHY settings array.\n");
> @@ -140,6 +140,8 @@ static const struct phy_setting settings[] = {
>  	/* 10M */
>  	PHY_SETTING(     10, FULL,     10baseT_Full		),
>  	PHY_SETTING(     10, HALF,     10baseT_Half		),
> +	PHY_SETTING(     10, FULL,     10baseT1L_Full		),
> +	PHY_SETTING(     10, FULL,     10baseT1S_Full		),
>  };
>  #undef PHY_SETTING
>  
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index dd06302aa93e..e429cc8da31a 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -1485,6 +1485,8 @@ enum ethtool_link_mode_bit_indices {
>  	ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT	 = 66,
>  	ETHTOOL_LINK_MODE_100baseT1_Full_BIT		 = 67,
>  	ETHTOOL_LINK_MODE_1000baseT1_Full_BIT		 = 68,
> +	ETHTOOL_LINK_MODE_10baseT1L_Full_BIT		 = 69,
> +	ETHTOOL_LINK_MODE_10baseT1S_Full_BIT		 = 70,
>  
>  	/* must be last entry */
>  	__ETHTOOL_LINK_MODE_MASK_NBITS
> diff --git a/include/uapi/linux/mdio.h b/include/uapi/linux/mdio.h
> index 0a552061ff1c..6fd5ff632b8e 100644
> --- a/include/uapi/linux/mdio.h
> +++ b/include/uapi/linux/mdio.h
> @@ -43,6 +43,7 @@
>  #define MDIO_PKGID1		14	/* Package identifier */
>  #define MDIO_PKGID2		15
>  #define MDIO_AN_ADVERTISE	16	/* AN advertising (base page) */
> +#define MDIO_PMA_BASET1_EXTABLE	18	/* BASE-T1 PMA/PMD extended ability */
>  #define MDIO_AN_LPA		19	/* AN LP abilities (base page) */
>  #define MDIO_PCS_EEE_ABLE	20	/* EEE Capability register */
>  #define MDIO_PMA_NG_EXTABLE	21	/* 2.5G/5G PMA/PMD extended ability */
> @@ -57,11 +58,16 @@
>  #define MDIO_PMA_10GBT_SNR	133	/* 10GBASE-T SNR margin, lane A.
>  					 * Lanes B-D are numbered 134-136. */
>  #define MDIO_PMA_10GBR_FECABLE	170	/* 10GBASE-R FEC ability */
> +#define MDIO_PMA_BASET1CTRL     2100 /* BASE-T1 PMA/PMD control */
>  #define MDIO_PCS_10GBX_STAT1	24	/* 10GBASE-X PCS status 1 */
>  #define MDIO_PCS_10GBRT_STAT1	32	/* 10GBASE-R/-T PCS status 1 */
>  #define MDIO_PCS_10GBRT_STAT2	33	/* 10GBASE-R/-T PCS status 2 */
>  #define MDIO_AN_10GBT_CTRL	32	/* 10GBASE-T auto-negotiation control */
>  #define MDIO_AN_10GBT_STAT	33	/* 10GBASE-T auto-negotiation status */
> +#define MDIO_AN_BT1_CTRL	512	/* BASE-T1 auto-negotiation control */
> +#define MDIO_AN_BT1_STAT	513	/* BASE-T1 auto-negotiation status */
> +#define MDIO_AN_10BT1_CTRL	526	/* 10BASE-T1 auto-negotiation control */
> +#define MDIO_AN_10BT1_STAT	527	/* 10BASE-T1 auto-negotiation status */
>  
>  /* LASI (Link Alarm Status Interrupt) registers, defined by XENPAK MSA. */
>  #define MDIO_PMA_LASI_RXCTRL	0x9000	/* RX_ALARM control */
> @@ -151,6 +157,7 @@
>  #define MDIO_PMA_CTRL2_100BTX		0x000e	/* 100BASE-TX type */
>  #define MDIO_PMA_CTRL2_10BT		0x000f	/* 10BASE-T type */
>  #define MDIO_PMA_CTRL2_2_5GBT		0x0030  /* 2.5GBaseT type */
> +#define MDIO_PMA_CTRL2_BT1	        0x003D	/* BASE-T1 type */
>  #define MDIO_PMA_CTRL2_5GBT		0x0031  /* 5GBaseT type */
>  #define MDIO_PCS_CTRL2_TYPE		0x0003	/* PCS type selection */
>  #define MDIO_PCS_CTRL2_10GBR		0x0000	/* 10GBASE-R type */
> @@ -205,8 +212,16 @@
>  #define MDIO_PMA_EXTABLE_1000BKX	0x0040	/* 1000BASE-KX ability */
>  #define MDIO_PMA_EXTABLE_100BTX		0x0080	/* 100BASE-TX ability */
>  #define MDIO_PMA_EXTABLE_10BT		0x0100	/* 10BASE-T ability */
> +#define MDIO_PMA_EXTABLE_BASET1		0x0800  /* BASE-T1 ability */
>  #define MDIO_PMA_EXTABLE_NBT		0x4000  /* 2.5/5GBASE-T ability */
>  
> +/* PMA BASE-T1 control register. */
> +#define MDIO_PMA_BASET1CTRL_TYPE         0x000f /* PMA/PMD BASE-T1 type sel. */
> +#define MDIO_PMA_BASET1CTRL_TYPE_100BT1  0x0000 /* 100BASE-T1 */
> +#define MDIO_PMA_BASET1CTRL_TYPE_1000BT1 0x0001 /* 1000BASE-T1 */
> +#define MDIO_PMA_BASET1CTRL_TYPE_10BT1L  0x0002 /* 10BASE-T1L */
> +#define MDIO_PMA_BASET1CTRL_TYPE_10BT1S  0x0003 /* 10BASE-T1S */
> +
>  /* PHY XGXS lane state register. */
>  #define MDIO_PHYXS_LNSTAT_SYNC0		0x0001
>  #define MDIO_PHYXS_LNSTAT_SYNC1		0x0002
> @@ -281,6 +296,12 @@
>  #define MDIO_PMA_NG_EXTABLE_2_5GBT	0x0001	/* 2.5GBASET ability */
>  #define MDIO_PMA_NG_EXTABLE_5GBT	0x0002	/* 5GBASET ability */
>  
> +/* BASE-T1 Extended abilities register. */
> +#define MDIO_PMA_BASET1_EXTABLE_100BT1   0x0001  /* 100BASE-T1 ability */
> +#define MDIO_PMA_BASET1_EXTABLE_1000BT1  0x0002  /* 1000BASE-T1 ability */
> +#define MDIO_PMA_BASET1_EXTABLE_10BT1L   0x0004  /* 10BASE-T1L ability */
> +#define MDIO_PMA_BASET1_EXTABLE_10BT1S   0x0008  /* 10BASE-T1S ability */
> +
>  /* LASI RX_ALARM control/status registers. */
>  #define MDIO_PMA_LASI_RX_PHYXSLFLT	0x0001	/* PHY XS RX local fault */
>  #define MDIO_PMA_LASI_RX_PCSLFLT	0x0008	/* PCS RX local fault */
> 

