Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3022B883C7
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbfHIUVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:21:43 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33001 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfHIUVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:21:43 -0400
Received: by mail-wm1-f67.google.com with SMTP id p77so6884645wme.0;
        Fri, 09 Aug 2019 13:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=KRYBujXeesavxkZEhR2u/6WvFBsfbrUIYbLhrwxBRGM=;
        b=uFKxwL3JgE0/swoMA2NXpTNyIp5TCvLNtLftadRXPE/WyTthtwaM2pE5IPvoVns/IL
         VAmK0o271QCRnGMdGuZw79XaH19S845iC1xUOvhW1KT21Rq8SGcqPf2IP/XnBG2bOc3U
         lLmdLEe0fcLzz8WAj8U5ZTmduFnBj13zt0c2TJcfh3nfq/uAb6bIlLk9Egwz7LTlKbsP
         H+rc5M30ZNNJr0f+SQs1FY8vuU8nPE93PU3KS2F/j8zaM3WR52mm+OOEZ2/lcQMRLxa9
         V5CV15JQo5ZXNzw9df6jVDSzCUaBGPz9pgDTOy2tlYw3L2hKub06oRq6cI4PhW82CjTm
         Q+JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KRYBujXeesavxkZEhR2u/6WvFBsfbrUIYbLhrwxBRGM=;
        b=ad6EKO4rzX2wE6DY5BBwm0kNusWbMiCzH9k+fDFPdQIB/LDD6t+yFDks3LVZjmfM4d
         pCfjHWxyzgfxxKvSoTrjdfCU4fCX8HSh13qc/LH+paCGWz/GxvYRHLS0Ew9LYwK7qBz3
         Cvs7Lv/yKJzpL8nbkQ7dji2T7imTOHpjf4JuwNqyPBrilCQwm/v6qfNbUmqJNkyTjvOr
         N53/oxoaJ77nZ9TPWLGidlHnSTXl0EqlePvPQpD8EPUNPG/4kVsGwDoxazAFGvOTsdWr
         96yL28FAGHEpLE1YQmE2lp2+AidL//SVj+3/+oL5/Dq8bvMV4p5k1i+Uym+m0UQnM968
         QVTw==
X-Gm-Message-State: APjAAAXTw3FEYUlaHNZX/9vCmJvK7kABwQoW6f9OiJ2/hMMxtpbdrPEa
        b+78m8Nn3Xvz/MYhUKJ9QJU=
X-Google-Smtp-Source: APXvYqyLCY2+UnvuTTTsqp0D0bjjDvSXFr7omopd9/6FzcqezAx2P2Hvi0mh6qbVaBd/hIzjpvsyBQ==
X-Received: by 2002:a1c:61d4:: with SMTP id v203mr11610033wmb.164.1565382100073;
        Fri, 09 Aug 2019 13:21:40 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:2994:d24a:66a1:e0e5? (p200300EA8F2F32002994D24A66A1E0E5.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:2994:d24a:66a1:e0e5])
        by smtp.googlemail.com with ESMTPSA id o11sm305922wrw.19.2019.08.09.13.21.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 13:21:39 -0700 (PDT)
