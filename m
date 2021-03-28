Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92B0034BEE7
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhC1Ubh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbhC1UbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:31:22 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EC5C061756
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 13:31:21 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c8so10766520wrq.11
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 13:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qYLnbYpWqS2yS2wqPiYUrZxylDWYv5vVnoftZSYEtFQ=;
        b=QSv86CA6pGk8K8QrR0Xmm1Ar4RUN+EmKHFhlFLTpAK+1ansXSSDQTNb1OVa8fhDSJw
         kxb5YcXvB3D0d1znls14zmcyWoIz53EpLr7ux5rSJX3QhABWdDq9JO4paW6tW3Jx9n7A
         8PKtoMUGz+KAnRiJHfgmthgTZ9kW8Smmg2FHVP3KWwWG45pNArsBWX++glycfCifAhIC
         og3sjDQWFhSpApckbK59bqpm7RnU/v7PKPY5RhgnwmlKi04Uuf2s4HRaDVNapY89rsYd
         tteNkJ+KQoONJ+iMmwqFHfi2v+6zP78CtFlJf+oAHsf0JA68lODwHGpDGn4a359vQBd+
         cUEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qYLnbYpWqS2yS2wqPiYUrZxylDWYv5vVnoftZSYEtFQ=;
        b=rv50tfPHWNWJ1jK0lOrsuEUjMcpfIKWktyF8B23djD4Wp8AqjQJPlFzKjtKLiYvDGy
         T//FgdcQkSQRUjwhsx02EKhn+occ6D9ZQZsnGNuDxk6peEYzkBD88qd08II8hNjAlIrp
         2Un7WS61V66BjfCBpeXZAxzaM2z7qQptazijpqQLpxDzEU7UA1iQRF/ru4YfQbNNoENf
         yXBz1SYFTWtd0cKh55x57b0fFG7R8y8Bp0Oln2X1e/d94Q0mL3wkoMbq3+uRnGtdnkhE
         U/MSg6Z5XMAZ7TdRRK3eDko6rR/N58FOJTXPiB7IK5u00lUcRWV8Tiu7m61cijYzI/g+
         OUOg==
X-Gm-Message-State: AOAM532jWJg7SzKamI51yRSJfSyjohZXta/bwXEsjlj0wlRqNq4yTnR9
        FXFDm2J07wSwOYp8hMaiSMKD/QYxcL189A==
X-Google-Smtp-Source: ABdhPJwwe5m9wiuGKjER2vfHWnD2B9/dBVHTNDrCwvtb/sMRZwI+gwA0bvjJPxUKKcl39SZu3MaCwA==
X-Received: by 2002:a5d:5250:: with SMTP id k16mr25390377wrc.309.1616963480227;
        Sun, 28 Mar 2021 13:31:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f1f:bb00:114c:3f71:abf:644a? (p200300ea8f1fbb00114c3f710abf644a.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:114c:3f71:abf:644a])
        by smtp.googlemail.com with ESMTPSA id t1sm29718681wry.90.2021.03.28.13.31.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Mar 2021 13:31:19 -0700 (PDT)
To:     =?UTF-8?B?TcOlbnMgUnVsbGfDpXJk?= <mans@mansr.com>,
        Andre Edich <andre.edich@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        steve.glendinning@shawell.net, Parthiban.Veerasooran@microchip.com
References: <20200826111717.405305-1-andre.edich@microchip.com>
 <20200826111717.405305-4-andre.edich@microchip.com>
 <yw1xk0prf3s0.fsf@mansr.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5 3/3] smsc95xx: add phylib support
