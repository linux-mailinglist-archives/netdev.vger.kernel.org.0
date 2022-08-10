Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FF258EA3D
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbiHJKIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiHJKIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:08:24 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C37C874361
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:08:23 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id w19so26808993ejc.7
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=TSMR+rFR5frkI0TIH8EEsrYeiqPV/Su4066hNfBa/nQ=;
        b=Iy57Mm0SEo7ntfQDLoFSWUMpaHDqEEwL+tlz1XWx/r3tvvvRFAU/4tM+VxU9Q6gSU/
         dwQIa+2juyrE4klpZqte17hs7X+BkQiJPHgAEKoxG4qiIqE4i+2RyPhpn3sPcEhrcS0q
         E41CKK0fgA+yBvQ/AryYcsi8asrtF5zduHmygSaysQJcs+yPcKPUOVgogNxmDZhHd7dz
         rOJgHT4wYFisb+7BGeA6D/G4UUYcrZjW7wkJoiWldOZMod9HKqfQj/nP1TptvbLHSTO4
         aFQhw+w9EsyDjP+QOQV48CvkyMM1XLZWXOVPrBfZ+oLzNFNGQLhe8p43Hc3uf9Pw/WD9
         bFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=TSMR+rFR5frkI0TIH8EEsrYeiqPV/Su4066hNfBa/nQ=;
        b=es7bLSnlDMszSb//3H8qTIqo3fgqnahx5eVVhF8USjadLpDdN4bo8kopS1Uo9hGmup
         4JfiuOSDXd9A+xXm63/JCSSIvaov+e6tEAAxjA3HOihawnB2Cm6Jl+mRk4v3VFvMB5a7
         ahGDSyRWBI9TEJK1sD+LQCufWgs0nyiBZILAt2EOF/2Y89R29o6TRyMX0xIjH9o8RTOG
         RWgrH1308aLxl632aNiHYbigPf0u67e3pTfZAz9crOwhWNFFyIULc9p1uKcsjQZTGnJd
         x+ZmhWH4UjW+Ava5ecCQIOARuayF1kRPRqJq44VvecA1tKfP4udadOsLfXFOGn3nlFcf
         JPZQ==
X-Gm-Message-State: ACgBeo1got6iRnhrvAmrQY2gWIXU9JjrJr7s9fBPMwW0V7ugCuy9zggc
        rFTWmuO1m26kTjn4tNFL0nY=
X-Google-Smtp-Source: AA6agR4cPdrpboCbkx5gACvqPGjGeGmd7f3O02hAvz/qylb4UuGjXdtGCdKxeo24g4MwpbBN2JXzwQ==
X-Received: by 2002:a17:907:2cd1:b0:730:65c9:4c18 with SMTP id hg17-20020a1709072cd100b0073065c94c18mr19807770ejc.324.1660126102217;
        Wed, 10 Aug 2022 03:08:22 -0700 (PDT)
Received: from skbuf ([188.27.185.133])
        by smtp.gmail.com with ESMTPSA id cn15-20020a0564020caf00b0043ba0cf5dbasm7350488edb.2.2022.08.10.03.08.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Aug 2022 03:08:20 -0700 (PDT)
Date:   Wed, 10 Aug 2022 13:08:18 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH] net: dsa: mv88e6060: report max mtu 1536
Message-ID: <20220810100818.greurtz6csgnfggv@skbuf>
References: <20220810082745.1466895-1-saproj@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220810082745.1466895-1-saproj@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergei,

On Wed, Aug 10, 2022 at 11:27:45AM +0300, Sergei Antonov wrote:
> This driver sets the MaxFrameSize bit to 1 during setup,
> see GLOBAL_CONTROL_MAX_FRAME_1536 in mv88e6060_setup_global().
> Thus MTU is always 1536.
> Introduce mv88e6060_port_max_mtu() to report it back to system.
> 
> Signed-off-by: Sergei Antonov <saproj@gmail.com>
> CC: Vladimir Oltean <olteanv@gmail.com>
> CC: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  drivers/net/dsa/mv88e6060.c | 7 ++++++-
>  drivers/net/dsa/mv88e6060.h | 1 +
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6060.c b/drivers/net/dsa/mv88e6060.c
> index a4c6eb9a52d0..c53734379b96 100644
> --- a/drivers/net/dsa/mv88e6060.c
> +++ b/drivers/net/dsa/mv88e6060.c
> @@ -160,7 +160,6 @@ static int mv88e6060_setup_addr(struct mv88e6060_priv *priv)
>  	u16 val;
>  
>  	eth_random_addr(addr);
> -

Extraneous change.

>  	val = addr[0] << 8 | addr[1];
>  
>  	/* The multicast bit is always transmitted as a zero, so the switch uses
> @@ -212,6 +211,11 @@ static int mv88e6060_setup(struct dsa_switch *ds)
>  	return 0;
>  }
>  
> +static int mv88e6060_port_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	return MV88E6060_MAX_MTU;
> +}

Does this solve any problem? It's ok for the hardware MTU to be higher
than advertised. The problem is when the hardware doesn't accept what
the stack thinks it should.

> +
>  static int mv88e6060_port_to_phy_addr(int port)
>  {
>  	if (port >= 0 && port < MV88E6060_PORTS)
> @@ -247,6 +251,7 @@ mv88e6060_phy_write(struct dsa_switch *ds, int port, int regnum, u16 val)
>  static const struct dsa_switch_ops mv88e6060_switch_ops = {
>  	.get_tag_protocol = mv88e6060_get_tag_protocol,
>  	.setup		= mv88e6060_setup,
> +	.port_max_mtu	= mv88e6060_port_max_mtu,
>  	.phy_read	= mv88e6060_phy_read,
>  	.phy_write	= mv88e6060_phy_write,
>  };
> diff --git a/drivers/net/dsa/mv88e6060.h b/drivers/net/dsa/mv88e6060.h
> index 6c13c2421b64..382fe462fb2d 100644
> --- a/drivers/net/dsa/mv88e6060.h
> +++ b/drivers/net/dsa/mv88e6060.h
> @@ -11,6 +11,7 @@
>  #define __MV88E6060_H
>  
>  #define MV88E6060_PORTS	6
> +#define MV88E6060_MAX_MTU	1536
>  
>  #define REG_PORT(p)		(0x8 + (p))
>  #define PORT_STATUS		0x00
> -- 
> 2.32.0
> 

You're the first person to submit a patch on mv88e6060 that I see.
Is there a board with this switch available somewhere? Does the driver
still work?
