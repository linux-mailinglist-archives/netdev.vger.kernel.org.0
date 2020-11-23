Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF892C011C
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 09:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgKWIGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 03:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbgKWIGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 03:06:22 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CD0C0613CF
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 00:06:22 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 23so17601495wrc.8
        for <netdev@vger.kernel.org>; Mon, 23 Nov 2020 00:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LiZDj0VEfYDnRZrkr2AvCsRnUFcnmZIbArIXDWEMyz0=;
        b=sBsrNjnhj9CBNieFxz+g7+D+sw/8XQcN7AF3Q9gSwF1XlPakU4X+tQBZHgNaXWohzH
         r3uNc5+Vc5ODMQS3u8p09WCzViY48CJPTYX07gaAK+rykRELONH6kH/biOlK3Pmud1FR
         OLbBmXRvM8BBT3NXgw9PfnZM4z2XOTYUyiSgqnIgwuKKsKeNGuM1Se2hE7m7sfdm1LKZ
         QVcQv8kmwM9TA64wRi960CJ4MerYtjgbm3jORlr8RlI5FuJTQb6paBP/E54ILDXnT3hZ
         TwZ4Ie7/U3mF8An8a8CRKbiCKvbsc9zKBJg7mbnvhp+KHsECTufr55IWWy+fAG/qTgqm
         rkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LiZDj0VEfYDnRZrkr2AvCsRnUFcnmZIbArIXDWEMyz0=;
        b=KOG+FzaIqZ8dyyFu9zjPwhyIs31LgmN6trnN3RvyH1KVpjeiNCGi7s2LsbM06o/6e8
         zFpTMa/Md4/cVufdL/Z5v9e/8EmjLefAkSIOsm4LbC0YR/eePmmhGidFSX2XVPGHOHlG
         6bPqb8HNH/9Tp65hd+ar8KsRz0+bRUec5COxhq5849zSkaVojAOUJRXcj0FpIlgwO7X2
         uwxD1f6Umh8GYfvE0m2vr+vt9hrydPTpIbtfTrnQb/13ZN7KaWEbHtws/aEPOoS4AJXG
         qRfp+fY9EiKrZGoYteEcT6XLj5lvEAz2LCYiRB8p3riXjmUY/2xIZV0etCePAl4dtnaQ
         YCwA==
X-Gm-Message-State: AOAM530t3tFIEk1AGyvQ3i56vQfdfh+1dr2RjWJ+Ts7dI5DcWV79YTtG
        smpTD+1Yqt89WMjYCqQVNMiPPg==
X-Google-Smtp-Source: ABdhPJxRRhxvp0jGxBz6huGEPE2MKgHsGvqkmeVCvI1s/sUJpzddG22H2Dq2bXizASPvOP45UtSyqg==
X-Received: by 2002:adf:f607:: with SMTP id t7mr14825902wrp.169.1606118780393;
        Mon, 23 Nov 2020 00:06:20 -0800 (PST)
Received: from apalos.home (ppp-94-64-112-220.home.otenet.gr. [94.64.112.220])
        by smtp.gmail.com with ESMTPSA id u23sm15371805wmc.32.2020.11.23.00.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 00:06:19 -0800 (PST)
Date:   Mon, 23 Nov 2020 10:06:17 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, brouer@redhat.com
Subject: Re: [PATCH net-next] net: page_pool: Add page_pool_put_page_bulk()
 to page_pool.rst
Message-ID: <X7tteeAxhH9G0TwF@apalos.home>
References: <937ccc89a82302a06744bcb6d253f0e95651caa2.1605910519.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <937ccc89a82302a06744bcb6d253f0e95651caa2.1605910519.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 20, 2020 at 11:19:34PM +0100, Lorenzo Bianconi wrote:
> Introduce page_pool_put_page_bulk() entry into the API section of
> page_pool.rst
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  Documentation/networking/page_pool.rst | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
> index 43088ddf95e4..e848f5b995b8 100644
> --- a/Documentation/networking/page_pool.rst
> +++ b/Documentation/networking/page_pool.rst
> @@ -97,6 +97,14 @@ a page will cause no race conditions is enough.
>  
>  * page_pool_get_dma_dir(): Retrieve the stored DMA direction.
>  
> +* page_pool_put_page_bulk(): It tries to refill a bulk of count pages into the

Tries to refill a number of pages sounds better?

> +  ptr_ring cache holding ptr_ring producer lock. If the ptr_ring is full,
> +  page_pool_put_page_bulk() will release leftover pages to the page allocator.
> +  page_pool_put_page_bulk() is suitable to be run inside the driver NAPI tx
> +  completion loop for the XDP_REDIRECT use case.
> +  Please consider the caller must not use data area after running

s/consider/note/

> +  page_pool_put_page_bulk(), as this function overwrites it.
> +
>  Coding examples
>  ===============
>  
> -- 
> 2.28.0
> 


Other than that 
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
