Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3F347591F
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 22:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfGYUtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 16:49:55 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43205 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGYUtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 16:49:55 -0400
Received: by mail-qt1-f196.google.com with SMTP id w17so6139421qto.10
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Zd2owx10a1oRsdUwqqqh4UaszeFT1IFkoqvOxOfoBzY=;
        b=dwdQ8Sm3FyxGqKvlXEbJxxfgEnBn3rbCuzbIOx/CogaLrGdxdEXQMWzQjXui44qfv3
         vOu6GXWeAO1bsaGWQPPBdi2xIfQbpcNXiVYDK7OJG/C0P3Rzwl6hTtHTdGF9I8i9JUu1
         iOga0BQeoQ4F2YLB22vP/Z/LU6FOQh4u45Z1Gp5+qmG+xGBkoAZTr08Wd3Y/JyESxq/b
         lpI84xCssNXV2GHlkQH5LQApJqcFMWJZmAjAwkWC0xXHRvUFFiX+Wi7DCEVtRy1kRsuv
         U4SD6B7k/il33KBoW/OxZBW6lAN8vev85e2JC3d1hX2L6FNHFwWpfzHGrpwkJNPBtE3M
         /KOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Zd2owx10a1oRsdUwqqqh4UaszeFT1IFkoqvOxOfoBzY=;
        b=Hayys2YK/6DpzDXx/ART4wBW9ejdsf2oNt2E5rb2d+rv9o6pI+NGywBwHqslnVwMrc
         b+7WQ+W1NHpBCPkDb8epTVTpZKtOL0ZSe+CHVkX0nc9+Z/giK16ey/aJqB41qQgo4Ay5
         kxQYrTYXWeqJMNx5l02+vJsBb9gx2BFBVlotEKScQRLvJ6EXKx+ye3K5N9bdQFm12fho
         v30dFEv1dgU20YkJAWG9m2PmJhU8gQ0iRBwPpxgiOahcMA29ufx2Zpng4fpyJTyJlz6j
         xlyGqzbZtP4Jl0EjJYbg6jetZcKFmtqRYL1V8cZTL5nqkAj9+hLcj+2wJo0W3s3kCZYQ
         VU1A==
X-Gm-Message-State: APjAAAUYF7qVr+7E/sKTwLNeovc2qopxvB/0Quhc2cjBIi8AL+IMj3zu
        PDkRYYqOu+uEraYKUKrX165LJAh4ZZo=
X-Google-Smtp-Source: APXvYqziHglK/ki0SKUYI1ssmgy6IE2GyTw4treRm+36ycev2YAGSF5CFViCIoKe/+wmmwDM1nmzzQ==
X-Received: by 2002:a0c:c3c7:: with SMTP id p7mr34699770qvi.125.1564087794268;
        Thu, 25 Jul 2019 13:49:54 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o33sm23280299qtd.72.2019.07.25.13.49.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 25 Jul 2019 13:49:54 -0700 (PDT)
Date:   Thu, 25 Jul 2019 13:49:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>
Subject: Re: [net 7/9] net/mlx5e: kTLS, Call WARN_ONCE on netdev mismatch
Message-ID: <20190725134950.74733e62@cakuba.netronome.com>
In-Reply-To: <20190725203618.11011-8-saeedm@mellanox.com>
References: <20190725203618.11011-1-saeedm@mellanox.com>
        <20190725203618.11011-8-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Jul 2019 20:36:48 +0000, Saeed Mahameed wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> A netdev mismatch in the processed TLS SKB should not occur,
> and indicates a kernel bug.
> Add WARN_ONCE to spot such cases.
> 
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Suggested-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> index ea032f54197e..3766545ce259 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> @@ -412,7 +412,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
>  		goto out;
>  
>  	tls_ctx = tls_get_ctx(skb->sk);
> -	if (unlikely(tls_ctx->netdev != netdev))
> +	if (unlikely(WARN_ON_ONCE(tls_ctx->netdev != netdev)))

Ah, nit: the unlikely is probably unnecessary but that's no big deal.

#define WARN_ON_ONCE(condition) ({			\
	static int __warned;				\
	int __ret_warn_once = !!(condition);		\
							\
	if (unlikely(__ret_warn_once && !__warned)) {	\
		__warned = true;			\
		WARN_ON(1);				\
	}						\
	unlikely(__ret_warn_once);			\
})

>  		goto err_out;
>  
>  	priv_tx = mlx5e_get_ktls_tx_priv_ctx(tls_ctx);

