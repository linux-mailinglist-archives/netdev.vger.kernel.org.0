Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0256B428110
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 14:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhJJMH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 08:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhJJMH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 08:07:28 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4A5EC061570;
        Sun, 10 Oct 2021 05:05:29 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g8so55800722edt.7;
        Sun, 10 Oct 2021 05:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ALmHORr5FGqfseOfoHJttbSFY3dNJl5eoZvrNXF8Ry8=;
        b=VXC2VHB7r4CbD+FUmvBSBdNbuVXrMvUncPuHEYv1QAE6ewWPA1toFn4IBEe4x8MmBq
         7hSUiQDmUvPlFMowmqKwPerIravJt1E841s89Bwb53bvdDkQACi9qbMCNuOu3XxYCtez
         JGlhSRgc6k+EuJs5ta/iU6fs/x3uFK43+SWHTDRuTwXxAH+z+YPvuvUsg6fXycL6gCX9
         ACyztuL6igU9kN/CLLIG19awAKS9ozWoMmvQWmgPGWnTo+rWH2ebei31SKilZl+4EEfe
         3NcQ2eNBbr9jgtOj2dWoGuHlcq7zOnZw37u+W97d4HEldBsBvFd2Ie4QG9WF3bIXfl9E
         pZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ALmHORr5FGqfseOfoHJttbSFY3dNJl5eoZvrNXF8Ry8=;
        b=lXtXSUL8pzBdb6GU4btNh4BX4dksqa9x0aXKCDfypafCL1OiyC82K07i+YC7hQiDLC
         UUVjisGrH2KL7NYMRyW5dF3r84MSwfAsa97zi/rnWKyanf1oUvXwAm+qgYX7Tv7mZ8sm
         w0OVpmtGW8bX2Aw638F43NW3faut5OedmgVCT7tKoa5rxW/M/0sjv5QDLho7jjQTUKyP
         H/N5IBbqHqexI0Te6yzLzfCNg2pnpu1bk9vNmVQGUJhtrKZOWaiqaPuLzps2JMdyRnBQ
         /2VTFE75aOD3xt61xkzdVopXCg5tcbCVlH9r7odXZGdexFRQwaUdfxVRqJEwQghoPUg6
         hWOw==
X-Gm-Message-State: AOAM532z3JJXIb91Sps4T9qfKs58KIb3r1CEX0L5vvIIqc47lRVdWTyl
        5mJYualOq3IKWI+ePiCPL/0=
X-Google-Smtp-Source: ABdhPJz2uEFIqrusD4Nssty3Pr+/r8bBsXE/TXEyc56V7WWfIWg9903McXaKg3F1iUOPf06p8OIgOA==
X-Received: by 2002:a05:6402:1e8c:: with SMTP id f12mr17391541edf.71.1633867528414;
        Sun, 10 Oct 2021 05:05:28 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id rv25sm2042530ejb.21.2021.10.10.05.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 05:05:27 -0700 (PDT)
Date:   Sun, 10 Oct 2021 15:05:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v4 02/13] net: dsa: qca8k: add support for sgmii
 falling edge
Message-ID: <20211010120526.xzd7m3ug4plvwcjw@skbuf>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
 <20211010111556.30447-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211010111556.30447-3-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 10, 2021 at 01:15:45PM +0200, Ansuel Smith wrote:
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
>  drivers/net/dsa/qca8k.c | 25 +++++++++++++++++++++++++
>  drivers/net/dsa/qca8k.h |  3 +++
>  2 files changed, 28 insertions(+)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a892b897cd0d..3e4a12d6d61c 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -1172,6 +1172,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  			 const struct phylink_link_state *state)
>  {
>  	struct qca8k_priv *priv = ds->priv;
> +	struct dsa_port *dp;
>  	u32 reg, val;
>  	int ret;
>  
> @@ -1240,6 +1241,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		break;
>  	case PHY_INTERFACE_MODE_SGMII:
>  	case PHY_INTERFACE_MODE_1000BASEX:
> +		dp = dsa_to_port(ds, port);
> +
>  		/* Enable SGMII on the port */
>  		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
>  
> @@ -1274,6 +1277,28 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		}
>  
>  		qca8k_write(priv, QCA8K_REG_SGMII_CTRL, val);
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
> +		if (of_property_read_bool(dp->dn, "qca,sgmii-rxclk-falling-edge"))

I would strongly recommend that you stop accessing dp->dn and add your
own device tree parsing function during probe time. It is also a runtime
invariant, there is no reason to read the device tree during each mac_config.

> +			val |= QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE;
> +
> +		if (of_property_read_bool(dp->dn, "qca,sgmii-txclk-falling-edge"))
> +			val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
> +
> +		if (val)
> +			ret = qca8k_rmw(priv, reg,
> +					QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
> +					QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
> +					val);
>  		break;
>  	default:
>  		dev_err(ds->dev, "xMII mode %s not supported for port %d\n",
> diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
> index fc7db94cc0c9..3fded69a6839 100644
> --- a/drivers/net/dsa/qca8k.h
> +++ b/drivers/net/dsa/qca8k.h
> @@ -35,6 +35,9 @@
>  #define   QCA8K_MASK_CTRL_DEVICE_ID_MASK		GENMASK(15, 8)
>  #define   QCA8K_MASK_CTRL_DEVICE_ID(x)			((x) >> 8)
>  #define QCA8K_REG_PORT0_PAD_CTRL			0x004
> +#define   QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG		BIT(31)

QCA8K_PORT0_PAD_CTRL_MAC06_EXCHG is not used in this patch.

> +#define   QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE	BIT(19)
> +#define   QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE	BIT(18)
>  #define QCA8K_REG_PORT5_PAD_CTRL			0x008
>  #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
>  #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
> -- 
> 2.32.0
> 

