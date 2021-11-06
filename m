Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180494470B9
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 22:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhKFVzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 17:55:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Nov 2021 17:55:16 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D0CC061570
        for <netdev@vger.kernel.org>; Sat,  6 Nov 2021 14:52:34 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u18so19612775wrg.5
        for <netdev@vger.kernel.org>; Sat, 06 Nov 2021 14:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=cpzkNayM9HufcRN2Q1h9fIKC9aOJE8WfPgyI8YiLXQ8=;
        b=nsyETzIruwmXw3a7KsGcNdy8kMHZKB1eFoCa0a/ISOoaGB6q4AaTpqsTF5BugDyCtK
         laEGmrE8DVEmhxhtPcK/WjilLeIvIn6mPjjtcVWmv8nqpkrcEhlTz1XrVmykBaevjcA0
         oo+VwZh9Fa+QMDyLsxnSQMJsIGwc8VoVqdtKkOkrQihL9G9qsxWH9KjVV4EYVSOOwek2
         aVtCxbclBb5ln7LLsD+xFsKniFLtd8ubYV6A/gZf+gPydq9NaVRHfeP+dOEEMN48y8+2
         ZOTRLHOC4/WCVuf9G4aTZwB/9gbcOTDkLHVb3pMuiB2ps+CJds1wp5ntSel3VBlEsKuz
         LpdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=cpzkNayM9HufcRN2Q1h9fIKC9aOJE8WfPgyI8YiLXQ8=;
        b=eJoy8u8jUbo5+79wPFD9hUxooD0IyIgrUTuximfQV2arQ3aLxmt86bQjuk7uGwNJ1E
         sDNvK/R1AoulwcZxMixiGvnOHqXhImB2Fw05/Cx9zR89Vc2tpPj2IWrHn8gaXeoJdJ9B
         km343qeJVHPWA3SjdxuI+Q2LAvXSdXKlVNg03Dv7YvSLpN057jabqYCNQAbWKR3Q8r16
         vVNz/mk2mrz2UmVkvsGu8KGz6FZ5m7HfIq/+Dag8R3f7YIZ4kQ/tR+g68Wpqn/CksDd8
         z/BcqLqDNlfUQtIL6xun9WTrhUVk/1bbeMQnM5P166gHtNrCS1rl2DdcQDxdl/Y3dYzj
         v8bQ==
X-Gm-Message-State: AOAM532Q+ScNAf4LVEyLcNX/1FisvpuPJ/1EQOjcutMgHN7Z4iqNfAZ/
        lDZjyyIhi3W+AOU4h6Ts/gk=
X-Google-Smtp-Source: ABdhPJx/De6OrHTgJUY9qk3pL0+AyC4D5o/uaHwRF//HhgXfszTtUQ+kRUcRlQ5ayyvR4tuySVvsPQ==
X-Received: by 2002:a05:6000:2a2:: with SMTP id l2mr51558263wry.110.1636235553274;
        Sat, 06 Nov 2021 14:52:33 -0700 (PDT)
Received: from ?IPV6:2003:ea:8f1a:f00:1d15:24f0:8ddc:e918? (p200300ea8f1a0f001d1524f08ddce918.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:1d15:24f0:8ddc:e918])
        by smtp.googlemail.com with ESMTPSA id f3sm14821495wmb.12.2021.11.06.14.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Nov 2021 14:52:32 -0700 (PDT)
Message-ID: <6e1844e5-cbee-5d50-e304-efa785405922@gmail.com>
Date:   Sat, 6 Nov 2021 22:52:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Content-Language: en-US
To:     bage@linutronix.de, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <linux@armlinux.org.uk>, davem@davemloft.net,
        netdev@vger.kernel.org,
        Benedikt Spranger <b.spranger@linutronix.de>
References: <20211105153648.8337-1-bage@linutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] phy: phy_ethtool_ksettings_set: Don't discard
 phy_start_aneg's return
In-Reply-To: <20211105153648.8337-1-bage@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.11.2021 16:36, bage@linutronix.de wrote:
> From: Bastian Germann <bage@linutronix.de>
> 
> Take the return of phy_start_aneg into account so that ethtool will handle
> negotiation errors and not silently accept invalid input.
> 
> Fixes: 2d55173e71b0 ("phy: add generic function to support ksetting support")
> Signed-off-by: Bastian Germann <bage@linutronix.de>
> Reviewed-by: Benedikt Spranger <b.spranger@linutronix.de>

In addition to what Andrew said already:

- This patch won't apply on net due to a4db9055fdb9.
- Patch misses the "net" annotation.
- Prefix should be "net: phy:", not "phy:".

At least the formal aspects should have been covered by the internal review.

> ---
>  drivers/net/phy/phy.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> index a3bfb156c83d..f740b533abba 100644
> --- a/drivers/net/phy/phy.c
> +++ b/drivers/net/phy/phy.c
> @@ -770,6 +770,8 @@ static int phy_poll_aneg_done(struct phy_device *phydev)
>  int phy_ethtool_ksettings_set(struct phy_device *phydev,
>  			      const struct ethtool_link_ksettings *cmd)
>  {
> +	int ret = 0;

Why initializing ret?

> +
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(advertising);
>  	u8 autoneg = cmd->base.autoneg;
>  	u8 duplex = cmd->base.duplex;
> @@ -815,10 +817,10 @@ int phy_ethtool_ksettings_set(struct phy_device *phydev,
>  	phydev->mdix_ctrl = cmd->base.eth_tp_mdix_ctrl;
>  
>  	/* Restart the PHY */
> -	_phy_start_aneg(phydev);
> +	ret = _phy_start_aneg(phydev);
>  
>  	mutex_unlock(&phydev->lock);
> -	return 0;
> +	return ret;
>  }
>  EXPORT_SYMBOL(phy_ethtool_ksettings_set);
>  
> 

