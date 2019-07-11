Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8479C65158
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 07:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfGKFHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 01:07:22 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36961 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfGKFHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 01:07:22 -0400
Received: by mail-lf1-f66.google.com with SMTP id c9so3131992lfh.4
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 22:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dev-mellanox-co-il.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6jRCkzFLYjyJ6X5g3ewnp6mfnb6gNJiKbFQr06/RqCA=;
        b=RWonoSpyfsKOKFzSyn7qbthOrCYR6Lq+MKk+bt2ZdZEOydQDZU5kzpX2VaTo+FFsd3
         9i2G5BURZS7Tgql+yjq5CMwdgkGKnak0B8WISX9kle588nx0WGGtmb+9zcOoAf/Ce2Q1
         F5kceZJRBdX4e60TF0X5oSkWG+WCHNngVeaAeWOgPxOJM9GxlIF3wa40niTD0ootIkAJ
         xcvqWHLJv31/vKvAdUsHmnF0Ee11uGiE3Fu1isZv6+6KemXLcixXSpiAs4yFFqTwTw/L
         1dSup7BHLFOQ2LjRJPYFOJBDIC6/gJcBruA+kMHUa5uvbkwCbdfOER1a7glaKVm5Q2AA
         CbKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6jRCkzFLYjyJ6X5g3ewnp6mfnb6gNJiKbFQr06/RqCA=;
        b=KBcLGW/oIYbHJm1JeHyE0J1QPTBU9YIKjQp7GVU21AJBjG1yJFZV9ZS4Ib99gs/PgQ
         TMaFCfX1FQq+1hYAhZ66syLRAs429TmGFn/5VNPhBvo/DpS52ti0tMNIwCUGH7/cQjos
         MSPbhwtj5XSIcjimprdJmtfUTw7R+0ov4AhUppcKA61QnTGttOAr6Pna/48o88N8blpj
         6gGXaeO2KWfX5IpdAsAs75npg3LMTDZkISnySQHSsIPTaBOJIJnoc9ifz3Q9TTsxIA6P
         mYB0M1Ak+o16EkEHYzuKVxfMQqn7Q4B5dDJAmOCfHdi2lLxTdrGK7ZgncMqIXY/Rphbr
         KapQ==
X-Gm-Message-State: APjAAAXt5YUW+NQlV21ytLKBoOBOZrwIna6jO28L9sM0qfG6WQkT4SEK
        CczYuUKphmdneNjpYsA9gw47X3MG/MxxVbbEmlA=
X-Google-Smtp-Source: APXvYqwhHgjr7lt9K1nz7gMRASQm5aYb0wE65pNOE2aog8ST987iGoImvhlhEtDtyfQgePppiptkwQcZMkfLp1u1qxE=
X-Received: by 2002:a19:914c:: with SMTP id y12mr700422lfj.108.1562821640777;
 Wed, 10 Jul 2019 22:07:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190710093852.34549-1-maowenan@huawei.com>
In-Reply-To: <20190710093852.34549-1-maowenan@huawei.com>
From:   Saeed Mahameed <saeedm@dev.mellanox.co.il>
Date:   Wed, 10 Jul 2019 22:07:09 -0700
Message-ID: <CALzJLG8V=jZdMJ_pMZWxieWxm8NEP+48FNaBSnfcNuXMy2xUGw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mlx5: Fix compiling error in tls.c
To:     Mao Wenan <maowenan@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 10, 2019 at 2:33 AM Mao Wenan <maowenan@huawei.com> wrote:
>
> There are some errors while compiling tls.c if
> CONFIG_MLX5_FPGA_TLS is not obvious on.
>
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c: In function mlx5e_tls_set_ipv4_flow:
> ./include/linux/mlx5/device.h:61:39: error: invalid application of sizeof to incomplete type struct mlx5_ifc_tls_flow_bits
>  #define __mlx5_st_sz_bits(typ) sizeof(struct mlx5_ifc_##typ##_bits)
>                                        ^
> ./include/linux/compiler.h:330:9: note: in definition of macro __compiletime_assert
>    if (!(condition))     \
>          ^~~~~~~~~
> ...
>
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c: In function mlx5e_tls_build_netdev:
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:202:13: error: MLX5_ACCEL_TLS_TX undeclared (first use in this function); did you mean __MLX5_ACCEL_TLS_H__?
>   if (caps & MLX5_ACCEL_TLS_TX) {
>              ^~~~~~~~~~~~~~~~~
>              __MLX5_ACCEL_TLS_H__
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:207:13: error: MLX5_ACCEL_TLS_RX undeclared (first use in this function); did you mean MLX5_ACCEL_TLS_TX?
>   if (caps & MLX5_ACCEL_TLS_RX) {
>              ^~~~~~~~~~~~~~~~~
>              MLX5_ACCEL_TLS_TX
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:212:15: error: MLX5_ACCEL_TLS_LRO undeclared (first use in this function); did you mean MLX5_ACCEL_TLS_RX?
>   if (!(caps & MLX5_ACCEL_TLS_LRO)) {
>                ^~~~~~~~~~~~~~~~~~
>                MLX5_ACCEL_TLS_RX
> make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.o] Error 1
> make[5]: *** Waiting for unfinished jobs....
> make[4]: *** [drivers/net/ethernet/mellanox/mlx5/core] Error 2
> make[3]: *** [drivers/net/ethernet/mellanox] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [drivers/net/ethernet] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....
>
> this patch is to fix this error using 'depends on MLX5_FPGA_TLS' when MLX5_TLS is set.
>

Hi Mao, Thanks for the patch. sorry for the delayed response, I was
out of office.

Actually MLX5_TLS doesn't depend on MLX5_FPGA_TLS anymore.
Tariq prepared a patch to fix this, we will submit it this week.


> Fixes: e2869fb2068b ("net/mlx5: Kconfig, Better organize compilation flags")
>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> index 37fef8c..1da2770 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -139,6 +139,7 @@ config MLX5_TLS
>         depends on MLX5_CORE_EN
>         depends on TLS_DEVICE
>         depends on TLS=y || MLX5_CORE=m
> +       depends on MLX5_FPGA_TLS
>         select MLX5_ACCEL
>         default n
>         help
> --
> 2.7.4
>
