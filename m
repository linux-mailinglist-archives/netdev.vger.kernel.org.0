Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B01492DA961
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 09:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbgLOInb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 03:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLOIna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 03:43:30 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5686C06179C;
        Tue, 15 Dec 2020 00:42:43 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id w1so21802646ejf.11;
        Tue, 15 Dec 2020 00:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7lMzuVC4jC7DQROwvZOk8sE07D8BlYMl6XZRxWxmaSs=;
        b=TUdJ8xWbQM4fokPKJCWBEAuYYQ88flnKDUqzWqiKCUuJKXEj92gL7Td5F/+8sc796d
         fFqrL80DinVrmRMW1LtUmBjhQIUp4pZHBE6hHjOUZ5/KOFvFXb/EBAm2WXi0lqGxntDT
         9pOnPNW/jVxHrLTJ2N9bdAT99UCuA645nM793Pn2sX7JymT1S0vzyZ/6cFXFO5/jRsdM
         epfebP/XVGSDACXdq1TW4KedjAxx97fVC2FTG2vaSGqeUJ5Z7aSYCDYipXilx7SKL8mN
         Pmt6MM2u/4gwzp55Tmr2y1kqREDHWr143W7IlToeaJeFiOHsDyi7bjjZEUyLFpl3hyOk
         N8jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7lMzuVC4jC7DQROwvZOk8sE07D8BlYMl6XZRxWxmaSs=;
        b=dhK3Zf9YWsU7r/EpD+FmeB1yIfTMvTx6cJOCu53I1ZeL3aduWUBKFB5PPY3H8+hQgL
         on3yoYfShxEBiErNN+H1E5RDCNyHkahPeh9i8tvqOO7Sb4mSbH8rqKkvj7a97PBcrC5K
         qSNSACwN/7jAcHSOD7JPtSe5jwhpljAEZZuWGqCJowUlbzFQwaxtz9Y+d/gnpVrdDyq6
         +4tTjEKUH/R44cZeAnc00DJREQmekYR3A3MJTPXq8dtYeCWviPm2BQfCMbnIyMpE+94I
         PR2WvrHkAA8BcNj6yopTJN0Rir83cCuSoySZ6nSuyCXFnDneiGGUNqMCy6pyuPOYpFO+
         yJDw==
X-Gm-Message-State: AOAM5318+aVHFY67npeNvCi4og+Re7PvL93GKJPxSkGuVV/8xuob6K0I
        F+lvPI2lkzKKWW3nza7+ZAI=
X-Google-Smtp-Source: ABdhPJzvYuKuqbmY3bgEWbDZx81LjjE+/BHjCJ1iwtZsc06oyxrawT4pP9n5hRHfoUVWFRPfUtV23A==
X-Received: by 2002:a17:906:971a:: with SMTP id k26mr26542457ejx.279.1608021762592;
        Tue, 15 Dec 2020 00:42:42 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id w17sm17309852edu.90.2020.12.15.00.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 00:42:42 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Tue, 15 Dec 2020 10:42:40 +0200
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH] net: phy: fix kernel-doc for .config_intr()
Message-ID: <20201215084240.lgg7tcq5tgbufqfr@skbuf>
References: <20201215083751.628794-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201215083751.628794-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 15, 2020 at 10:37:51AM +0200, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Fix the kernel-doc for .config_intr() so that we do not trigger a
> warning like below.
> 
> include/linux/phy.h:869: warning: Function parameter or member 'config_intr' not described in 'phy_driver'
> 
> Fixes: 6527b938426f ("net: phy: remove the .did_interrupt() and .ack_interrupt() callback")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Sorry, I just realized that Jakub already sent a fix for this:

https://lore.kernel.org/netdev/20201215063750.3120976-1-kuba@kernel.org/

Ioana


> ---
>  include/linux/phy.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 381a95732b6a..9effb511acde 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -743,7 +743,8 @@ struct phy_driver {
>  	/** @read_status: Determines the negotiated speed and duplex */
>  	int (*read_status)(struct phy_device *phydev);
>  
> -	/** @config_intr: Enables or disables interrupts.
> +	/**
> +	 * @config_intr: Enables or disables interrupts.
>  	 * It should also clear any pending interrupts prior to enabling the
>  	 * IRQs and after disabling them.
>  	 */
> -- 
> 2.28.0
> 
