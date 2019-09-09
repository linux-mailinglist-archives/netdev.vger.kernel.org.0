Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 787E2ADB1B
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfIIOXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Sep 2019 10:23:21 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:40793 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfIIOXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Sep 2019 10:23:21 -0400
Received: by mail-ot1-f68.google.com with SMTP id y39so12600776ota.7;
        Mon, 09 Sep 2019 07:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+qo6Cm0/mkvZdIkb/nI3qcoj0gdXAoPIp7Ut68/H0cU=;
        b=RLM/Vg7pPP9Gs9ptF29WwngIfmrkDT5VfEUazZEBkCxuCsOn7b3wioQB60jcrqUEbW
         6fw2m3n/87XYYfI4vthmzUUGA5tlat0RkdOErvas1keaMYyyALE+tZRB8b+Yu+1jBpi/
         6T8fmVmuW+qoyfPVcQ86C932cqryRshSmRg/96kgfzMAgC3e5C2jNWSftJSjq7Z+2HBa
         h9aT+B+GbPQpfiRDhwJCqJBenC84oDRH49r02S6ILJ9VoLP3vdLsJ36GfoFh80ubLdLy
         JhU9zVK6B64gZ4wt90pWINwXY7Nx/7jcD8LQKzPe52CSNIx6A0TTx95mHnMe7Pj0xbK8
         bM7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+qo6Cm0/mkvZdIkb/nI3qcoj0gdXAoPIp7Ut68/H0cU=;
        b=ERD8yQ5uZgZ5ZV93PU3WMiJ9x7SIwh+cRjF7b1Zx6KxqZ3TwQOmZ3h4GZfmeqFM0Xs
         YD8SFmpumtL5K5RkOlApl3w2JjcNnEQFhY6mVrcitx91v+UaZME5mgwN9itujkzprUs1
         IbgrnQHLP8Hqc6wnxIZCN8+o+yxZC5IEn4v/0Me6tRTxelUqdOUfHRWgm9HXptP24meG
         JK7Daw+JSBT+TPanvU+uBLEc1EsVJcd9H7QuOqrUDAQRl0GBYM+acqmyruk1oRcyycfC
         knCoMYthLzAL2DLO/HgIzj3f2XK9/RSFj0cm4XAHDwi1HBxIyru5SGFFVtiI+qiXBZFs
         YmMg==
X-Gm-Message-State: APjAAAVVINKd2LlEvlPof3q//eIMIocpb6IkSZqqAN2CZwj+VMuOgb3Y
        2MZyWB9Vu9a9EfXMuc23OfUV0G4cq2o=
X-Google-Smtp-Source: APXvYqws85LcAfZO0YokCPWxv1uj06YGGxYuW0goQpnopcM79gobnZvf2h6kemt8zWk+0H7K92VBDg==
X-Received: by 2002:a05:6830:91:: with SMTP id a17mr20257910oto.322.1568039000193;
        Mon, 09 Sep 2019 07:23:20 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s12sm1468806oij.56.2019.09.09.07.23.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 07:23:19 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] net: phy: dp83867: Add SGMII mode type switching
To:     Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>, davem@davemloft.net,
        robh+dt@kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Trent Piepho <tpiepho@impinj.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1567700761-14195-2-git-send-email-vitaly.gaiduk@cloudbear.ru>
 <1568026945-3857-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <51cf6e69-14ad-394e-0998-6032d239b717@gmail.com>
Date:   Mon, 9 Sep 2019 07:23:16 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1568026945-3857-1-git-send-email-vitaly.gaiduk@cloudbear.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2019 4:02 AM, Vitaly Gaiduk wrote:
> This patch adds ability to switch beetween two PHY SGMII modes.
> Some hardware, for example, FPGA IP designs may use 6-wire mode
> which enables differential SGMII clock to MAC.
> 
> Signed-off-by: Vitaly Gaiduk <vitaly.gaiduk@cloudbear.ru>
> ---
> Changes in v2:
> - changed variable sgmii_type name to sgmii_ref_clk_en
> 
>  drivers/net/phy/dp83867.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 1f1ecee..cd6260e 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -37,6 +37,7 @@
>  #define DP83867_STRAP_STS2	0x006f
>  #define DP83867_RGMIIDCTL	0x0086
>  #define DP83867_IO_MUX_CFG	0x0170
> +#define DP83867_SGMIICTL	0x00D3
>  #define DP83867_10M_SGMII_CFG   0x016F
>  #define DP83867_10M_SGMII_RATE_ADAPT_MASK BIT(7)
> 
> @@ -61,6 +62,9 @@
>  #define DP83867_RGMII_TX_CLK_DELAY_EN		BIT(1)
>  #define DP83867_RGMII_RX_CLK_DELAY_EN		BIT(0)
> 
> +/* SGMIICTL bits */
> +#define DP83867_SGMII_TYPE		BIT(14)
> +
>  /* STRAP_STS1 bits */
>  #define DP83867_STRAP_STS1_RESERVED		BIT(11)
> 
> @@ -109,6 +113,7 @@ struct dp83867_private {
>  	bool rxctrl_strap_quirk;
>  	bool set_clk_output;
>  	u32 clk_output_sel;
> +	bool sgmii_ref_clk_en;
>  };
> 
>  static int dp83867_ack_interrupt(struct phy_device *phydev)
> @@ -197,6 +202,9 @@ static int dp83867_of_init(struct phy_device *phydev)
>  	dp83867->rxctrl_strap_quirk = of_property_read_bool(of_node,
>  					"ti,dp83867-rxctrl-strap-quirk");
> 
> +	dp83867->sgmii_ref_clk_en = of_property_read_bool(of_node,
> +					"ti,sgmii-ref-clock-output-enable");
> +
>  	/* Existing behavior was to use default pin strapping delay in rgmii
>  	 * mode, but rgmii should have meant no delay.  Warn existing users.
>  	 */
> @@ -389,6 +397,14 @@ static int dp83867_config_init(struct phy_device *phydev)
> 
>  		if (ret)
>  			return ret;
> +
> +		/* SGMII type is set to 4-wire mode by default */
> +		if (dp83867->sgmii_ref_clk_en) {
> +			/* Switch on 6-wire mode */
> +			val = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL);
> +			val |= DP83867_SGMII_TYPE;
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
> +		}

Is there a case where the value could be retained across a power
on/reset cycle and you would want to make sure you do write the intended
"wire mode" here? What I am suggesting is just changing this into a:

	val =  phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL);
	if (dp83867->sgmii_ref_clk_en)
		val |= DP83867_SGMII_TYPE;
	else
		val &= ~DP83867_SGMII_TYPE;
	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_SGMIICTL, val);
	
Other than that, LGTM
-- 
Florian
