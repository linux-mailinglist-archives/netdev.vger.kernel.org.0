Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBE13ADF27
	for <lists+netdev@lfdr.de>; Sun, 20 Jun 2021 17:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhFTPJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Jun 2021 11:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhFTPJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Jun 2021 11:09:12 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23BA9C061574;
        Sun, 20 Jun 2021 08:06:58 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id g20so24374191ejt.0;
        Sun, 20 Jun 2021 08:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P2AK+78NOmAotKycIJqTLWlqFD+iRxStrWhoKZNh9bY=;
        b=KeVgAeKq3q1+NgGkb/Za1+JWcdVPPRDZN2FtTSDe5ELF6z1RybxbtZ+/a+6ilJe4Nt
         X1+kDnfj7TkfXBXZgmKAUkeTHKL5/UF6azuchUQKnDp++1BYOarRlrMOYInvqtL36lVX
         OEIZ344FPWdiq2KAaqmFZbSd/B81axIKNU94ENyQG7xJQQn1v9BbTNprUpKDZlUZAwoI
         LZfjSkkUZNuywmV4tx5OLxXb0d+0cO5ONDPoEPuc/EvUeFKUy8BPBhUbaBnnw+cWvlvg
         rfPkjOfxZoSMdhQF5KPOzp31DczJ159VECSOq2buOQJK+rsp4b4p8ZEEVAlZgqhFPApD
         y9UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P2AK+78NOmAotKycIJqTLWlqFD+iRxStrWhoKZNh9bY=;
        b=DhVw11P6Zdz1ANRFelIsDtLIppa7YSWKhMQkXHyN7ErN6jS+NoLq7WI2wj0deFCioJ
         K4z+fmV0aYVafF8dsyP+D3rko47NNCa6S2nD1hP0e0XeTAzgIMKTGlT80MuONqte+y/j
         XdMgXq39UQdnBFmq4qfCU6JwSNy9ACimeeY9SXWRMyOUEpXfEhm6WDhDYEQLC+nRVXdj
         o0jjmtwWbSCnxPUrY+pnp/5Cfv8pSSWEQ+BFQoIciieQ1IMOuPARihzlriOJJDb/XXKJ
         BFlSrWRNhIr5F7RaX3c9EpvpbEHb8fAubV673jGK5yY2BaY1fJYpi4hwwrnSQO/0C/b7
         /OQg==
X-Gm-Message-State: AOAM5335crmBSEnmQtGeAr7nJi+6PmGDTvRwfMMd2yqUzjfSQogOdE8M
        4OXOENU6ZwZ36FD/W6R8ELNbf99oSrI=
X-Google-Smtp-Source: ABdhPJxp3uFNpsjVvAw4XpbdE1vTRryQ9LxxWksCBl4cma1MUSk+IzG7mBZPWMhUI/9pPNMObe2ruw==
X-Received: by 2002:a17:906:6b8a:: with SMTP id l10mr20092802ejr.125.1624201616468;
        Sun, 20 Jun 2021 08:06:56 -0700 (PDT)
Received: from [10.21.182.79] ([212.23.236.67])
        by smtp.gmail.com with ESMTPSA id de24sm3688869ejc.78.2021.06.20.08.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Jun 2021 08:06:56 -0700 (PDT)
Subject: Re: [PATCH] mlx4_core: Remove trailing semicolon in macros
To:     Huilong Deng <denghuilong@cdjrlc.com>, yishaih@nvidia.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210620143624.51150-1-denghuilong@cdjrlc.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <9bdb1fd3-8a48-a9aa-8775-7e07dac8d56c@gmail.com>
Date:   Sun, 20 Jun 2021 18:06:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210620143624.51150-1-denghuilong@cdjrlc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/20/2021 5:36 PM, Huilong Deng wrote:
> Macros should not use a trailing semicolon.
> 
> Signed-off-by: Huilong Deng <denghuilong@cdjrlc.com>
> ---
>   include/linux/mlx4/doorbell.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/mlx4/doorbell.h b/include/linux/mlx4/doorbell.h
> index f31bba270aa2..e3ecaa4f00fa 100644
> --- a/include/linux/mlx4/doorbell.h
> +++ b/include/linux/mlx4/doorbell.h
> @@ -66,7 +66,7 @@ static inline void mlx4_write64(__be32 val[2], void __iomem *dest,
>    * MMIO writes.
>    */
>   
> -#define MLX4_DECLARE_DOORBELL_LOCK(name) spinlock_t name;
> +#define MLX4_DECLARE_DOORBELL_LOCK(name) spinlock_t name
>   #define MLX4_INIT_DOORBELL_LOCK(ptr)     spin_lock_init(ptr)
>   #define MLX4_GET_DOORBELL_LOCK(ptr)      (ptr)
>   
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Thanks,
Tariq
