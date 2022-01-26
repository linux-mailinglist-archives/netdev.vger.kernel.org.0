Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EBE49D36A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 21:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiAZU3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 15:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiAZU3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 15:29:35 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636F5C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:29:35 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id d18-20020a9d51d2000000b005a09728a8c2so472255oth.3
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 12:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=s8MH1CpBBLft9SBwLCxMy6o1VOTvQDLlvmLOrtO0XIc=;
        b=Oa0IqRic5i/p3LmEi/D/7p7XngnkBTuLdeXdj/WqSMY9qgjA4TNT9FsxUoUH/EKo08
         DKEWQJwwAshX++lUreU5BG0rQMH5nCnV3Mq0bT63TlR32QVt1XYFjv9watHUt81Irg4G
         oSdyKj9kltJi1zgYYoIWl4xJCjj3t590kZ7Dbz/1x45ET0k4uubJV2dXvD1CSRd8pKNh
         UeHbII9JxOmXphpLOgxAoZe+CGqizkbS5U0wJJe2fLZrc8b3KgZqrcH16Cxb6ij/2W7U
         Qd9GU3aF+pK0oF/+bLmBUdznovW90nqdNbsugyhOYl7wuMM7Y9ShVG3f5fQNOnXa0/qN
         dBqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=s8MH1CpBBLft9SBwLCxMy6o1VOTvQDLlvmLOrtO0XIc=;
        b=lw6PwfDEtbvS/6vJE5pMebhZXNeVE22k8js9fYIpkA6K/Aao0ox7A1xYgXikaZshIV
         gn0keJ5GHSIRw9xpyY9FRu7eP94XkB9/Mr/yOepOHwopDEiMkT1UVO4KTC8XTYBiycQl
         ydoBycK/sqcBfPhcvUbnUW+nbP+DQTm0ofInYq9hJkz/YvMmlVK3GQL/yaiVWv/7/FH8
         mipOktOzSGFVbq34+B3dO7TqkCxOuVqUFLFpVLhmuRraLa5WYdTGT32tgLYL94hJ0bkN
         5HM0ICNViDsPJJgYRyzMJKoDye+Z5Nb3yoJ8+dHxvbSEIrbfezvYD2aKHa3rh9OkCjV/
         vd+A==
X-Gm-Message-State: AOAM530+epRkfRhJhjm8nSz1tNoAxjDMfAoAX0iY/W/Nk6aA+izp+G/u
        IQYzZ5kW/l0FECl0Vqjj72d4tEFYGPY=
X-Google-Smtp-Source: ABdhPJymIzTmTgtsGFcgP2K0M5DwUx2OnNT6LU1Sd7QFC0ytO6lIbVQMF00STfdXXRRuE4MCH6j8yQ==
X-Received: by 2002:a9d:4d96:: with SMTP id u22mr298837otk.223.1643228974638;
        Wed, 26 Jan 2022 12:29:34 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id v4sm4729001oou.1.2022.01.26.12.29.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 12:29:34 -0800 (PST)
Message-ID: <fc261023-5992-a0e3-ebaf-e11f096d224c@gmail.com>
Date:   Wed, 26 Jan 2022 13:29:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net] MAINTAINERS: add missing IPv4/IPv6 header paths
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
References: <20220126202607.2993009-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220126202607.2993009-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/22 1:26 PM, Jakub Kicinski wrote:
> IP includes under include/linux/ are not explicitly
> listed under any entry in MAINTAINERS.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  MAINTAINERS | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e22999669c4..9c3ec0863e7e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -13461,6 +13461,8 @@ L:	netdev@vger.kernel.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git
>  F:	arch/x86/net/*
> +F:	include/linux/ip.h
> +F:	include/linux/ipv6*

include/net/fib* and include/net/route.h should be added as well

>  F:	include/net/ip*
>  F:	net/ipv4/
>  F:	net/ipv6/

Reviewed-by: David Ahern <dsahern@kernel.org>
