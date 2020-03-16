Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6100018728E
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 19:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732330AbgCPSmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 14:42:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39690 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732266AbgCPSmO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 14:42:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id b22so4234399pgb.6
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 11:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=14+aHnIsZDTUtjeEgfgLm/lvD8T2DWdRGxgiO55QrnI=;
        b=J8+5nVYX4ihLApPmpZZmXLQhuQKYfkRHLVlkjuE2rGHD7oggRNWu+9ylKNMEMp4F3g
         BqrRRBFyLY9AnYjGoJy5pddqdZ2zGHx71p8EDsTo/rb/58UoawZf3wDdn44ct7t86Ekp
         XdpRJPJJ8rn7pDku588/tu1oeYNgtwsyvynpI2ZXOg5eOaCRJ4ulZdIiiePoVsKDnIQ0
         bMLZIbwdeBWmjlrtfUHcmJ3mrenYGHTVBTMT0fO1hFUTYpFfkEbWe95ka27UNNYBolO8
         rHd0tmoudO4MKdwvT1Mf9ze7rMhQ8u4q3z/VlAS9uwhzG/dhMCmvHVvllSy3ygbAh6ot
         yBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=14+aHnIsZDTUtjeEgfgLm/lvD8T2DWdRGxgiO55QrnI=;
        b=PpcqQWHdavweNf5TFaasHS4pt8JxiHaba/t4FCW+O9MJ9qs8MH7PfCq3bUaIb3t8dh
         NijbOGd4Escb4mVSk2xcXo2XYwRxOl/6s+xEJ3Oy1QsABaq1EvhJXu3ojVze4Je94j+I
         yJqzKa+cG9RcenNjYHKs1Ehq9Rh9OVlIcajazD2K1bX3U5Wc3bUy4MWyxepCQzDWw98D
         HNV/VSupnADTOaX8/2WvOGaiwZecn8JBzdj4W4AVo7ojYtHFr9TvlWdqMQr4D9MZFURX
         oeW7PQeaRVOFeHIOB1ADn/gAZ/N4w7gn16HUxNlNXcayipTiqmmsxIwMCJQjQbfiYbI8
         SU0g==
X-Gm-Message-State: ANhLgQ2Cs5FTP5+gvRVCUhHZ2rpZOg979ROH+VveftZD5YHLODBMM+cV
        9akud/gGZnCqRHBimzUnF7p5q5X5bb9A/3z/08LNLQ==
X-Google-Smtp-Source: ADFU+vs5GdWDaVllQQPj+jePI0pzfKBekcbTtTza3uh2mbGjIgRIhDsW30/M4sh3CXpEVyfsOV/Xtl7nubhySreWhL0=
X-Received: by 2002:aa7:8b54:: with SMTP id i20mr987655pfd.39.1584384133226;
 Mon, 16 Mar 2020 11:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <1581847296-19194-8-git-send-email-paulb@mellanox.com> <20200314034019.3374-1-natechancellor@gmail.com>
In-Reply-To: <20200314034019.3374-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 16 Mar 2020 11:42:01 -0700
Message-ID: <CAKwvOdnZHo1UPs6w6_MmABH92-AGJ_g-WXcSdrRk4vdYwr-kPg@mail.gmail.com>
Subject: Re: [PATCH -next] net/mlx5: Add missing inline to stub esw_add_restore_rule
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     paulb@mellanox.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        jiri@mellanox.com, Network Development <netdev@vger.kernel.org>,
        ozsh@mellanox.com, roid@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>, vladbu@mellanox.com,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 8:41 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> When CONFIG_MLX5_ESWITCH is unset, clang warns:
>
> In file included from drivers/net/ethernet/mellanox/mlx5/core/main.c:58:
> drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:670:1: warning: unused
> function 'esw_add_restore_rule' [-Wunused-function]
> esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
> ^
> 1 warning generated.
>
> This stub function is missing inline; add it to suppress the warning.
>
> Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>

Yep, thanks for the patch!
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> index 2e0417dd8ce3..470a16e63242 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
> @@ -666,7 +666,7 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
>
>  static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs) {}
>
> -static struct mlx5_flow_handle *
> +static inline struct mlx5_flow_handle *
>  esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
>  {
>         return ERR_PTR(-EOPNOTSUPP);
> --
> 2.26.0.rc1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200314034019.3374-1-natechancellor%40gmail.com.



-- 
Thanks,
~Nick Desaulniers
