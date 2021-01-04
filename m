Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C93BC2E9384
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 11:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbhADKnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 05:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbhADKnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 05:43:10 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835C1C061574
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 02:42:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id h16so26802834edt.7
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 02:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=swYiWLLSTUuXWBs2sSYS3F86y+5L9fo0OCnz4xL65Wc=;
        b=FiqRamNMLz4o10lOcdwIEjgiDu7u+B6zyCiJEu1Nq+4vPriEdI1wlVy/le4t5aD8SQ
         /6tFmtgYRe6LHKgzK/3HxZxvj+lGuVePBUi0+5qVUL2Bj55gKrGf5f7QlhtM6RJIrif2
         My+LDeCF0Z61y/4n7+o9/cyRZd15XYbkEfJvS0IVhZNh7lw1cv/EJOe9vmw9HAQwM6HN
         gz8y9TJpvFP8S++Fr18P9zGcWJmYGjigenItLAaOde5//rHUZvkThtsCYn2yCBBA8HN6
         e0hhGdi0Up0gCSstoyBSCZkm8S9vrhjgMn2PUU7KtRit+gKvzRXSIhNBXOHi+WRuUgR/
         uqXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=swYiWLLSTUuXWBs2sSYS3F86y+5L9fo0OCnz4xL65Wc=;
        b=J43c4+0vpbTg/6jYWETGpOJEqlBnmuSTP/VkwCUMfCFAOoESV/EgWrD7M1M9pIk+ua
         oBElc0L2O+xTuTUAbp1GEAsTHwIslowBUom31r3UW/J9z3coJJltwJWIiGjxSzTn0iDD
         q/OzgWFQme3VSI54tg7RetrukgPDuoOK+mb5wL5ZdBJ9fWHOAuxFxxOoL2MxHwfCNhbK
         8jwpnxuvnDSc7nYMy40uwMJdtNieiheVwRLSrO1u3nvvV8+1w2oHpxx3JD6q5QKJl/FI
         Vc2dzjSgKtAOifgW4Sb9W7ZVc1YjP9OhJLCqV1osBvUlth2rvpKtK7v6Jgmops30TB5K
         JpYg==
X-Gm-Message-State: AOAM530CDE5PyceWgv/DSFcjZhi4oXh/6Ji0XGBux88Y+HVzubbXR6lH
        1vOkzBIW9Lm1ryrefPrBzhU=
X-Google-Smtp-Source: ABdhPJykSBIkTtUPJPKCo0LkXl3mNlkqMaFAWYQroGY05Q9WoElZoL/JWYdPqNb/97WcTunQGTyNsw==
X-Received: by 2002:aa7:d154:: with SMTP id r20mr72676992edo.258.1609756949318;
        Mon, 04 Jan 2021 02:42:29 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id h12sm23283887eja.113.2021.01.04.02.42.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 02:42:28 -0800 (PST)
Date:   Mon, 4 Jan 2021 12:42:27 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net] docs: net: fix documentation on .ndo_get_stats
Message-ID: <20210104104227.oqx6xt76k5snmhs6@skbuf>
References: <20201231034524.1570729-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201231034524.1570729-1-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 07:45:24PM -0800, Jakub Kicinski wrote:
> Fix calling context.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  Documentation/networking/netdevices.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
> index 5a85fcc80c76..a80676f5477d 100644
> --- a/Documentation/networking/netdevices.rst
> +++ b/Documentation/networking/netdevices.rst
> @@ -64,8 +64,8 @@ struct net_device synchronization rules
>  	Context: process
>  
>  ndo_get_stats:
> -	Synchronization: dev_base_lock rwlock.
> -	Context: nominally process, but don't sleep inside an rwlock
> +	Synchronization: rtnl_lock() semaphore, or RCU.
> +	Context: atomic
>  
>  ndo_start_xmit:
>  	Synchronization: __netif_tx_lock spinlock.
> -- 
> 2.26.2
> 

And what happened to dev_base_lock? Did it suddenly go away?