Message-ID: <52da47b4-109a-dc4a-0fd4-023580fe86d4@gmail.com>
Date:   Sun, 28 Mar 2021 22:31:13 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <yw1xk0prf3s0.fsf@mansr.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.03.2021 21:59, Måns Rullgård wrote:
> Andre Edich <andre.edich@microchip.com> writes:
> 
>> Generally, each PHY has their own configuration and it can be done
>> through an external PHY driver.  The smsc95xx driver uses only the
>> hard-coded internal PHY configuration.
>>
>> This patch adds phylib support to probe external PHY drivers for
>> configuring external PHYs.
>>
>> The MDI-X configuration for the internal PHYs moves from
>> drivers/net/usb/smsc95xx.c to drivers/net/phy/smsc.c.
>>
>> Signed-off-by: Andre Edich <andre.edich@microchip.com>
>> ---
>>  drivers/net/phy/smsc.c     |  67 +++++++
>>  drivers/net/usb/Kconfig    |   2 +
>>  drivers/net/usb/smsc95xx.c | 399 +++++++++++++------------------------
>>  3 files changed, 203 insertions(+), 265 deletions(-)
>>
>> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
>> index 74568ae16125..638e8c3d1f4a 100644
>> --- a/drivers/net/phy/smsc.c
>> +++ b/drivers/net/phy/smsc.c
>> @@ -21,6 +21,17 @@
>>  #include <linux/netdevice.h>
>>  #include <linux/smscphy.h>
>>
>> +/* Vendor-specific PHY Definitions */
>> +/* EDPD NLP / crossover time configuration */
>> +#define PHY_EDPD_CONFIG			16
>> +#define PHY_EDPD_CONFIG_EXT_CROSSOVER_	0x0001
>> +
>> +/* Control/Status Indication Register */
>> +#define SPECIAL_CTRL_STS		27
>> +#define SPECIAL_CTRL_STS_OVRRD_AMDIX_	0x8000
>> +#define SPECIAL_CTRL_STS_AMDIX_ENABLE_	0x4000
>> +#define SPECIAL_CTRL_STS_AMDIX_STATE_	0x2000
>> +
>>  struct smsc_hw_stat {
>>  	const char *string;
>>  	u8 reg;
>> @@ -96,6 +107,54 @@ static int lan911x_config_init(struct phy_device *phydev)
>>  	return smsc_phy_ack_interrupt(phydev);
>>  }
>>
>> +static int lan87xx_config_aneg(struct phy_device *phydev)
>> +{
>> +	int rc;
>> +	int val;
>> +
>> +	switch (phydev->mdix_ctrl) {
>> +	case ETH_TP_MDI:
>> +		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_;
>> +		break;
>> +	case ETH_TP_MDI_X:
>> +		val = SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
>> +			SPECIAL_CTRL_STS_AMDIX_STATE_;
>> +		break;
>> +	case ETH_TP_MDI_AUTO:
>> +		val = SPECIAL_CTRL_STS_AMDIX_ENABLE_;
>> +		break;
>> +	default:
>> +		return genphy_config_aneg(phydev);
>> +	}
>> +
>> +	rc = phy_read(phydev, SPECIAL_CTRL_STS);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	rc &= ~(SPECIAL_CTRL_STS_OVRRD_AMDIX_ |
>> +		SPECIAL_CTRL_STS_AMDIX_ENABLE_ |
>> +		SPECIAL_CTRL_STS_AMDIX_STATE_);
>> +	rc |= val;
>> +	phy_write(phydev, SPECIAL_CTRL_STS, rc);
>> +
>> +	phydev->mdix = phydev->mdix_ctrl;
>> +	return genphy_config_aneg(phydev);
>> +}
>> +
>> +static int lan87xx_config_aneg_ext(struct phy_device *phydev)
>> +{
>> +	int rc;
>> +
>> +	/* Extend Manual AutoMDIX timer */
>> +	rc = phy_read(phydev, PHY_EDPD_CONFIG);
>> +	if (rc < 0)
>> +		return rc;
>> +
>> +	rc |= PHY_EDPD_CONFIG_EXT_CROSSOVER_;
>> +	phy_write(phydev, PHY_EDPD_CONFIG, rc);
>> +	return lan87xx_config_aneg(phydev);
>> +}
>> +
>>  /*
>>   * The LAN87xx suffers from rare absence of the ENERGYON-bit when Ethernet cable
>>   * plugs in while LAN87xx is in Energy Detect Power-Down mode. This leads to
>> @@ -250,6 +309,9 @@ static struct phy_driver smsc_phy_driver[] = {
>>  	.suspend	= genphy_suspend,
>>  	.resume		= genphy_resume,
>>  }, {
>> +	/* This covers internal PHY (phy_id: 0x0007C0C3) for
>> +	 * LAN9500 (PID: 0x9500), LAN9514 (PID: 0xec00), LAN9505 (PID: 0x9505)
>> +	 */
>>  	.phy_id		= 0x0007c0c0, /* OUI=0x00800f, Model#=0x0c */
>>  	.phy_id_mask	= 0xfffffff0,
>>  	.name		= "SMSC LAN8700",
>> @@ -262,6 +324,7 @@ static struct phy_driver smsc_phy_driver[] = {
>>  	.read_status	= lan87xx_read_status,
>>  	.config_init	= smsc_phy_config_init,
>>  	.soft_reset	= smsc_phy_reset,
>> +	.config_aneg	= lan87xx_config_aneg,
>>
>>  	/* IRQ related */
>>  	.ack_interrupt	= smsc_phy_ack_interrupt,
>> @@ -293,6 +356,9 @@ static struct phy_driver smsc_phy_driver[] = {
>>  	.suspend	= genphy_suspend,
>>  	.resume		= genphy_resume,
>>  }, {
>> +	/* This covers internal PHY (phy_id: 0x0007C0F0) for
>> +	 * LAN9500A (PID: 0x9E00), LAN9505A (PID: 0x9E01)
>> +	 */
>>  	.phy_id		= 0x0007c0f0, /* OUI=0x00800f, Model#=0x0f */
>>  	.phy_id_mask	= 0xfffffff0,
>>  	.name		= "SMSC LAN8710/LAN8720",
>> @@ -306,6 +372,7 @@ static struct phy_driver smsc_phy_driver[] = {
>>  	.read_status	= lan87xx_read_status,
>>  	.config_init	= smsc_phy_config_init,
>>  	.soft_reset	= smsc_phy_reset,
>> +	.config_aneg	= lan87xx_config_aneg_ext,
>>
>>  	/* IRQ related */
>>  	.ack_interrupt	= smsc_phy_ack_interrupt,
> 
> This change seems to be causing some trouble I'm seeing with a LAN8710A.
> Specifically lan87xx_config_aneg_ext() writes to register 16 which is
> not documented for LAN8710A (nor for LAN8720A).  The effect is somewhat
> random.  Sometimes, the device drops to 10 Mbps while the kernel still
> reports the link speed as 100 Mbps.  Other times, it doesn't work at
> all.  Everything works if I change config_aneg to lan87xx_config_aneg,
> like this:
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index 10722fed666d..07c0a7e4a350 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -408,7 +408,7 @@ static struct phy_driver smsc_phy_driver[] = {
>         .read_status    = lan87xx_read_status,
>         .config_init    = smsc_phy_config_init,
>         .soft_reset     = smsc_phy_reset,
> -       .config_aneg    = lan87xx_config_aneg_ext,
> +       .config_aneg    = lan87xx_config_aneg,
>  
>         /* IRQ related */
>         .ack_interrupt  = smsc_phy_ack_interrupt,
> 
> The internal phy of the LAN9500A does have a register 16 with
> documentation matching the usage in this patch.  Unfortunately, there
> doesn't seem to be any way of distinguishing this from the LAN8710A
> based on register values.  Anyone got any clever ideas?
> 
After reading register PHY_EDPD_CONFIG you could check whether the
read value is plausible. On the PHY's not supporting this register,
what is the read value? 0x00 or 0xff? And is this value plausible
for PHY's supporting this register?

Currently the PHY driver doesn't check the revision number
(last four bits of PHY ID). Maybe they differ.
