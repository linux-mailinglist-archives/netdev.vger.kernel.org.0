Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877DE3DD3FD
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 12:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhHBKj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 06:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhHBKj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 06:39:56 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60B01C06175F;
        Mon,  2 Aug 2021 03:39:46 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id cb3so8172438ejb.1;
        Mon, 02 Aug 2021 03:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7RZbialLtg71jkrVBr3pVt1310vgnsx2TbyqnfrzzjA=;
        b=uG0SyCLks1zalQ3u2A5k/P8DG9LyB9J55tLHYo/UA0nL4G0SGi5VYxM/CWnBs7E5pX
         tLPN9D2Man9FMoeJIy6VX6zfYaz2G4KnJqDatgc39KiFZTf/9IFbBUsRA2skKghIA8mc
         7jW5ERlvnaEse9aOfWtSgG71+kkDW7L7b5f1uEYeOCMzbS0WGVR+HvRVV8F0jbqIc5KE
         Ir6HOVPyX35sCxQuThO+WSHq46IY62f5BWuSQuQs9o9ar0UwNqkR5Dx2sroj9OMxYMgk
         NvGf9bfM6lZyXEIZypScknsh5TcAorRjb5cHBVWYrmJDCLj1w2C5g0uDP78KWrlhqcTR
         Ll0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7RZbialLtg71jkrVBr3pVt1310vgnsx2TbyqnfrzzjA=;
        b=iJ9+03p8kVybyGRT2g4ADUCimNbwjdVPtwyYLR8MZHKYAnOeCH7o+TERLLKW4xLQGh
         N+TQhtYDOCASEqK63CM5e5PAMfxkYwUdvu1i2nRPiIy3tuvCfmjGO6iywljw+XwcjxIG
         QRufhTYsHKZtUMoZlPv8fC/p4ayG3wAIMQEsG9qnwocB0O2JFvNnx3VEvSigy7DahA80
         FAl97L9EOcEk7mznu0VGNnXo8qL4ejlj+hCnDcFURYDwIjexVQjf8g2ngXyHXKfWuTdT
         gA30SLRrzvO03vcOTkXyegNaGlMKVc1K3gnsBXix7tRYBMm3esLIPlSlQBuboUPIvc39
         XjlA==
X-Gm-Message-State: AOAM532bSVQNbTQWN7bO5ZgbxPSvHoOZz9H7k3oh8JJpI9Pv3nH2mOD1
        4Gp7CyYD8WhgvSKiNgbNWl3d4C/xjOE=
X-Google-Smtp-Source: ABdhPJz3oJwSjC5GJg+587uGZagCAVZtmznvepO/C6Yxn5oV5PSg8Xg66b7ZCGku9AvQpf9/2O7VrA==
X-Received: by 2002:a17:907:2d28:: with SMTP id gs40mr15033869ejc.193.1627900784909;
        Mon, 02 Aug 2021 03:39:44 -0700 (PDT)
Received: from [192.168.0.108] ([77.127.114.213])
        by smtp.gmail.com with ESMTPSA id cz3sm5786151edb.11.2021.08.02.03.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 03:39:44 -0700 (PDT)
Subject: Re: [PATCH] net/mlx4: make the array states static const, makes
 object smaller
To:     Colin King <colin.king@canonical.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210801153742.147304-1-colin.king@canonical.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <6a85a949-22ab-2934-da15-ff5f6c84bb52@gmail.com>
Date:   Mon, 2 Aug 2021 13:39:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210801153742.147304-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/1/2021 6:37 PM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array states on the stack but instead it
> static const. Makes the object code smaller by 79 bytes.
> 
> Before:
>     text   data   bss    dec    hex filename
>    21309   8304   192  29805   746d drivers/net/ethernet/mellanox/mlx4/qp.o
> 
> After:
>     text   data   bss    dec    hex filename
>    21166   8368   192  29726   741e drivers/net/ethernet/mellanox/mlx4/qp.o
> 
> (gcc version 10.2.0)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/qp.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
> index 427e7a31862c..2584bc038f94 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/qp.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
> @@ -917,7 +917,7 @@ int mlx4_qp_to_ready(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
>   {
>   	int err;
>   	int i;
> -	enum mlx4_qp_state states[] = {
> +	static const enum mlx4_qp_state states[] = {
>   		MLX4_QP_STATE_RST,
>   		MLX4_QP_STATE_INIT,
>   		MLX4_QP_STATE_RTR,
> 

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Thanks for your patch.

Regards,
Tariq
