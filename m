Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C00D3E13D2
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241021AbhHEL0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbhHEL0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 07:26:04 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5F2C061765;
        Thu,  5 Aug 2021 04:25:50 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id c25so8994553ejb.3;
        Thu, 05 Aug 2021 04:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wK3ZJoH77yoKanvAl+zgzlJtnSE4+vr1Ve33ojGjCOE=;
        b=H6rW1PuxyG7LRiK3aNO7vdFpTE0sBZHyCjyC5JbxVlo75rcg7cfqcTSCffshLp3o9c
         fgBa5OwAsgslrbgq9tObBRZ2HOZBybiWDj3dKNLTv8H7Vd0m1fRiOh0h8ziuEMVWg/s8
         qiGPNm82pDemRXXlP/xBg3IUiQEwHGCwB/180vogrrTOquDlPYit8ibx5Y+E2s846nEO
         V1UOLd8nIJQgOxdAzjT0s8+jcxobJxDu3gZlsizunLso2nDFuyO6vR5ZbQdm6Nil/YLA
         GZqyR4xhWvnAdLmsgpgiggoxLBbWFlsEAkF7JRXXrzWBH0SPyDyQNnD4z+MxZGk0SMh9
         40jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wK3ZJoH77yoKanvAl+zgzlJtnSE4+vr1Ve33ojGjCOE=;
        b=dccEWi0Gca/t6sj3uyq7RmmF66ynbgPQqOFT43IZBEL/FpX/6s9OCZT0+W76lxkwRR
         wFF11Tii3aCUERNxV6lpIAdXk7NKefth57m0uOELG2nfauPjAMoXjZjcdhe+K/ZPbNwC
         9pohxOhAT7DhyX3b2oplpqzHKs8N3lPAvhCrru7mHNaiJBGYP0F4t8Mct4LB3w7c/yP1
         eCj7aah2FPIqrcNe8T6sDkk2n2y8vkex5UwMCgmZqTA5D0iipICTYjoj84TqUE4k1f5w
         O8CE3btFyNpXg9ALWK0jCAuqyZT1GUVVOpCmbdvIOQ766NmkNJXJm9fqE0pwyjkITSGz
         Ql6Q==
X-Gm-Message-State: AOAM532798yKHcwWdH8TQAJQR1/e3jLIWR1okf/9xcWHFBzmwTTTPdfd
        hx+fWJatSiGKUqpnNCBE4oU=
X-Google-Smtp-Source: ABdhPJyjTU6ynYTsEPafAJj25937KUEfLcs5YClTtbWT5v+uoyXuh1mI+f0GFry2gYrpPG6F+i7ujA==
X-Received: by 2002:a17:906:3915:: with SMTP id f21mr4407704eje.178.1628162748494;
        Thu, 05 Aug 2021 04:25:48 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id mf11sm1627077ejb.27.2021.08.05.04.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 04:25:48 -0700 (PDT)
Date:   Thu, 5 Aug 2021 14:25:46 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Yangbo Lu <yangbo.lu@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] dsa: sja1105: fix reverse dependency
Message-ID: <20210805112546.gitosuu7bzogbzyf@skbuf>
References: <20210805110048.1696362-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805110048.1696362-1-arnd@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On Thu, Aug 05, 2021 at 01:00:28PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> The DSA driver and the tag driver for sja1105 are closely linked,
> and recently the dependency started becoming visible in the form
> of the sja1110_process_meta_tstamp() that gets exported by one
> and used by the other.
>
> This causes a rare build failure with CONFIG_NET_DSA_TAG_SJA1105=y
> and CONFIG_NET_DSA_SJA1105=m, as the 'select' statement only
> prevents the opposite configuration:
>
> aarch64-linux-ld: net/dsa/tag_sja1105.o: in function `sja1110_rcv':
> tag_sja1105.c:(.text.sja1110_rcv+0x164): undefined reference to `sja1110_process_meta_tstamp'
>
> Add a stricter dependency for the CONFIG_NET_DSA_TAG_SJA110y to
> prevent it from being built-in when the other one is not.
>
> Fixes: 566b18c8b752 ("net: dsa: sja1105: implement TX timestamping for SJA1110")
> Fixes: 227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through standalone ports")

The second Fixes: tag makes no sense.

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Not sure if there is a more logical way to deal with this,
> but the added dependency does help avoid the build failure.
>
> I found this one while verifying the PTP dependency patch, but
> it's really a separate issue.
> ---
>  net/dsa/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index bca1b5d66df2..548285539752 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -138,6 +138,7 @@ config NET_DSA_TAG_LAN9303
>
>  config NET_DSA_TAG_SJA1105
>  	tristate "Tag driver for NXP SJA1105 switches"
> +	depends on NET_DSA_SJA1105 || !NET_DSA_SJA1105

I think I would prefer an optional "build as module if NET_DSA_SJA1105 is a module"
dependency only if NET_DSA_SJA1105_PTP is enabled. I think this is how that is
expressed:

	depends on (NET_DSA_SJA1105 && NET_DSA_SJA1105_PTP) || !NET_DSA_SJA1105 || !NET_DSA_SJA1105_PTP

>  	select PACKING
>  	help
>  	  Say Y or M if you want to enable support for tagging frames with the
> --
> 2.29.2
>
