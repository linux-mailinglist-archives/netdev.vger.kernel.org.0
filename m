Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01E0B2AAA0C
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 09:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727440AbgKHIUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 03:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgKHIUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 03:20:36 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F24C0613CF;
        Sun,  8 Nov 2020 00:20:35 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id e18so5496830edy.6;
        Sun, 08 Nov 2020 00:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ifqNO6WT8GZNIez7I1EN9ZSl8l1s4Z8Z+CHlW50umKs=;
        b=Yr6Wvw/HBi6nAaqlb0rzVqBfNcfNQMor5KK3vmiynOkYfRg6nlUKlaL5IcUO1T2vXm
         6FM1aYWx6Gojir15CUJA3GEyjdZiovHBbkxMq1J+yYE2roNeUyGZMiWqwGIYVfyBC/tw
         gEqP2lW0A8Ij+dykErpDcCQXNQvKcRvXbaC0I7zTJKsHmIlV+/T5+6oQLwPhTNh3bkMt
         Lu+cQM5r1SIm0vTBQEk7KRO1iYMzlrQqESZZYjIZXJ432p0AzDnA+zdLa0u6Rcj02LJn
         GgQ5wTGk+HB7Ee02z+j8Htp8zR0Mka6rKRi+9ODODEgIJU+9h5SaXu8eyCQRbLqwuv4T
         C+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ifqNO6WT8GZNIez7I1EN9ZSl8l1s4Z8Z+CHlW50umKs=;
        b=Ta5aORNT44Vvf+HuE1r2kjSnqlhabqhN8ksLK5vI5Fat1Rl5SX0XVAPRuWMFMU4d6G
         lf0GjXBfYoqvnLI0/xMnptXBBWTvCtgrwwByZDMNlX5Jh6oNyOTzjY/PFN+8NtmulFhg
         FIM3AF07XR5LE8YI9tPcmzYbhMtOcKlCd0KPCXYj57wVpUb5+a/sOYtQTY3ifEI9EkK4
         egBR0fhafup1ysN29SirPgI2XJ4IrY2DPJJdoIB4vWbFgj4uE/+8l+tE2dDks0gpBz+z
         7l4Yjdp6+Bm+euTFaWSCQTLOirKutzM2Vqd5cTCs36fZK07y90mU80IwfuTx5J++IyCK
         7VVA==
X-Gm-Message-State: AOAM531ePeh8BLc/KzLYS3Cs19D4ZYeJoGqB3Vm7Fafp+ng2C3BY64cw
        6JyNMLBH2pfF6EMHT4oSc+0GDmHu708=
X-Google-Smtp-Source: ABdhPJwfMHCXP4RBQEQL4Gf9jNstd7Ec9h9vmcnbHtFyopsv1zvxVjEUqTeG7LWiE+/EQ6GQzNfg4g==
X-Received: by 2002:aa7:d858:: with SMTP id f24mr9722267eds.12.1604823634581;
        Sun, 08 Nov 2020 00:20:34 -0800 (PST)
Received: from [192.168.0.103] ([77.124.113.118])
        by smtp.gmail.com with ESMTPSA id d23sm5320280edp.36.2020.11.08.00.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Nov 2020 00:20:33 -0800 (PST)
Subject: Re: [PATCH] net/mlx4: Assign boolean values to a bool variable
To:     xiakaixu1987@gmail.com, tariqt@nvidia.com, tariqt@mellanox.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kaixu Xia <kaixuxia@tencent.com>
References: <1604732038-6057-1-git-send-email-kaixuxia@tencent.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <9c8efc31-3237-ed3b-bfba-c13494b6452d@gmail.com>
Date:   Sun, 8 Nov 2020 10:20:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1604732038-6057-1-git-send-email-kaixuxia@tencent.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/7/2020 8:53 AM, xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the following coccinelle warnings:
> 

Hi Kaixu,

Which coccinelle version gave this warning?


> ./drivers/net/ethernet/mellanox/mlx4/en_rx.c:687:1-17: WARNING: Assignment of 0/1 to bool variable
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 502d1b97855c..b0f79a5151cf 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -684,7 +684,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   	xdp_prog = rcu_dereference(ring->xdp_prog);
>   	xdp.rxq = &ring->xdp_rxq;
>   	xdp.frame_sz = priv->frag_info[0].frag_stride;
> -	doorbell_pending = 0;
> +	doorbell_pending = false;
>   
>   	/* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
>   	 * descriptor offset can be deduced from the CQE index instead of
> 

