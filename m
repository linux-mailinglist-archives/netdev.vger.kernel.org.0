Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C6B3251B1
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 15:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhBYOo3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 09:44:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhBYOoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 09:44:25 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85D5C061574;
        Thu, 25 Feb 2021 06:43:44 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id d13so2167709edp.4;
        Thu, 25 Feb 2021 06:43:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oJNxAD8vKbiovpaWu0yq7Msj0MCOYG3SFayJwlmkCAY=;
        b=i/fI002txvMHEqiGiMFHvLbXkNuz/gZnNBk+nJzibwood8tvOejJp7QJENnnSEqhUx
         OKw6+cCSD4xZFHO/GFKOAmsSjXPs0NSB4qDFcHkhZG4v37yAdVjC9qLWC8roxvPhO57y
         4vQ3J8IAj+ZPRN9FqrYR5idFU5pncAoR6q3Ro9Vj6gitgAEF3a1ZMWSAmSYURtAZc+Zg
         56valH2ipQlhOg7JNu2D7w2KC6vjMhwGtBluptmS47NsrsZeBp8oIKW+xYw0ASeH7PhA
         rgqBuxfu6Dmn//jEn8kFBGqqaaevjYVciWMdfXKoqhmmmbyL+Z/EHr1njLDLNcCap84M
         KfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oJNxAD8vKbiovpaWu0yq7Msj0MCOYG3SFayJwlmkCAY=;
        b=k+Qf2wsREOARMfSvzjqC9bcWTkIpAMBZJjLW1Li0CWnL7aWQhtwzkBzhiaASJq+1S2
         tPCVM/xlTzqspQeF8hUiTvo13sL5xbLflVK2d14a70rHXg1y43gJT61efwwZVBOK7ctj
         U4K4ZMJ/KXp32FBsG6XHTWaS8vjxJK3VO5BLPopUrj6XNdH1JOUYTKriJjGOkrYP0paU
         9S0GdrUh7auTeJxG0WEdwEg+d8XQ7+zgS8Fl2yVm8rA3XzMmk2VrVRbk+6tLqH9zFckq
         hreDUVSi1rBMqgFoyQxtwTPcCsIbNFKb8lGOZ8a78vayDGSdqGKvhs+j9CpuuRbudAKe
         ggrw==
X-Gm-Message-State: AOAM530aoSIhCdLbWefXsyudyek+NYqxYj3D/rT9OEbQp3X+nsg5Es7/
        D0J+bLMq9p2MqnVC7gcD728=
X-Google-Smtp-Source: ABdhPJwTs7ZW6xnGwyanc/x7j1NptPabSN7B0LwYYa/ohyQudBIY7/OnbBXSal5J08vsYkz5LsbH4w==
X-Received: by 2002:a50:fa89:: with SMTP id w9mr3213549edr.22.1614264223539;
        Thu, 25 Feb 2021 06:43:43 -0800 (PST)
Received: from skbuf ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id p16sm3473423edw.44.2021.02.25.06.43.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 06:43:43 -0800 (PST)
Date:   Thu, 25 Feb 2021 16:43:41 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: tag_ocelot_8021q: fix driver dependency
Message-ID: <20210225144341.xgm65mqxuijoxplv@skbuf>
References: <20210225143910.3964364-1-arnd@kernel.org>
 <20210225143910.3964364-2-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225143910.3964364-2-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 03:38:32PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> When the ocelot driver code is in a library, the dsa tag
> code cannot be built-in:
> 
> ld.lld: error: undefined symbol: ocelot_can_inject
> >>> referenced by tag_ocelot_8021q.c
> >>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a
> 
> ld.lld: error: undefined symbol: ocelot_port_inject_frame
> >>> referenced by tag_ocelot_8021q.c
> >>>               dsa/tag_ocelot_8021q.o:(ocelot_xmit) in archive net/built-in.a
> 
> Building the tag support only really makes sense for compile-testing
> when the driver is available, so add a Kconfig dependency that prevents
> the broken configuration while allowing COMPILE_TEST alternative when
> MSCC_OCELOT_SWITCH_LIB is disabled entirely.  This case is handled
> through the #ifdef check in include/soc/mscc/ocelot.h.
> 
> Fixes: 0a6f17c6ae21 ("net: dsa: tag_ocelot_8021q: add support for PTP timestamping")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/dsa/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 3589224c8da9..58b8fc82cd3c 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -118,6 +118,8 @@ config NET_DSA_TAG_OCELOT
>  
>  config NET_DSA_TAG_OCELOT_8021Q
>  	tristate "Tag driver for Ocelot family of switches, using VLAN"
> +	depends on MSCC_OCELOT_SWITCH_LIB || \
> +	          (MSCC_OCELOT_SWITCH_LIB=n && COMPILE_TEST)
>  	select NET_DSA_TAG_8021Q
>  	help
>  	  Say Y or M if you want to enable support for tagging frames with a
> -- 
> 2.29.2
> 

Why isn't this code in include/soc/mscc/ocelot.h enough?

#if IS_ENABLED(CONFIG_MSCC_OCELOT_SWITCH_LIB)

bool ocelot_can_inject(struct ocelot *ocelot, int grp);
void ocelot_port_inject_frame(struct ocelot *ocelot, int port, int grp,
			      u32 rew_op, struct sk_buff *skb);
int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp, struct sk_buff **skb);
void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp);

#else

static inline bool ocelot_can_inject(struct ocelot *ocelot, int grp)
{
	return false;
}

static inline void ocelot_port_inject_frame(struct ocelot *ocelot, int port,
					    int grp, u32 rew_op,
					    struct sk_buff *skb)
{
}

static inline int ocelot_xtr_poll_frame(struct ocelot *ocelot, int grp,
					struct sk_buff **skb)
{
	return -EIO;
}

static inline void ocelot_drain_cpu_queue(struct ocelot *ocelot, int grp)
{
}

#endif
