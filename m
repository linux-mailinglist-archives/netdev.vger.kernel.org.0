Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324283535FF
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 02:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbhDDAQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 20:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236526AbhDDAQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 20:16:37 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65470C061756;
        Sat,  3 Apr 2021 17:16:33 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w18so9068408edc.0;
        Sat, 03 Apr 2021 17:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bJQfZ+jp3lmZERZleCI/rZnnFXR+IPfceGSCsU0Epfs=;
        b=fJlVXxZumThGxarMiYq1eaiv8XLTTWnu8kYf4vyOswzmitxgOOd4eRDMssWd3Pk1Y4
         IzpCm5nXGzlTecx/L1u8TGGFLcxxN3X6Rz2mnIHgmZYR0DcNKUOYO8yZjgnRInX3YZt4
         +h6U2W0fBnnXaabTv/sqYdbNn84S+Gj1jm6th51ZgCwSoRVOFousH71G92i0RmeKhNxX
         ZNlA8SSmzfEuDo1PKMRPGmgmS5Wb+wdu0ohBc5Rdr+7oUdjjwXh9D7d1dpOLjgg+pR/h
         zt7+LW9xf3NFhaOFlJQWy1IcKJFPf3kst364pAT3W5U7dRlYyNc1ps2d3I+whlTghrGE
         K7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bJQfZ+jp3lmZERZleCI/rZnnFXR+IPfceGSCsU0Epfs=;
        b=ijRYLhCpXahfRMDHoa4JKTP6biDIf0OtYQKobm/QGrmz1da0rGkVB45cScp1FpnvxO
         gHGnuuH+it7qZWNNlvpQKIO9DBp+k710rf6f/n3YbK98ZowV0o8glETE/o0B+WnesRo2
         K0On3pOBEPPnV1UTCuLKRBa+Iq9zxxkBmjOeghFCFXGUAGkfZ4orsCKLU3tNrL35LFrZ
         BjuxZDNo0IzpIlBINcYDmJDA9EknUvtvVNJcWVBnndWm0cnX4VAd5DzJ/OqYgx9Ptcid
         AymNjTuxm6o+y1chYn310Tn0J7HSzVVkz9rZf+UJIKeNWXqGEsn/27epreuhSyYvuxzD
         ElNw==
X-Gm-Message-State: AOAM531w7pjb1i3ASKx86UZAGc2AgczjJdKQbJIGD6HbDTUkMupSe4ti
        4ofJTvTiegplEElTqtURtP0=
X-Google-Smtp-Source: ABdhPJzwBMTJZpda1DoVd5YOw1aNW6Ax6kcpvHy+eX8gAk0D7r0ASA92yg9woXzVECRxg2BzoozbCw==
X-Received: by 2002:a05:6402:1853:: with SMTP id v19mr23198134edy.179.1617495391968;
        Sat, 03 Apr 2021 17:16:31 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id x18sm2392408ejb.45.2021.04.03.17.16.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 17:16:31 -0700 (PDT)
Date:   Sun, 4 Apr 2021 03:16:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH net-next v1 4/9] net: dsa: qca: ar9331: make proper
 initial port defaults
