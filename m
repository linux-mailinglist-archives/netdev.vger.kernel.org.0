Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7D6963DF8
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 00:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727094AbfGIWpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 18:45:11 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36900 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfGIWpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 18:45:11 -0400
Received: by mail-pl1-f196.google.com with SMTP id b3so134408plr.4
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 15:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HdEAFGYznBedGd021Ijrm2rGeONx0Nh9gIJfHcF9bo0=;
        b=vawNdm3GLeTsLcB4+BBc9MgTu2yHpMCBbsC60j9hkjfWaxtrDoUYkFm+gWHAvcCzlt
         WuywjL2KAjT/Za2jEFzbLz2X2NjAYID3Ux8fLXKnw4xlLtypJ88Oi1ReKDH+VJizjAZr
         QZC5wWUHE5ucPIM2iJdqKrOfVBNIIUa46WNXR39SwI7jTfdU6zmC2uA4wEIgU90JgyUl
         QaIWsJf+6+gJztCOl6XRj4RsR/KutsWFCn9YYWuIatRmpMEaiUTadMbis9OaXcKz5cjG
         miCBNHashqhbrRaZrLZJwExTK/oyORpi+OCYYZiJxYsI9YcNvXxqMiIwFUKovnW9jJcv
         DxXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HdEAFGYznBedGd021Ijrm2rGeONx0Nh9gIJfHcF9bo0=;
        b=Z4E/+Gn7uC6JvNyhuskotVRX7AOimF4e20a0Jh9qr7Z53/vmsw0R/b4SJB94S+n2OM
         EdThOpQVOLA5ZyRCKcL9DceDn2ACs8aoVwBCbAAG6NHBZZx3+RlNziQ89RAZNcEjOuRk
         nJWBv/nJ3tlQICkGFz6UQD3e7DLXHvhZ0A0s2XKAVjS6YXDf7TSJLXZ+aVd698auTMsz
         9Vub8U0LhwBcTDCxESdLxw9bizpDAalioYNT9QkJmA2UnBVEpjkNJMwh9+ScNKLmwiLt
         Xu3ZxWT+J0u1qeLzT3D4Le3cSqpRxcqRFein6B95/XdTizjbktAPaonC6KeUfgJ0fI9N
         SWXQ==
X-Gm-Message-State: APjAAAW12/0K5rDNf1TBOLWfR1zwQpEfgaVv+iN4v3GkR84NDJkkmPSJ
        Mqyhzb88B+UgHdCg8Vx0VhMMSR4pE4PUyO4T9HxYcg==
X-Google-Smtp-Source: APXvYqzHSAo1y0SQ8m3kxbIJPbmaNzzppTVvGPLlplIj158XWTVsxXhYDDeZ42jX8NISgVeb9UdpUACtgQ00yMECKuo=
X-Received: by 2002:a17:902:b944:: with SMTP id h4mr34236270pls.179.1562712310304;
 Tue, 09 Jul 2019 15:45:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190708231154.89969-1-natechancellor@gmail.com>
In-Reply-To: <20190708231154.89969-1-natechancellor@gmail.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 9 Jul 2019 15:44:59 -0700
Message-ID: <CAKwvOdkYdNiKorJAKHZ7LTfk9eOpMqe6F4QSmJWQ=-YNuPAyrw@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Return in default case statement in tx_post_resync_params
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Boris Pismenny <borisp@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 8, 2019 at 4:13 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> clang warns:
>
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:251:2:
> warning: variable 'rec_seq_sz' is used uninitialized whenever switch
> default is taken [-Wsometimes-uninitialized]
>         default:
>         ^~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:255:46: note:
> uninitialized use occurs here
>         skip_static_post = !memcmp(rec_seq, &rn_be, rec_seq_sz);
>                                                     ^~~~~~~~~~
> drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c:239:16: note:
> initialize the variable 'rec_seq_sz' to silence this warning
>         u16 rec_seq_sz;
>                       ^
>                        = 0
> 1 warning generated.
>
> This case statement was clearly designed to be one that should not be
> hit during runtime because of the WARN_ON statement so just return early
> to prevent copying uninitialized memory up into rn_be.
>
> Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
> Link: https://github.com/ClangBuiltLinux/linux/issues/590
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> index 3f5f4317a22b..5c08891806f0 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
> @@ -250,6 +250,7 @@ tx_post_resync_params(struct mlx5e_txqsq *sq,
>         }
>         default:
>                 WARN_ON(1);
> +               return;
>         }

hmm...a switch statement with a single case is a code smell.  How
about a single conditional with early return?  Then the "meat" of the
happy path doesn't need an additional level of indentation.
-- 
Thanks,
~Nick Desaulniers
