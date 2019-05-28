Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F67A2CF7A
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 21:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbfE1T2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 15:28:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42712 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727535AbfE1T2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 15:28:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id l2so21514102wrb.9;
        Tue, 28 May 2019 12:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CMXsiVNgko7QGrxcP0nM2gD3dGeneAShDKIZ6YcTRgQ=;
        b=vKk6yas1sOSw+g2ZI4yh248NxZFsWQcSaUIoLLbhzNfAvWxsW10bDivZRxyXmAvL3C
         0U75Xh9kllM99KzEHVzPAX5cOLeD6BNYr8jMyV4uX3zZyG6THQocx3Znzdyz3ewCrqPK
         Sva5ntDVWtpY3jEyouf3/lutFhHl3key7w9y1zdb6wpv1st2aqe5DZhbu+6NpG/nJ6r8
         anoZHCX9b6oNAwS3sDqv/VtKeCN4GYTh9x15H3UrwpzWbsOYD3rkbBMQovdkEkTOEKMp
         1/T4Q0mdu1aMT1piDsoxTx+mdUa/JvR1gYb66+FUoDL8sbFz5pgBR6kPeljwoxmIaskH
         bHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CMXsiVNgko7QGrxcP0nM2gD3dGeneAShDKIZ6YcTRgQ=;
        b=O74DgPVNPNEE5hV5z07urVzNA1n6PeFskey6+xk/Qy3OPbq0VkUZdc5pzm8wugltZJ
         aaLJwgVFPqiKggB1U4ypjovnqgE+5XWb4vOpTAlDCDIgP22lU5uTL8BmPjb6SaulA2BT
         27QSxbRHAFQezCP35tcSpSuGZtS3xHUFqvuyM9RKH5tEZowGu0zQiWLBaIb14QWN5eV4
         kRzbc10ryx4iDBHbpECUnP7njf1gnwqV3QauxZBkAcXbqo0F0Ax3Zv6gsAt0sBcjSaoN
         76hkDe3CyeNA/2wwRxUwTFd3YpcjRMYUy+Z0v4V1b7pTQeKePp9lUAvFyF6TJXPFT+cV
         sutw==
X-Gm-Message-State: APjAAAUrwENjcBPOOE+W4pwPS5bd9iNY67IzEVggekRQwJmEGmwMMcPr
        Whvr2V9+oMW9GhvAx7pI22oTRNlg
X-Google-Smtp-Source: APXvYqzZMao/gYFKB2n4z+RBhVReXk0nCZaSxBm3SltLL57v/5G3nxUKlstBruVIC37V0zhC2A+XgQ==
X-Received: by 2002:a5d:628d:: with SMTP id k13mr20919424wru.319.1559071695131;
        Tue, 28 May 2019 12:28:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137? (p200300EA8BF3BD00FCC33D8B511A9137.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137])
        by smtp.googlemail.com with ESMTPSA id 67sm4829058wmd.38.2019.05.28.12.28.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 12:28:14 -0700 (PDT)
