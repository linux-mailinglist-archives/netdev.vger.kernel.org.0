Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66AE3391781
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 14:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233869AbhEZMjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 08:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhEZMiv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 08:38:51 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8848FC061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:37:18 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id jt22so2185515ejb.7
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 05:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QiYfnkTPIW9j7k9MfXG+3MGtW/S0q+cZ/4l0IdLDbig=;
        b=S6FAB2iG1/lrNf/1jl+6OwyfT7Tb0Z7DHXWggl+S7/p9qVZ8SlRdDR3WBxptYZsB+G
         mltWPq0niceYQZKq/SZW8aqTiPPSqWzur2Dg8I4Y5iV9lHBxS2u2S7fULGtUlwYe/M9U
         CAOoCnqaEL1h3wZiYznb1ZFW1MlaLJWLFr+U3e5d/7u8nWefK6WciBChuGfFxfoqUNly
         gcOQDnmW+Sqn2siF8LFWOeBCGXUOBSPHPN3Kbi9eYVgVqEi0rMxDUi9SPdq79fDdR003
         tzvP6kgTq/8+IIgPJZxpiu7OblzJsI7kJVKaQRWx+dyw7YRX7KiNPJPKP/kWiSHS0WGF
         zF+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QiYfnkTPIW9j7k9MfXG+3MGtW/S0q+cZ/4l0IdLDbig=;
        b=ujalIXQOV6CMW6QFRgk0QLe7eQSryqckj6ukp3uGb53Jxgm8p8JaOKHf96d67q6IbV
         2DPDkishu3E+6HsnOocbKcMLyGYX1x7K9yVHKkd5Y5JB0ZQYaLvYHQ7UUF7xSZ1qoGEY
         hwngGFf9WYhtzOHZh0l7fpgs2kSxXxUH37kXAEMwaMwcyHKMIOqmQSvl89jZMG/25Q3p
         66+k3fvqECdVnk+JRRn3HZx0n3fwn243ptCK0hX3nt7coiDi4C6WCFBW/hv6W91dlqpO
         L5xVpF58Z91DrPePVKCPp2/3gxNRe3zy/q/n8tTLF4uan1BAOVFqKSJemqJRV6uv+6rG
         x73Q==
X-Gm-Message-State: AOAM533IOT3yiGyVDOgustaNxtNtRSM5Y9H0xGDKWCbSKOLam5WD/9yM
        bWIF2wH0rpQk7Q8d63ivwH8=
X-Google-Smtp-Source: ABdhPJw8rokKi5L7mHxrKwheEyjBAGjAR6iatWFdceeB5x6B7A1TDga2UBAeg+IulBKPoqsINxHNiA==
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr33880173ejc.1.1622032637127;
        Wed, 26 May 2021 05:37:17 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j17sm640527ejv.60.2021.05.26.05.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 05:37:16 -0700 (PDT)
Date:   Wed, 26 May 2021 15:37:15 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 05/13] net: dsa: sja1105: add a PHY interface
 type compatibility matrix
Message-ID: <20210526123715.dsfdsftwhqh6hhzk@skbuf>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-6-olteanv@gmail.com>
 <e1d8f74a-6cb7-75bc-551c-5214998a2521@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1d8f74a-6cb7-75bc-551c-5214998a2521@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 07:23:09PM -0700, Florian Fainelli wrote:
> 
> 
> On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > 
> > On the SJA1105, all ports support the parallel "xMII" protocols (MII,
> > RMII, RGMII) except for port 4 on SJA1105R/S which supports only SGMII.
> > This was relatively easy to model, by special-casing the SGMII port.
> > 
> > On the SJA1110, certain ports can be pinmuxed between SGMII and xMII, or
> > between SGMII and an internal 100base-TX PHY. This creates problems,
> > because the driver's assumption so far was that if a port supports
> > SGMII, it uses SGMII.
> > 
> > We allow the device tree to tell us how the port pinmuxing is done, and
> > check that against a PHY interface type compatibility matrix for
> > plausibility.
> > 
> > The other big change is that instead of doing SGMII configuration based
> > on what the port supports, we do it based on what is the configured
> > phy_mode of the port.
> > 
> > The 2500base-x support added in this patch is not complete.
> > 
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  drivers/net/dsa/sja1105/sja1105.h      |  5 +++
> >  drivers/net/dsa/sja1105/sja1105_main.c | 59 +++++++++++++-------------
> >  drivers/net/dsa/sja1105/sja1105_spi.c  | 20 +++++++++
> >  3 files changed, 55 insertions(+), 29 deletions(-)
> > 
> > diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
> > index d5c0217b1f65..a27841642693 100644
> > --- a/drivers/net/dsa/sja1105/sja1105.h
> > +++ b/drivers/net/dsa/sja1105/sja1105.h
> > @@ -111,6 +111,11 @@ struct sja1105_info {
> >  				enum packing_op op);
> >  	int (*clocking_setup)(struct sja1105_private *priv);
> >  	const char *name;
> > +	bool supports_mii[SJA1105_MAX_NUM_PORTS];
> > +	bool supports_rmii[SJA1105_MAX_NUM_PORTS];
> > +	bool supports_rgmii[SJA1105_MAX_NUM_PORTS];
> > +	bool supports_sgmii[SJA1105_MAX_NUM_PORTS];
> > +	bool supports_2500basex[SJA1105_MAX_NUM_PORTS];
> 
> If you used a bitmap you may be able to play some nice tricks with
> ordering them in PHY_INTERFACE_MODE_* order and just increment a pointer
> to the bitmap.
> 
> Since it looks like all of the chips support MII, RMII, and RGMII on all
> ports, maybe you can specify only those that don't?
> 
> Still:
> 
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Because the SJA1110 doesn't have public documentation, I am making a bit
of a compromise for SJA1105 in order to be very clear about which SJA1110
port supports which PHY interface type. With pointers to the beginning
and end of a phy_interface_t array for each switch type and port number,
it wouldn't be quite as clear, in fact it might end up quite a bit
messy.
