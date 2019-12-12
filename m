Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D48111C45E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 04:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbfLLDpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 22:45:54 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35658 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727181AbfLLDpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 22:45:53 -0500
Received: by mail-pf1-f194.google.com with SMTP id b19so25522pfo.2;
        Wed, 11 Dec 2019 19:45:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=07OMjO7lmkGh9f8g4geNEJnFp2GEjPLld3FY42QsWmc=;
        b=kVTWHYIL6XGFhib+bfcDZWj9aQTUa0qUNex7+FONF0PiBz/uh80+2A2951UAsQpB79
         YHq7ZHeWYfOI1dUGnwiwL7ZiUkNE765/TYymlYSwW5K/xKVEmVu9rfIQHWQbsZZDvO1R
         jkneKok0uYxJ3P79Pm4mpdN9aaaterhJKrjszPEr0cPuEZE8PEw57pDsqczlSHKwt9dL
         DpZ/ygKS1kC6pjdhFdqaWtFsu9C6ZULC12xNbOtM1b3Eld508H2zoWcFJkfab2zXQ0Uy
         uVDv4O1ShWzyKgzpUZt3YDlGXGe3P159yjdNiiM8UQCCwAQf0vh6NVIMNcjSOZ8+gmMR
         EHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=07OMjO7lmkGh9f8g4geNEJnFp2GEjPLld3FY42QsWmc=;
        b=OYS2SOjsQ7jFFqSCT3k9MM6sS/jMUfeK7KO+RiIF6Hhr1COYoT5VbqfSEh+ccUqbg7
         VbZgm7E1Tu2oswMhsogvkrcqnXh726VHvukS345Lp3Zg5hNGS1HVw6YWC28E9SrnfMP1
         AzOVP5r6jGXCz12ve2wFLk60/mdVgfst7iHcNT2qLSe6msFwpcab31Cde39zX3p7amib
         FcAlIuyycZdU9GKl4ap6NR4nwhactJff4vn+JDAY6VFj8NbofDADGxRvDnIBtfqC2oEC
         COrvDl1FkoVcK5a4QqRTm+ohyykwIy8HL8GR8nMTct8AVKN+DAc7lsXOgPCErCaETvxC
         40Hg==
X-Gm-Message-State: APjAAAXDemh0svZX6/jVck+2piaWw16c2Buo3gc/Ia8i1R7tIsxHaslS
        ZhnIWXkLzx788nltA7gr3SA=
X-Google-Smtp-Source: APXvYqznVMLWoXaG1KfzuljASoCWife9zOWrqBlls/IfY9KLjzX12fazK1jnaNL/zOx/Z0m9Z3PhjA==
X-Received: by 2002:a65:6249:: with SMTP id q9mr8479861pgv.340.1576122352840;
        Wed, 11 Dec 2019 19:45:52 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c18sm4441414pgj.24.2019.12.11.19.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 19:45:52 -0800 (PST)
Subject: Re: [PATCH net-next 2/6] net: dsa: mt7530: Extend device data ready
 for adding a new hardware
To:     Landen Chao <landen.chao@mediatek.com>, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, matthias.bgg@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        davem@davemloft.net, sean.wang@mediatek.com, opensource@vdorst.com,
        frank-w@public-files.de
References: <cover.1575914275.git.landen.chao@mediatek.com>
 <2d546d6bb15ff8b4b75af2220e20db4e634f4145.1575914275.git.landen.chao@mediatek.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <d77e3109-e022-3581-2ca8-02889c5ddbf4@gmail.com>
Date:   Wed, 11 Dec 2019 19:45:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2d546d6bb15ff8b4b75af2220e20db4e634f4145.1575914275.git.landen.chao@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/10/2019 12:14 AM, Landen Chao wrote:
> Add a structure holding required operations for each device such as device
> initialization, PHY port read or write, a checker whether PHY interface is
> supported on a certain port, MAC port setup for either bus pad or a
> specific PHY interface.
> 
> The patch is done for ready adding a new hardware MT7531.
> 
> Signed-off-by: Landen Chao <landen.chao@mediatek.com>
> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> ---
[snip]

> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index ed1ec10ec62b..9a648d1f5d09 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -425,7 +425,7 @@ mt7530_fdb_write(struct mt7530_priv *priv, u16 vid,
>  }
>  
>  static int
> -mt7530_pad_clk_setup(struct dsa_switch *ds, int mode)
> +mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t mode)

Here you pass a phy_interface_t argument but not in mt7632_pad_clk_setup().

> +static int
> +mt7530_pad_setup(struct dsa_switch *ds, const struct phylink_link_state *state)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +
> +	/* Setup TX circuit incluing relevant PAD and driving */
> +	mt7530_pad_clk_setup(ds, state->interface);
> +
> +	if (priv->id == ID_MT7530) {
> +		/* Setup RX circuit, relevant PAD and driving on the
> +		 * host which must be placed after the setup on the
> +		 * device side is all finished.
> +		 */
> +		mt7623_pad_clk_setup(ds);

Would not it make sense to pass it down here as well for consistency?

[snip]

> @@ -1660,8 +1768,19 @@ mt7530_probe(struct mdio_device *mdiodev)
>  	/* Get the hardware identifier from the devicetree node.
>  	 * We will need it for some of the clock and regulator setup.
>  	 */
> -	priv->id = (unsigned int)(unsigned long)
> -		of_device_get_match_data(&mdiodev->dev);
> +	priv->info = of_device_get_match_data(&mdiodev->dev);
> +	if (!priv->info)
> +		return -EINVAL;
> +
> +	/* Sanity check if these required device operstaions are filled
> +	 * properly.

Typo: operations.

Other than that, this looks okay to me.
-- 
Florian