Subject: Re: [PATCH net-next v6 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
To:     Tao Ren <taoren@fb.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
References: <20190809054411.1015962-1-taoren@fb.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <97cd059c-d98e-1392-c814-f3bd628e6366@gmail.com>
Date:   Fri, 9 Aug 2019 22:21:31 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190809054411.1015962-1-taoren@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.08.2019 07:44, Tao Ren wrote:
> The BCM54616S PHY cannot work properly in RGMII->1000Base-KX mode (for
> example, on Facebook CMM BMC platform), mainly because genphy functions
> are designed for copper links, and 1000Base-X (clause 37) auto negotiation
> needs to be handled differently.
> 
> This patch enables 1000Base-X support for BCM54616S by customizing 3
> driver callbacks:
> 
>   - probe: probe callback detects PHY's operation mode based on
>     INTERF_SEL[1:0] pins and 1000X/100FX selection bit in SerDES 100-FX
>     Control register.
> 
>   - config_aneg: calls genphy_c37_config_aneg when the PHY is running in
>     1000Base-X mode; otherwise, genphy_config_aneg will be called.
> 
>   - read_status: calls genphy_c37_read_status when the PHY is running in
>     1000Base-X mode; otherwise, genphy_read_status will be called.
> 
> Signed-off-by: Tao Ren <taoren@fb.com>
> ---
>  Changes in v6:
>   - nothing changed.
>  Changes in v5:
>   - include Heiner's patch "net: phy: add support for clause 37
>     auto-negotiation" into the series.
>   - use genphy_c37_config_aneg and genphy_c37_read_status in BCM54616S
>     PHY driver's callback when the PHY is running in 1000Base-X mode.
>  Changes in v4:
>   - add bcm54616s_config_aneg_1000bx() to deal with auto negotiation in
>     1000Base-X mode.
>  Changes in v3:
>   - rename bcm5482_read_status to bcm54xx_read_status so the callback can
>     be shared by BCM5482 and BCM54616S.
>  Changes in v2:
>   - Auto-detect PHY operation mode instead of passing DT node.
>   - move PHY mode auto-detect logic from config_init to probe callback.
>   - only set speed (not including duplex) in read_status callback.
>   - update patch description with more background to avoid confusion.
>   - patch #1 in the series ("net: phy: broadcom: set features explicitly
>     for BCM54616") is dropped: the fix should go to get_features callback
>     which may potentially depend on this patch.
> 
>  drivers/net/phy/broadcom.c | 54 +++++++++++++++++++++++++++++++++++---
>  include/linux/brcmphy.h    | 10 +++++--
>  2 files changed, 58 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> index 937d0059e8ac..fbd76a31c142 100644
> --- a/drivers/net/phy/broadcom.c
> +++ b/drivers/net/phy/broadcom.c
> @@ -383,9 +383,9 @@ static int bcm5482_config_init(struct phy_device *phydev)
>  		/*
>  		 * Select 1000BASE-X register set (primary SerDes)
>  		 */
> -		reg = bcm_phy_read_shadow(phydev, BCM5482_SHD_MODE);
> -		bcm_phy_write_shadow(phydev, BCM5482_SHD_MODE,
> -				     reg | BCM5482_SHD_MODE_1000BX);
> +		reg = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> +		bcm_phy_write_shadow(phydev, BCM54XX_SHD_MODE,
> +				     reg | BCM54XX_SHD_MODE_1000BX);
>  
>  		/*
>  		 * LED1=ACTIVITYLED, LED3=LINKSPD[2]
> @@ -451,12 +451,44 @@ static int bcm5481_config_aneg(struct phy_device *phydev)
>  	return ret;
>  }
>  
> +static int bcm54616s_probe(struct phy_device *phydev)
> +{
> +	int val, intf_sel;
> +
> +	val = bcm_phy_read_shadow(phydev, BCM54XX_SHD_MODE);
> +	if (val < 0)
> +		return val;
> +
> +	/* The PHY is strapped in RGMII to fiber mode when INTERF_SEL[1:0]
> +	 * is 01b.
> +	 */
> +	intf_sel = (val & BCM54XX_SHD_INTF_SEL_MASK) >> 1;
> +	if (intf_sel == 1) {
> +		val = bcm_phy_read_shadow(phydev, BCM54616S_SHD_100FX_CTRL);
> +		if (val < 0)
> +			return val;
> +
> +		/* Bit 0 of the SerDes 100-FX Control register, when set
> +		 * to 1, sets the MII/RGMII -> 100BASE-FX configuration.
> +		 * When this bit is set to 0, it sets the GMII/RGMII ->
> +		 * 1000BASE-X configuration.
> +		 */
> +		if (!(val & BCM54616S_100FX_MODE))
> +			phydev->dev_flags |= PHY_BCM_FLAGS_MODE_1000BX;
> +	}
> +
> +	return 0;
> +}
> +
>  static int bcm54616s_config_aneg(struct phy_device *phydev)
>  {
>  	int ret;
>  
>  	/* Aneg firsly. */
> -	ret = genphy_config_aneg(phydev);
> +	if (phydev->dev_flags & PHY_BCM_FLAGS_MODE_1000BX)
> +		ret = genphy_c37_config_aneg(phydev);
> +	else
> +		ret = genphy_config_aneg(phydev);
>  

I'm just wondering whether it needs to be considered that 100base-FX
doesn't support auto-negotiation. I suppose BMSR reports aneg as
supported, therefore phylib will use aneg per default.
Not sure who could set 100Base-FX mode when, but maybe at that place
also phydev->autoneg needs to be cleared. Did you test 100Base-FX mode?

Heiner
