Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE5E31D2D6
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhBPWt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:49:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbhBPWt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 17:49:57 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B77C061574;
        Tue, 16 Feb 2021 14:49:17 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id v9so9837802edw.8;
        Tue, 16 Feb 2021 14:49:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BAnh4iUoX88zAls0LT8rHlfsg/ZfLJmdl8uNzpmodVQ=;
        b=ZZiU8vRwuF2NrEEHEn9FQR9SKRZ2MNLAuFTNHsrLgONF+BOJi0BzvNMzSU1VQsNwzp
         o8cG14GJkzWGfIqSbjS9tNMBDMMmIWBhxq83ANfWwH1N3U+7Z5UYmvvGl4OwqL3Hjjc+
         Uaq65eh55t0cNchGf6lPZuYKBJ7pJiG65ZTqIxH2xw623ih/cH0nQ3xjgRt253sURE9H
         fCi7oAaiHpC/cqnTOVVtxivL92ivX3WpeF7gPd56JDXuukPuzfYCeEUZ8nMkzM51Pik7
         hjzZQbShJQ4eOAn3012FqQtzctQUS8AHdrLGd3abviFMyPaVhtxhj6Pzesc2uI5X8fNA
         XTEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BAnh4iUoX88zAls0LT8rHlfsg/ZfLJmdl8uNzpmodVQ=;
        b=YurCu1/Aprp5x6PEHNYpihBNJvWe5pI3rhrzGQGgFonIpOz2igUzCaiJOx0sc4UyU7
         JtrTWipL+GcHQMSI0ufEOdBS9X5rfH+fT5HzYWknxOIPcZpsxoHxGvs/llm9mp5EACXX
         bHhr2fSEfT5V2z6uW8p4dF26YMwrGI8XRJsZxQzjgy7J8I1YwXQ5WWtLhQtPgYbd2dt0
         s4Aa2rJTUhUnDP4cTqaWEuC711FAlregVeYzNYe9EixckdyHmaP8781SbRC3bns82n/Y
         8cZZfrqVG2GvaOhV9T1oYEPi0Mh61F4pHkbGR+2bir/feMsv7/ZMPNjVAislJpPZ/5P9
         Hkow==
X-Gm-Message-State: AOAM533bXe/F4UcNS412VkLjAOMnAGMBCJdX164WcX7HwY65qHPEeR1q
        RPSZxSxcep2Vk5+CSul37DE=
X-Google-Smtp-Source: ABdhPJxmuC+UbX6bz7xx+6H8nLZGVMcJc462H781ogGe7fCZ6OxqM5YemjZVP6KJbRsKdvFTCfsUPw==
X-Received: by 2002:a05:6402:27cf:: with SMTP id c15mr23086646ede.179.1613515756058;
        Tue, 16 Feb 2021 14:49:16 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t19sm147117ejc.62.2021.02.16.14.49.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 14:49:15 -0800 (PST)
Date:   Wed, 17 Feb 2021 00:49:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:BROADCOM ETHERNET PHY DRIVERS" 
        <bcm-kernel-feedback-list@broadcom.com>
Subject: Re: [PATCH] tg3: Remove unused PHY_BRCM flags
Message-ID: <20210216224914.porzrvn34ipxg2qj@skbuf>
References: <20210216190837.2555691-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210216190837.2555691-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 16, 2021 at 11:08:37AM -0800, Florian Fainelli wrote:
> The tg3 driver tried to communicate towards the PHY driver whether it
> wanted RGMII in-band signaling enabled or disabled however there is
> nothing that looks at those flags in drivers/net/phy/broadcom.c so this
> does do not anything.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

FWIW:

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