Subject: Re: [PATCH V2] net: phy: tja11xx: Add IRQ support to the driver
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <20190528192324.28862-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <96793717-a55c-7844-f7c0-cc357c774a19@gmail.com>
Date:   Tue, 28 May 2019 21:28:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190528192324.28862-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.2019 21:23, Marek Vasut wrote:
> Add support for handling the TJA11xx PHY IRQ signal.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: linux-hwmon@vger.kernel.org
> ---
> V2: - Define each bit of the MII_INTEN register and a mask
>     - Drop IRQ acking from tja11xx_config_intr()
> ---
>  drivers/net/phy/nxp-tja11xx.c | 48 +++++++++++++++++++++++++++++++++++
>  1 file changed, 48 insertions(+)
> 
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index b705d0bd798b..b41af609607d 100644
> --- a/drivers/net/phy/nxp-tja11xx.c
> +++ b/drivers/net/phy/nxp-tja11xx.c
> @@ -40,6 +40,29 @@
>  #define MII_INTSRC_TEMP_ERR		BIT(1)
>  #define MII_INTSRC_UV_ERR		BIT(3)
>  
> +#define MII_INTEN			22
> +#define MII_INTEN_PWON_EN		BIT(15)
> +#define MII_INTEN_WAKEUP_EN		BIT(14)
> +#define MII_INTEN_PHY_INIT_FAIL_EN	BIT(11)
> +#define MII_INTEN_LINK_STATUS_FAIL_EN	BIT(10)
> +#define MII_INTEN_LINK_STATUS_UP_EN	BIT(9)
> +#define MII_INTEN_SYM_ERR_EN		BIT(8)
> +#define MII_INTEN_TRAINING_FAILED_EN	BIT(7)
> +#define MII_INTEN_SQI_WARNING_EN	BIT(6)
> +#define MII_INTEN_CONTROL_ERR_EN	BIT(5)
> +#define MII_INTEN_UV_ERR_EN		BIT(3)
> +#define MII_INTEN_UV_RECOVERY_EN	BIT(2)
> +#define MII_INTEN_TEMP_ERR_EN		BIT(1)
> +#define MII_INTEN_SLEEP_ABORT_EN	BIT(0)
> +#define MII_INTEN_MASK							\
> +	(MII_INTEN_PWON_EN | MII_INTEN_WAKEUP_EN |			\
> +	MII_INTEN_PHY_INIT_FAIL_EN | MII_INTEN_LINK_STATUS_FAIL_EN |	\
> +	MII_INTEN_LINK_STATUS_UP_EN | MII_INTEN_SYM_ERR_EN |		\
> +	MII_INTEN_TRAINING_FAILED_EN | MII_INTEN_SQI_WARNING_EN |	\
> +	MII_INTEN_CONTROL_ERR_EN | MII_INTEN_UV_ERR_EN |		\
> +	MII_INTEN_UV_RECOVERY_EN | MII_INTEN_TEMP_ERR_EN |		\
> +	MII_INTEN_SLEEP_ABORT_EN)

Why do you enable all these interrupt sources? As I said, phylib needs
link change info only.

> +
>  #define MII_COMMSTAT			23
>  #define MII_COMMSTAT_LINK_UP		BIT(15)
>  
> @@ -239,6 +262,25 @@ static int tja11xx_read_status(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int tja11xx_config_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		ret = phy_write(phydev, MII_INTEN, MII_INTEN_MASK);
> +	else
> +		ret = phy_write(phydev, MII_INTEN, 0);
> +
> +	return ret < 0 ? ret : 0;

phy_write returns only 0 or negative errno. You don't need
variable ret.

> +}
> +
> +static int tja11xx_ack_interrupt(struct phy_device *phydev)
> +{
> +	int ret = phy_read(phydev, MII_INTSRC);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
>  static int tja11xx_get_sset_count(struct phy_device *phydev)
>  {
>  	return ARRAY_SIZE(tja11xx_hw_stats);
> @@ -366,6 +408,9 @@ static struct phy_driver tja11xx_driver[] = {
>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
>  		.set_loopback   = genphy_loopback,
> +		/* IRQ related */
> +		.config_intr	= tja11xx_config_intr,
> +		.ack_interrupt	= tja11xx_ack_interrupt,
>  		/* Statistics */
>  		.get_sset_count = tja11xx_get_sset_count,
>  		.get_strings	= tja11xx_get_strings,
> @@ -381,6 +426,9 @@ static struct phy_driver tja11xx_driver[] = {
>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
>  		.set_loopback   = genphy_loopback,
> +		/* IRQ related */
> +		.config_intr	= tja11xx_config_intr,
> +		.ack_interrupt	= tja11xx_ack_interrupt,
>  		/* Statistics */
>  		.get_sset_count = tja11xx_get_sset_count,
>  		.get_strings	= tja11xx_get_strings,
> 

