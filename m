Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5DC14284E2
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 03:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhJKBvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 21:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbhJKBvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 21:51:49 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E97C061570;
        Sun, 10 Oct 2021 18:49:50 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id bk7so6150422qkb.13;
        Sun, 10 Oct 2021 18:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=EE7Pw1o/NWSzz3GGzDT9jF9OY6seL1Uyk9vnbe/WKtk=;
        b=kJv6R7D37Ly/JhMeqT2q5sVlKzFpwWxg9mEJZNro9f79KjEXUT4XtqcFE2nIf4r1Vq
         ZN+4kLtr25uRzk5OgMI875z57BQXn8oM0j2iTkyy1n2Mc3wUNCR66xljLH6721lAnmLL
         cvESpdDE6BJHcMJ/XkYFdgIsvhDBIKkUy7d0qIIqbbe0YKtFxdfj6iTRKZWygSJiFRJJ
         U/wGqGdvhXNr+7L/xFXT2RJY9LyMWGAJ8nUIbvd71tek66u0dAj8cLvn1Vp04jkUfbq6
         10P74reImg/ycp/s3fWiTr+ujiC0Y+4/MLjAyxJH2+rExkKd9KzEvyEtaXWLop99mjLE
         9iGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EE7Pw1o/NWSzz3GGzDT9jF9OY6seL1Uyk9vnbe/WKtk=;
        b=lsk8peLAuMdfxjWifVedgd0u0TGgrZv25K7BvzwkhpyybpWWY/IB63hrFszj5FFfEM
         gyvZF0pkJh+8E7bjCqSifxlV5mhqBVq4Ksl3TBgKaH+7YyS1bPnU5NsngEBuIieYD1VL
         DFwqZKOywCMgzX/GcNQ5izvpzil1ioQXJdWB90hsoQRSim9wF2Dww5vhSWm4zV7yP3tx
         uM7g068riHPfPtdKlikgpS3PIFT2AnYRUg49Cx3jAF068aOTS/rfdTOUS0jgviLXRjK7
         /r2dDwDTwFRsU8yzipYz7oEkM88EQiAIf7eqaSpYAlZgFP7/7pC8/QQcU3wq2F8wRKzP
         mWvw==
X-Gm-Message-State: AOAM531JoXgViZpO8h/Ub3qh/r+Ft45+sZt3B0yiGk8BFmGohE+06K8D
        oJw70iHFPgZVO1+1xa/fL8s=
X-Google-Smtp-Source: ABdhPJzTmV38I4XymcLr1DTQoBsdeNlLGgWhMQj2OTFzhGEeZPp0IVslyJ/308QGGBfiYtVNV8LSsw==
X-Received: by 2002:a37:6c83:: with SMTP id h125mr12828684qkc.486.1633916989626;
        Sun, 10 Oct 2021 18:49:49 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:802c:b332:26e0:e0aa? ([2600:1700:dfe0:49f0:802c:b332:26e0:e0aa])
        by smtp.gmail.com with ESMTPSA id 139sm3592985qkj.44.2021.10.10.18.49.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 18:49:49 -0700 (PDT)
Message-ID: <d7242e22-9f7c-354a-aabc-3f62fb52533b@gmail.com>
Date:   Sun, 10 Oct 2021 18:49:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 03/14] net: dsa: qca8k: add support for sgmii
 falling edge
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Matthew Hagan <mnhagan88@gmail.com>
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-4-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> Add support for this in the qca8k driver. Also add support for SGMII
> rx/tx clock falling edge. This is only present for pad0, pad5 and
> pad6 have these bit reserved from Documentation. Add a comment that this
> is hardcoded to PAD0 as qca8327/28/34/37 have an unique sgmii line and
> setting falling in port0 applies to both configuration with sgmii used
> for port0 or port6.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 57 +++++++++++++++++++++++++++++++++++++++++
>   drivers/net/dsa/qca8k.h |  4 +++
>   2 files changed, 61 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a892b897cd0d..e335a4cfcb75 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -977,6 +977,36 @@ qca8k_setup_mac_pwr_sel(struct qca8k_priv *priv)
>   	return ret;
>   }
>   
> +static int
> +qca8k_parse_port_config(struct qca8k_priv *priv)
> +{
> +	struct device_node *port_dn;
> +	phy_interface_t mode;
> +	struct dsa_port *dp;
> +	int port;
> +
> +	/* We have 2 CPU port. Check them */
> +	for (port = 0; port < QCA8K_NUM_PORTS; port++) {
> +		/* Skip every other port */
> +		if (port != 0 && port != 6)
> +			continue;
> +
> +		dp = dsa_to_port(priv->ds, port);
> +		port_dn = dp->dn;

You should probably have an:

		if (!of_device_is_available(port_dn))
			continue

to skip over ports being disabled, which could presumably happen in a 
sparsely populated switch for instance.

> +
> +		of_get_phy_mode(port_dn, &mode);

This function returns an error that you are not checking.

> +		if (mode == PHY_INTERFACE_MODE_SGMII) {
> +			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
> +				priv->sgmii_tx_clk_falling_edge = true;
> +
> +			if (of_property_read_bool(port_dn, "qca,sgmii-rxclk-falling-edge"))
> +				priv->sgmii_rx_clk_falling_edge = true;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>   static int
>   qca8k_setup(struct dsa_switch *ds)
>   {
> @@ -990,6 +1020,11 @@ qca8k_setup(struct dsa_switch *ds)
>   		return -EINVAL;
>   	}
>   
> +	/* Parse CPU port config to be later used in phy_link mac_config */
> +	ret = qca8k_parse_port_config(priv);
> +	if (ret)
> +		return ret;
> +
>   	mutex_init(&priv->reg_mutex);
>   
>   	/* Start by setting up the register mapping */
> @@ -1274,6 +1309,28 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>   		}
>   
>   		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
> +
> +		/* For qca8327/qca8328/qca8334/qca8338 sgmii is unique and
> +		 * falling edge is set writing in the PORT0 PAD reg
> +		 */
> +		if (priv->switch_id == QCA8K_ID_QCA8327 ||
> +		    priv->switch_id == QCA8K_ID_QCA8337)
> +			reg = QCA8K_REG_PORT0_PAD_CTRL;
> +
> +		val = 0;
> +
> +		/* SGMII Clock phase configuration */
> +		if (priv->sgmii_rx_clk_falling_edge)
> +			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
> +
> +		if (priv->sgmii_tx_clk_falling_edge)
> +			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
> +
> +		if (val)
> +			ret = qca8k_rmw(priv, reg,
> +					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
> +					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
> +					val);
>   		break;
>   	default:
>   		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index fc7db94cc0c9..bc9c89dd7e71 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -35,6 +35,8 @@
>   #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
>   #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
>   #define QCA8K_REG_PORT0_PAD_CTRL			0x004
> +#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
> +#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
>   #define QCA8K_REG_PORT5_PAD_CTRL			0x008
>   #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
>   #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
> @@ -260,6 +262,8 @@ struct qca8k_priv {
>   	u8 switch_revision;
>   	u8 rgmii_tx_delay;
>   	u8 rgmii_rx_delay;
> +	bool sgmii_rx_clk_falling_edge;
> +	bool sgmii_tx_clk_falling_edge;
>   	bool legacy_phy_port_mapping;
>   	struct regmap *regmap;
>   	struct mii_bus *bus;
> 

-- 
Florian
