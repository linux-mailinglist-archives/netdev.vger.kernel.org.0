Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF8BC38B905
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 23:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhETVfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 17:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhETVfg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 17:35:36 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39973C061574;
        Thu, 20 May 2021 14:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=G4UyUQ5PEzDYd7A8AKUFGfZluQiPU3b0/QLKsAyorwY=; b=B9ty5K/ZeyX2pHm5DUjb9yKjMf
        T3uVb1RNT4xQBLdu65tv5ouSyq/+rWgbxzlzbyHhKoUVYe1QXaawiDk9//xUypscicoZAd45fVsvH
        hpre64GbdgcPKfKJ9srgXiCQFPPgNdnhwxZJJJGg6gS3p056Vch1z05oIY/tZyZd3atoHww8iCRap
        7xwUeDVDWcvZ2egX7ifIhE6LS5YSviXBXDccOdkfz/Cfbxqs53lFB0904P0BnSxoRzU7JAEhMbmDS
        6LJPih9MtBSCi7HDFVQoD20/Hp2EIZD7Gs4MaIvIGPYKdE+2xvX3qchbrNoJdi5F9b97IuFgLt32P
        Hmfnsi8Q==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1ljqJ3-00Gfso-Nc; Thu, 20 May 2021 21:34:13 +0000
Subject: Re: [PATCH] net: encx24j600: fix kernel-doc syntax in file headers
To:     Aditya Srivastava <yashsri421@gmail.com>, davem@davemloft.net
Cc:     lukas.bulwahn@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210520184915.588-1-yashsri421@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <31c0fb7a-4913-c6bb-0de4-0e41b4bc4d31@infradead.org>
Date:   Thu, 20 May 2021 14:34:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520184915.588-1-yashsri421@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/21 11:49 AM, Aditya Srivastava wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> The header for drivers/net/ethernet/microchip/encx24j600 files follows
> this syntax, but the content inside does not comply with kernel-doc.
> 
> This line was probably not meant for kernel-doc parsing, but is parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warning from kernel-doc.
> For e.g., running scripts/kernel-doc -none
> drivers/net/ethernet/microchip/encx24j600_hw.h emits:
> warning: expecting prototype for h(). Prototype was for _ENCX24J600_HW_H() instead
> 
> Provide a simple fix by replacing such occurrences with general comment
> format, i.e. '/*', to prevent kernel-doc from parsing it.
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/net/ethernet/microchip/encx24j600.c    | 2 +-
>  drivers/net/ethernet/microchip/encx24j600_hw.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/encx24j600.c b/drivers/net/ethernet/microchip/encx24j600.c
> index 3658c4ae3c37..ee921a99e439 100644
> --- a/drivers/net/ethernet/microchip/encx24j600.c
> +++ b/drivers/net/ethernet/microchip/encx24j600.c
> @@ -1,5 +1,5 @@
>  // SPDX-License-Identifier: GPL-2.0-or-later
> -/**
> +/*
>   * Microchip ENCX24J600 ethernet driver
>   *
>   * Copyright (C) 2015 Gridpoint
> diff --git a/drivers/net/ethernet/microchip/encx24j600_hw.h b/drivers/net/ethernet/microchip/encx24j600_hw.h
> index f604a260ede7..fac61a8fbd02 100644
> --- a/drivers/net/ethernet/microchip/encx24j600_hw.h
> +++ b/drivers/net/ethernet/microchip/encx24j600_hw.h
> @@ -1,5 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
> -/**
> +/*
>   * encx24j600_hw.h: Register definitions
>   *
>   */
> 


-- 
~Randy

