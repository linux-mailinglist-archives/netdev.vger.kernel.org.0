Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E077433D4A5
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 14:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233247AbhCPNOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 09:14:41 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41076 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbhCPNOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 09:14:33 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 12GDEIpx086609;
        Tue, 16 Mar 2021 08:14:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1615900458;
        bh=0a9+2pwiRj3HgBy0Tmcg4RcLEetQ3bkJHEFZgypmw8c=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=vg0q3bPku6180/hs13QuMC/0ZYA9Qr0BMmrM3c8jNdaeOfFYGP2b7x8NDLhpy4G50
         jamBZ4+HE8Z8zfsSPmOgRxIrjAxo45QXih1cbYq73N+cGfZ4ejmORvM6DPOVe3dzU0
         8/QOGMuEDy9w0fa0ce1UV2iEO+hhp1uVG96XuLvA=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 12GDEI9W060553
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 16 Mar 2021 08:14:18 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 16
 Mar 2021 08:14:18 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Tue, 16 Mar 2021 08:14:18 -0500
Received: from [10.250.235.175] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 12GDEEH8037551;
        Tue, 16 Mar 2021 08:14:15 -0500
Subject: Re: [PATCH v15 2/4] phy: Add media type and speed serdes
 configuration interfaces
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        Vinod Koul <vkoul@kernel.org>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
References: <20210218161451.3489955-1-steen.hegelund@microchip.com>
 <20210218161451.3489955-3-steen.hegelund@microchip.com>
From:   Kishon Vijay Abraham I <kishon@ti.com>
Message-ID: <694b0f66-64ab-626c-96fa-e703abea88c2@ti.com>
Date:   Tue, 16 Mar 2021 18:44:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210218161451.3489955-3-steen.hegelund@microchip.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18/02/21 9:44 pm, Steen Hegelund wrote:
> Provide new phy configuration interfaces for media type and speed that
> allows e.g. PHYs used for ethernet to be configured with this
> information.
> 
> Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>

Acked-By: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/phy-core.c  | 30 ++++++++++++++++++++++++++++++
>  include/linux/phy/phy.h | 26 ++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 71cb10826326..ccb575b13777 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -373,6 +373,36 @@ int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int submode)
>  }
>  EXPORT_SYMBOL_GPL(phy_set_mode_ext);
>  
> +int phy_set_media(struct phy *phy, enum phy_media media)
> +{
> +	int ret;
> +
> +	if (!phy || !phy->ops->set_media)
> +		return 0;
> +
> +	mutex_lock(&phy->mutex);
> +	ret = phy->ops->set_media(phy, media);
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_set_media);
> +
> +int phy_set_speed(struct phy *phy, int speed)
> +{
> +	int ret;
> +
> +	if (!phy || !phy->ops->set_speed)
> +		return 0;
> +
> +	mutex_lock(&phy->mutex);
> +	ret = phy->ops->set_speed(phy, speed);
> +	mutex_unlock(&phy->mutex);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(phy_set_speed);
> +
>  int phy_reset(struct phy *phy)
>  {
>  	int ret;
> diff --git a/include/linux/phy/phy.h b/include/linux/phy/phy.h
> index e435bdb0bab3..0ed434d02196 100644
> --- a/include/linux/phy/phy.h
> +++ b/include/linux/phy/phy.h
> @@ -44,6 +44,12 @@ enum phy_mode {
>  	PHY_MODE_DP
>  };
>  
> +enum phy_media {
> +	PHY_MEDIA_DEFAULT,
> +	PHY_MEDIA_SR,
> +	PHY_MEDIA_DAC,
> +};
> +
>  /**
>   * union phy_configure_opts - Opaque generic phy configuration
>   *
> @@ -64,6 +70,8 @@ union phy_configure_opts {
>   * @power_on: powering on the phy
>   * @power_off: powering off the phy
>   * @set_mode: set the mode of the phy
> + * @set_media: set the media type of the phy (optional)
> + * @set_speed: set the speed of the phy (optional)
>   * @reset: resetting the phy
>   * @calibrate: calibrate the phy
>   * @release: ops to be performed while the consumer relinquishes the PHY
> @@ -75,6 +83,8 @@ struct phy_ops {
>  	int	(*power_on)(struct phy *phy);
>  	int	(*power_off)(struct phy *phy);
>  	int	(*set_mode)(struct phy *phy, enum phy_mode mode, int submode);
> +	int	(*set_media)(struct phy *phy, enum phy_media media);
> +	int	(*set_speed)(struct phy *phy, int speed);
>  
>  	/**
>  	 * @configure:
> @@ -215,6 +225,8 @@ int phy_power_off(struct phy *phy);
>  int phy_set_mode_ext(struct phy *phy, enum phy_mode mode, int submode);
>  #define phy_set_mode(phy, mode) \
>  	phy_set_mode_ext(phy, mode, 0)
> +int phy_set_media(struct phy *phy, enum phy_media media);
> +int phy_set_speed(struct phy *phy, int speed);
>  int phy_configure(struct phy *phy, union phy_configure_opts *opts);
>  int phy_validate(struct phy *phy, enum phy_mode mode, int submode,
>  		 union phy_configure_opts *opts);
> @@ -344,6 +356,20 @@ static inline int phy_set_mode_ext(struct phy *phy, enum phy_mode mode,
>  #define phy_set_mode(phy, mode) \
>  	phy_set_mode_ext(phy, mode, 0)
>  
> +static inline int phy_set_media(struct phy *phy, enum phy_media media)
> +{
> +	if (!phy)
> +		return 0;
> +	return -ENODEV;
> +}
> +
> +static inline int phy_set_speed(struct phy *phy, int speed)
> +{
> +	if (!phy)
> +		return 0;
> +	return -ENODEV;
> +}
> +
>  static inline enum phy_mode phy_get_mode(struct phy *phy)
>  {
>  	return PHY_MODE_INVALID;
> 