Message-ID: <20210404001630.paqmt4v63d5gewy5@skbuf>
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-5-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210403114848.30528-5-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 03, 2021 at 01:48:43PM +0200, Oleksij Rempel wrote:
> Make sure that all external port are actually isolated from each other,
> so no packets are leaked.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/qca/ar9331.c | 145 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 143 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
> index 9a5035b2f0ff..a3de3598fbf5 100644
> --- a/drivers/net/dsa/qca/ar9331.c
> +++ b/drivers/net/dsa/qca/ar9331.c
> @@ -60,10 +60,19 @@
>  
>  /* MIB registers */
>  #define AR9331_MIB_COUNTER(x)			(0x20000 + ((x) * 0x100))
>  
> @@ -229,6 +278,7 @@ struct ar9331_sw_priv {
>  	struct regmap *regmap;
>  	struct reset_control *sw_reset;
>  	struct ar9331_sw_port port[AR9331_SW_PORTS];
> +	int cpu_port;
>  };
>  
>  static struct ar9331_sw_priv *ar9331_sw_port_to_priv(struct ar9331_sw_port *port)
> @@ -371,12 +421,72 @@ static int ar9331_sw_mbus_init(struct ar9331_sw_priv *priv)
>  	return 0;
>  }
>  
> -static int ar9331_sw_setup(struct dsa_switch *ds)
> +static int ar9331_sw_setup_port(struct dsa_switch *ds, int port)
>  {
>  	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
>  	struct regmap *regmap = priv->regmap;
> +	u32 port_mask, port_ctrl, val;
>  	int ret;
>  
> +	/* Generate default port settings */
> +	port_ctrl = FIELD_PREP(AR9331_SW_PORT_CTRL_PORT_STATE,
> +			       AR9331_SW_PORT_CTRL_PORT_STATE_DISABLED);
> +
> +	if (dsa_is_cpu_port(ds, port)) {
> +		/*
> +		 * CPU port should be allowed to communicate with all user
> +		 * ports.
> +		 */
> +		//port_mask = dsa_user_ports(ds);

Code commented out should ideally not be part of a submitted patch.
And the networking comment style is:

		/* CPU port should be allowed to communicate with all user
		 * ports.
		 */

> +		port_mask = 0;
> +		/*
> +		 * Enable atheros header on CPU port. This will allow us
> +		 * communicate with each port separately
> +		 */
> +		port_ctrl |= AR9331_SW_PORT_CTRL_HEAD_EN;
> +		port_ctrl |= AR9331_SW_PORT_CTRL_LEARN_EN;
> +	} else if (dsa_is_user_port(ds, port)) {
> +		/*
> +		 * User ports should communicate only with the CPU port.
> +		 */
> +		port_mask = BIT(priv->cpu_port);

For all you care, the CPU port here is dsa_to_port(ds, port)->cpu_dp->index,
no need to go to those lengths in order to find it. DSA does not have a
fixed number for the CPU port but a CPU port pointer per port in order
to not close the door for the future support of multiple CPU ports.

> +		/* Enable unicast address learning by default */
> +		port_ctrl |= AR9331_SW_PORT_CTRL_LEARN_EN
> +		/* IGMP snooping seems to work correctly, let's use it */
> +			  | AR9331_SW_PORT_CTRL_IGMP_MLD_EN

I don't really like this ad-hoc enablement of IGMP/MLD snooping from the driver,
please add the pass-through in DSA for SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED
(dsa_slave_port_attr_set, dsa_port_switchdev_sync, dsa_port_switchdev_unsync
should all call a dsa_switch_ops :: port_snoop_igmp_mld function) and then
toggle this bit from there.

> +			  | AR9331_SW_PORT_CTRL_SINGLE_VLAN_EN;
> +	} else {
> +		/* Other ports do not need to communicate at all */
> +		port_mask = 0;
> +	}
> +
> +	val = FIELD_PREP(AR9331_SW_PORT_VLAN_8021Q_MODE,
> +			 AR9331_SW_8021Q_MODE_NONE) |
> +		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID_MEMBER, port_mask) |
> +		FIELD_PREP(AR9331_SW_PORT_VLAN_PORT_VID,
> +			   AR9331_SW_PORT_VLAN_PORT_VID_DEF);
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_VLAN(port), val);
> +	if (ret)
> +		goto error;
> +
> +	ret = regmap_write(regmap, AR9331_SW_REG_PORT_CTRL(port), port_ctrl);
> +	if (ret)
> +		goto error;
> +
> +	return 0;
> +error:
> +	dev_err_ratelimited(priv->dev, "%s: error: %i\n", __func__, ret);
> +
> +	return ret;
> +}
> +
> +static int ar9331_sw_setup(struct dsa_switch *ds)
> +{
> +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> +	struct regmap *regmap = priv->regmap;
> +	int ret, i;
> +
>  	ret = ar9331_sw_reset(priv);
>  	if (ret)
>  		return ret;
> @@ -390,7 +500,8 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
>  
>  	/* Do not drop broadcast frames */
>  	ret = regmap_write_bits(regmap, AR9331_SW_REG_FLOOD_MASK,
> -				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU,
> +				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU
> +				| AR9331_SW_FLOOD_MASK_MULTI_FLOOD_DP,
>  				AR9331_SW_FLOOD_MASK_BROAD_TO_CPU);
>  	if (ret)
>  		goto error;
> @@ -402,6 +513,36 @@ static int ar9331_sw_setup(struct dsa_switch *ds)
>  	if (ret)
>  		goto error;
>  
> +	/*
> +	 * Configure the ARL:
> +	 * AR9331_SW_AT_ARP_EN - why?
> +	 * AR9331_SW_AT_LEARN_CHANGE_EN - why?
> +	 */

Good question, why?

> +	ret = regmap_set_bits(regmap, AR9331_SW_REG_ADDR_TABLE_CTRL,
> +			      AR9331_SW_AT_ARP_EN |
> +			      AR9331_SW_AT_LEARN_CHANGE_EN);
> +	if (ret)
> +		goto error;
> +
> +	/* find the CPU port */
> +	priv->cpu_port = -1;
> +	for (i = 0; i < ds->num_ports; i++) {
> +		if (!dsa_is_cpu_port(ds, i))
> +			continue;
> +
> +		if (priv->cpu_port != -1)
> +			dev_err_ratelimited(priv->dev, "%s: more then one CPU port. Already set: %i, trying to add: %i\n",

than, not then

> +					    __func__, priv->cpu_port, i);
> +		else
> +			priv->cpu_port = i;
> +	}
> +
> +	for (i = 0; i < ds->num_ports; i++) {
> +		ret = ar9331_sw_setup_port(ds, i);
> +		if (ret)
> +			goto error;
> +	}
> +
>  	ds->configure_vlan_while_not_filtering = false;
>  
>  	return 0;
> -- 
> 2.29.2
> 
