Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F33241647A
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 19:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242606AbhIWRdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 13:33:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242402AbhIWRdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 13:33:06 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7837EC061574;
        Thu, 23 Sep 2021 10:31:34 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id i8so2626533uae.7;
        Thu, 23 Sep 2021 10:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+eLkYhNtPz468JECzicPH+55KzTJypaKR1YIxXBGKFA=;
        b=dQZlVD8zeXrYwt3wy2PGOmtTCuGtQ2/Jgt3RefZ5d0GisMFUk4AgD5Z3HLJfw3vSVx
         PaAWtDj9X68m9rDET0mUN9ga/1CQiB3uYOpYeAXdZBLYSukNgiEZeqgVcKx1C8UgvlwJ
         5UPq5n2BKkqHaeL7eOsRI3opCiSAisnFEdY7S/OBx2nnSRuy4dszdTLdnwoTABR8FC2b
         m875rdvSO7Qn4QzNzkKnDd38bZqpD0K0bcHtgpofgcGgUVgwSoUamTjy/8sFfaq/DU1f
         x6bODSEZ+4GDo6PKd8b1S6hiaLxXMEdCeyxVAVYOf7Hsk3LaOmwaH4jZ0v6qip+jKNcR
         2Zkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+eLkYhNtPz468JECzicPH+55KzTJypaKR1YIxXBGKFA=;
        b=f0axcE2B8+EqSjVcHcPEbnpJ25NiRwsvQagHjEThuAF9W0wrtBvktqE1hLsv1WTc8U
         GtypeY+FGYMYkg0XJA2cvGUjuwVDwl0+o/qgOCbt4B5f6Z7gjxaGbBMTdxvbYNdFNuHn
         rBjETyPTlHy83S0lqacPwpZlpSdM4dyXjLsxypl67gZymz0UgIc5MVEGIAcKDTG0kP0j
         bvaRRjIZ7/y2CC9MO/7F4kuSjaHjGitzSHVJvnaFz4wAfuk9MZnRF9PuER2m7J+pe37l
         DVBtpEI4zTjNjp6I7Sl4v9Nzvl/B2owGA0WaDSXpeb1wGFPFdAeyGyPGxmYoaWDdwpgL
         bwIA==
X-Gm-Message-State: AOAM533XBRMkqR7X+sBLrD29uKtscW51eisFpv9WmNPngGS2zgzGchBT
        QaHqeT7sbv2iyasI0U6vUPU5Ez3Kxh9g3hM6um7kZ649RDg=
X-Google-Smtp-Source: ABdhPJydA+GP2gNnH2uFrnugHWkTR16KM7HKYgoKjZJUTpYhVa7u6TQrT6QRCt9S/Dqf/81OUokJ548XvLm90xwwUxc=
X-Received: by 2002:ab0:284d:: with SMTP id c13mr5469553uaq.26.1632418293386;
 Thu, 23 Sep 2021 10:31:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210923161034.18975-1-roysjosh@gmail.com>
In-Reply-To: <20210923161034.18975-1-roysjosh@gmail.com>
From:   Joshua Roys <roysjosh@gmail.com>
Date:   Thu, 23 Sep 2021 13:31:22 -0400
Message-ID: <CANoNxL_E_+MLu=Re-71J4FfFUcpA0met0AMnjtK2+jw6hGKCJw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mlx4: Add support for XDP_REDIRECT
To:     netdev@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, daniel@iogearbox.net, kuba@kernel.org,
        bpf@vger.kernel.org, tariqt@nvidia.com, linux-rdma@vger.kernel.org,
        Joshua Roys <roysjosh@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding requested maintainers to CC.

On Thu, Sep 23, 2021 at 12:11 PM Joshua Roys <roysjosh@gmail.com> wrote:
>
> Signed-off-by: Joshua Roys <roysjosh@gmail.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> This is a pattern-match commit, based off of the mlx4 XDP_TX and other
> drivers' XDP_REDIRECT enablement patches. The goal was to get AF_XDP
> working in VPP and this was successful. Tested with a CX3.
>
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 7f6d3b82c29b..557d7daac2d3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -669,6 +669,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>         struct bpf_prog *xdp_prog;
>         int cq_ring = cq->ring;
>         bool doorbell_pending;
> +       bool xdp_redir_flush;
>         struct mlx4_cqe *cqe;
>         struct xdp_buff xdp;
>         int polled = 0;
> @@ -682,6 +683,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>         xdp_prog = rcu_dereference_bh(ring->xdp_prog);
>         xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
>         doorbell_pending = false;
> +       xdp_redir_flush = false;
>
>         /* We assume a 1:1 mapping between CQEs and Rx descriptors, so Rx
>          * descriptor offset can be deduced from the CQE index instead of
> @@ -790,6 +792,14 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>                         switch (act) {
>                         case XDP_PASS:
>                                 break;
> +                       case XDP_REDIRECT:
> +                               if (xdp_do_redirect(dev, &xdp, xdp_prog) >= 0) {
> +                                       xdp_redir_flush = true;
> +                                       frags[0].page = NULL;
> +                                       goto next;
> +                               }
> +                               trace_xdp_exception(dev, xdp_prog, act);
> +                               goto xdp_drop_no_cnt;
>                         case XDP_TX:
>                                 if (likely(!mlx4_en_xmit_frame(ring, frags, priv,
>                                                         length, cq_ring,
> @@ -897,6 +907,9 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>                         break;
>         }
>
> +       if (xdp_redir_flush)
> +               xdp_do_flush();
> +
>         if (likely(polled)) {
>                 if (doorbell_pending) {
>                         priv->tx_cq[TX_XDP][cq_ring]->xdp_busy = true;
> --
> 2.31.1
>
