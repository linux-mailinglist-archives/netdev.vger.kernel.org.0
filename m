Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E692F6E92
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 23:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730930AbhANWt3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 17:49:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730830AbhANWt1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 17:49:27 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1507C061757;
        Thu, 14 Jan 2021 14:48:46 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id jx16so10591074ejb.10;
        Thu, 14 Jan 2021 14:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=toFMUVOH/jV1LBcKhTp6gRVuMbo8QkXcyIcMwUs3z7g=;
        b=biHDuZokd5FB7TX/uj3Mv2N97Vxkd2DOb8kHfP+0kyInfxDnFBoI6ejk2AW6jS3HgT
         iw030ggzFvrjDjXNTGeV3OeKVRRbDTCX0fTXM9dUmGX4wYYwGroygToSIoGfHyfZ510Y
         PlQBO+bHS42Ez9UiIPKidUptnn+IbFDXR8qv9SXJIc3EIdbVTyXPZEr5LBo0GKHEYJgp
         eJ37RLml3bZNs8GxL0YXQPfynz8yCwVOTEZy8MlVerL2ZxoI1PldJSiBoonftMXQYyz9
         W4A+EwQdDDCBGiy9JrP9uW7yYEMcaJtxdFyIFolWs8HXyTEFTGo4g8+VMSaM7fwOJl6p
         iLhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=toFMUVOH/jV1LBcKhTp6gRVuMbo8QkXcyIcMwUs3z7g=;
        b=YJmDsOOXyF5kkdPPDws84qRwwRcucyi0opAcCt4/RRbNRQd5GS2qpYuStoeyJdnKvx
         KVQsRNqxKWqV/CorL572oVNO9gtCsexFrumJw0orhjtZJAgWz9xF24mVez9loqyIaUyG
         d//h53yINJdD6rOMgeNPVt01lcATwQYsZ/H3llYHqJDtxqwXNMnXgdcH8gzJTk3Cbp4X
         Wlj/WJmiZj3CRZhXoA5r5AdGBC+Q8qCs1mUCVSWOtXkIWseZTN47NImv+d9J/B4+n72E
         FS4kNiK6EpOSg1pXlJcIUzWAetL+eC66TlmFC5fUKuw+KKQqJlj4wVyzanNOdLjXRuon
         XUGQ==
X-Gm-Message-State: AOAM5311vUrpqDEvvzZ0toLsjWNYAYHcxmo9oUt9IRVJL1IV/7piBjXi
        afqpLnlzHXldJezG0+th3uMQjipW7aw=
X-Google-Smtp-Source: ABdhPJy00Hms5VacSazJ2V131qhzvg7QBaOMnQDr2laBVEUZ+LPAqILgwVuijuVdclXPWrr1QdEGtA==
X-Received: by 2002:a17:906:274f:: with SMTP id a15mr528471ejd.347.1610664525343;
        Thu, 14 Jan 2021 14:48:45 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z6sm766289ejx.17.2021.01.14.14.48.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jan 2021 14:48:44 -0800 (PST)
Date:   Fri, 15 Jan 2021 00:48:43 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20210114224843.374dmyzvtszat6m4@skbuf>
References: <20210114195734.55313-1-george.mccollister@gmail.com>
 <20210114195734.55313-3-george.mccollister@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210114195734.55313-3-george.mccollister@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:57:33PM -0600, George McCollister wrote:
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

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

This driver is good to go, just one small nitpick below, you can fix it
up afterwards if you want.

> +static void xrs700x_port_stp_state_set(struct dsa_switch *ds, int port,
> +				       u8 state)
> +{
> +	struct xrs700x *priv = ds->priv;
> +	unsigned int bpdus = 1;
> +	unsigned int val;
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +		bpdus = 0;
> +		fallthrough;
> +	case BR_STATE_BLOCKING:
> +	case BR_STATE_LISTENING:
> +		val = XRS_PORT_DISABLED;
> +		break;
> +	case BR_STATE_LEARNING:
> +		val = XRS_PORT_LEARNING;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		val = XRS_PORT_FORWARDING;
> +		break;
> +	default:
> +		dev_err(ds->dev, "invalid STP state: %d\n", state);
> +		return;
> +	}
> +
> +	regmap_fields_write(priv->ps_forward, port, val);
> +
> +	/* Enable/disable inbound policy added by xrs700x_port_add_bpdu_ipf()
> +	 * which allows BPDU forwarding to the CPU port when the front facing
> +	 * port is in disabled/learning state.
                      ~~~~~~~~
You probably mean blocking. When the port is in BR_STATE_DISABLED, you
set bpdus = 1, which makes sense.

> +	 */
> +	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 0), 1, bpdus);
> +
> +	dev_dbg_ratelimited(priv->dev, "%s - port: %d, state: %u, val: 0x%x\n",
> +			    __func__, port, state, val);
> +}
