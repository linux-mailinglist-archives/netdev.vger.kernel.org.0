Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4428A2F67AA
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 18:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbhANR3J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 12:29:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbhANR3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 12:29:08 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE40AC061574;
        Thu, 14 Jan 2021 09:28:27 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id n7so4241056pgg.2;
        Thu, 14 Jan 2021 09:28:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BMktHM7b1p+M7fY80qnnb19R51pulHTf9Vw2tRVYpFE=;
        b=NNE+DeQt//ezW+MP8raFI67g+WF0h4WsjH3UXduy6yhgd/zP4ZljJoXM/aI/TXm4LC
         SxTAjP9T2lzvDAYNwTFu9ABoOSn5ct+LvZhcLBqKiPr2AXVnC5hUpnxqyx0tjaKXms+G
         UZWTDOYPmq5zn/kmL3vYdyow/9ChgDhcdIcLNt6Sy0QGP4No1340VFdd7u20AgIeUZOI
         YO16d/H6TF8hDjS+2Wjw1WYMbZXf8hYT8JfuRoFYZUYBcm46iEoRL4yCOEzEoAWkStQp
         KNur8vXEk6i3Cd64C8iMVUCoCuz72Cqf3wpRwBy/8YnSKZw4fv0Yhp1errgiynfKdJy2
         6+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=BMktHM7b1p+M7fY80qnnb19R51pulHTf9Vw2tRVYpFE=;
        b=uFaAMxgei8Vb6XkCzOxD20bILZXnZ5k+gUJyEIhTFU35o6BAZa5Afl4dzl8cd4wSr4
         tUvpR6A31KMMsU/0IKr94zfUrDtL+7Qdm7rrIn2jc08QotvQhV3/swHT4LGeNZVZtTE8
         WecckZwXm3EFJ2OtLRe4F+PCtx/6MsbXEjjZpIBc9KxHqr54us+W5JwZij827F+RyBMp
         MxvTzXChRcH09HD2FTV3YaQm60iem8yX5MAE4Q0j6lHznKGPMkdF75joxLROFW4cqNzk
         1zrlE7DAJM9JrTfOMJLpYGHp8Cf20t1R1wrw7i4q6BLThrzvJc11qXugUjLenvGH6kAb
         Kn8g==
X-Gm-Message-State: AOAM533zLrymJqJ0o1Ky7H/+j21Kg0m+TacYzXvm3Ja2CW40facnlX32
        dYaEaVU8kCumUwhpJr97BnfX2xUkiJY=
X-Google-Smtp-Source: ABdhPJwdiyXzeRGKhzJapFG/KKzamj09H8raxu5VPv+9ruLJUOM5q9FI39stcoOJk2vkrozN7XG9sg==
X-Received: by 2002:a63:1c12:: with SMTP id c18mr8589466pgc.356.1610645306870;
        Thu, 14 Jan 2021 09:28:26 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bk18sm2228660pjb.41.2021.01.14.09.28.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 09:28:26 -0800 (PST)
Subject: Re: [PATCH net-next v4 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
To:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20210113145922.92848-1-george.mccollister@gmail.com>
 <20210113145922.92848-3-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <13473e91-d017-9d8a-e130-037d46ff225c@gmail.com>
Date:   Thu, 14 Jan 2021 09:28:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210113145922.92848-3-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/21 6:59 AM, George McCollister wrote:
> Add a driver with initial support for the Arrow SpeedChips XRS7000
> series of gigabit Ethernet switch chips which are typically used in
> critical networking applications.
> 
> The switches have up to three RGMII ports and one RMII port.
> Management to the switches can be performed over i2c or mdio.
> 
> Support for advanced features such as PTP and
> HSR/PRP (IEC 62439-3 Clause 5 & 4) is not included in this patch and
> may be added at a later date.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> ---
[snip]

This looks ready to me, just a few nits and suggestions.


> +/* Add an inbound policy filter which matches the BPDU destination MAC
> + * and forwards to the CPU port. Leave the policy disabled, it will be
> + * enabled as needed.
> + */
> +static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
> +{
> +	struct xrs700x *priv = ds->priv;
> +	unsigned int val = 0;
> +	int i = 0;
> +	int ret;
> +
> +	/* Compare all 48 bits of the destination MAC address. */
> +	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_CFG(port, 0), 48 << 2);
> +	if (ret)
> +		return ret;
> +
> +	/* match BPDU destination 01:80:c2:00:00:00 */
> +	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_0(port, 0), 0x8001);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_1(port, 0), 0xc2);
> +	if (ret)
> +		return ret;
> +
> +	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_2(port, 0), 0x0);
> +	if (ret)
> +		return ret;

Not that this is likely to change, but you could write this as a for
loop and use eth_stp_addr from include/linux/etherdevice.h.

[snip]

> +static int xrs700x_port_setup(struct dsa_switch *ds, int port)
> +{
> +	bool cpu_port = dsa_is_cpu_port(ds, port);
> +	struct xrs700x *priv = ds->priv;
> +	unsigned int val = 0;
> +	int ret, i;
> +
> +	xrs700x_port_stp_state_set(ds, port, BR_STATE_DISABLED);

It looks like we should be standardizing at some point on having switch
drivers do just the global configuration in the ->setup() callback and
have the core call the ->port_disable() for each port except the CPU/DSA
ports, and finally let the actual port configuration bet done in
->port_enable(). What you have is fine for now and easy to change in the
future.

> +int xrs700x_switch_register(struct xrs700x *dev)
> +{
> +	int ret;
> +	int i;
> +
> +	ret = xrs700x_detect(dev);
> +	if (ret)
> +		return ret;
> +
> +	ret = xrs700x_setup_regmap_range(dev);
> +	if (ret)
> +		return ret;
> +
> +	dev->ports = devm_kzalloc(dev->dev,
> +				  sizeof(*dev->ports) * dev->ds->num_ports,
> +				  GFP_KERNEL);
> +	if (!dev->ports)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < dev->ds->num_ports; i++) {
> +		ret = xrs700x_alloc_port_mib(dev, i);
> +		if (ret)
> +			return ret;

Nothing frees up the successfully allocated p->mib_data[] in case of
errors so you would be leaking here.

[snip]

> +
> +	/* Main DSA driver may not be started yet. */
> +	if (ret)
> +		return ret;
> +
> +	i2c_set_clientdata(i2c, dev);

I would be tempted to move this before "publishing" the device, probably
does not harm though, likewise for the MDIO stub.

[snip]

> +/* Switch Configuration Registers - VLAN */
> +#define XRS_VLAN(v)			(XRS_SWITCH_VLAN_BASE + 0x2 * (v))
> +
> +#define MAX_VLAN			4095

Can you use VLAN_N_VID - 1 here from include/linux/if_vlan.h?
-- 
Florian
