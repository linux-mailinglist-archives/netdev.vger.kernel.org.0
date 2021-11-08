Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42C9447F8D
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 13:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239560AbhKHMmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 07:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbhKHMl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 07:41:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39505C061570;
        Mon,  8 Nov 2021 04:39:15 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so8709018pjb.1;
        Mon, 08 Nov 2021 04:39:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZvMKy4SWJp4IPc9m5IUkuhat+PpC/26LRNrxFB36C8o=;
        b=WGJ52rlWLdU7sZtVv1lYObyOfinR8XdYULcmiXco5L0umB27ry1PrlFgah7xGZxIP0
         4giDG6cxZxXfATTh4bz0az4h2qvmtCkMnPmiAV3gsNAnvOmMWQxcYcYKg4MaEKnfxDPW
         hilZQk9J03txyS8m0h5RAMiSDBwx+9zwwGaeympsJo5t1V3HfKgvWGbNIZHtea/J3QV8
         1LcdkLRmNQjDMP+5I61RtLuTCnu0Ja3p2IhPk3eWaHNvZ45LsUG0ypTLJpOJDQcqqM2H
         LyuUIM97HvtpSrw7WidYe8ufzmPNEfELFv1SBNh+OA2oBEvuyIxbbSz0VUCd8Jt2KI+5
         /7fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZvMKy4SWJp4IPc9m5IUkuhat+PpC/26LRNrxFB36C8o=;
        b=dhvdB93sf4Fb7FlJo5/B82HQBy3fwXRCXD5Fmd2eUEi1wEbiY4Q+iYTyqc+452rLbl
         7fn3lB4gSccgGrFr7MV36PcXlTUiu1G9405Zox+ooEERhrWwp08toHJ8yWxWQx/7NjYm
         Gyn1vOEnm2G2RzCNL4rX8rVRkMgR6jb+ZdHyBdy7kI7Uf3joEjPVB9Foiz2MVOb6SjgA
         8XSB2Hw6g/LoFsJEB/UsVpeMtNnAcpyfnFdb3bPBnX/GA42/tjkc5Uo8YkLlgVUL1IRj
         JI1b9zHR7Wx8zLMhXF08jWM9hqcF4ggFeyhQlCOMcfJyVDZ2XZPGaIGy3Q7x49Avf/H5
         G/Qw==
X-Gm-Message-State: AOAM533RAyeunLPED3hShB3LPf6+Vz0NireXXJ6xmJjo7lJZpeQP3DTG
        sJZbNK7o/eTzVtYnIz9jeoTyg8jJcWI=
X-Google-Smtp-Source: ABdhPJykLRccLxowDLcaRMdWf3C8SwG16YnZcy2XQ+2fI261FGz3h2H3iGW9JAAh/iSfc7maWjIscQ==
X-Received: by 2002:a17:902:6b07:b0:142:852a:9e1f with SMTP id o7-20020a1709026b0700b00142852a9e1fmr4074158plk.29.1636375154429;
        Mon, 08 Nov 2021 04:39:14 -0800 (PST)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id g21sm2550908pfc.95.2021.11.08.04.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:39:13 -0800 (PST)
Subject: Re: [PATCH] amt: add IPV6 Kconfig dependency
To:     Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Loic Poulain <loic.poulain@linaro.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211108111322.3852690-1-arnd@kernel.org>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <9bcfd0b5-ceb3-f397-36c1-8365dcbb769c@gmail.com>
Date:   Mon, 8 Nov 2021 21:39:10 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211108111322.3852690-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arnd,

On 11/8/21 8:12 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> This driver cannot be built-in if IPV6 is a loadable module:
> 
> x86_64-linux-ld: drivers/net/amt.o: in function `amt_build_mld_gq':
> amt.c:(.text+0x2e7d): undefined reference to `ipv6_dev_get_saddr'
> 
> Add the idiomatic Kconfig dependency that all such modules
> have.
> 
> Fixes: b9022b53adad ("amt: add control plane of amt interface")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/net/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 034dbd487c33..10506a4b66ef 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -294,6 +294,7 @@ config GTP
>   config AMT
>   	tristate "Automatic Multicast Tunneling (AMT)"
>   	depends on INET && IP_MULTICAST
> +	depends on IPV6 || !IPV6
>   	select NET_UDP_TUNNEL
>   	help
>   	  This allows one to create AMT(Automatic Multicast Tunneling)
> 

Acked-by: Taehee Yoo <ap420073@gmail.com>
