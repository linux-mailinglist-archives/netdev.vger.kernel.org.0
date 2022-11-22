Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00B3633E12
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiKVNtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbiKVNtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:49:52 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96F6D58BCB;
        Tue, 22 Nov 2022 05:49:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l14so5920064wrw.13;
        Tue, 22 Nov 2022 05:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XNodkTSmcFgMZtJ5tvJzrfqzIK2LYeya7mLQRstpr1I=;
        b=qAR+HYd6/P11Sjj0B7bGv1DFE6y9xN5agRBLCirBCBP3Yp+5nDzo6T21+JfzqzPVde
         PFZwASQRn5u7sIOBJr0WjyUmEq1UhTMmw7kLrAhU9DIN0QEpF45VSAAHQfWrBt930YiJ
         lgkaHO8C2nmnaqk/QsuhYoW8mheHf8z0qelg+H5X+AjZtS75iEQDooDNYD9Cfh96Aoru
         w3q94pPAeoxUGEVzxRyQjCl6KF3rScZv2iysMhC4lUtrzA+tZqkwnXZ2/VQZLaLG8nAt
         sbuZoprb5MGchEWk0vzp/9/FsnLRLmaHrhM9vP0DmOFJTN5olpUWGVQfWCZoDEq6u7nG
         yMJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XNodkTSmcFgMZtJ5tvJzrfqzIK2LYeya7mLQRstpr1I=;
        b=erZ9wiJvQRuum7b7WuNu0+/xLZrutRJIdjFaFRI+F6azBjviES9cVJyC3Q/Gpr9yBv
         cJwo/KS7aTogahme8z+ddytsHIPgeWHUOtrHrgj0QTvXdYIsxKyTKUdwMjN0VeRbnPCz
         dRJp/EkJ3orrQSzq6/XiakRHt2+Hlj3zNkdiM/3Y818jOpyS04NPWZ7f/Sfvpt4JI5aD
         jeOqyAGuT9dm5CxYWUvvCYdd1WKEpUzEYUvkV1nubkPDMhbI3MrCK37bnwRPECxXNbah
         Id+EW+2v9UXfNEXk5Gs40jyn3TG1iW6Tj93CmI1nh1s124fDjYnOO5gCueaScc8skKJE
         voCw==
X-Gm-Message-State: ANoB5pnrX75uyCLgdGo8VOCCLWio4eMsdmkp072y1ty7hLUnP/23bNgz
        Vra6iSKlAMJBeurNUD5I/Fg=
X-Google-Smtp-Source: AA0mqf5GZjc+F+yu1OulAo+QwK2fYL7mY3JEzJ1O+KqOF5hzPS//8PoCvHARK2zW7Lm2RM25pwPZAw==
X-Received: by 2002:a05:6000:1c15:b0:241:d30c:62c4 with SMTP id ba21-20020a0560001c1500b00241d30c62c4mr6756991wrb.219.1669124989056;
        Tue, 22 Nov 2022 05:49:49 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id c9-20020a5d5289000000b00236545edc91sm14037035wrv.76.2022.11.22.05.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 05:49:48 -0800 (PST)
Message-ID: <b0764e41-b01d-ee28-4e5a-fd306929e75f@gmail.com>
Date:   Tue, 22 Nov 2022 15:49:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH bpf-next v2 6/8] mlx4: Introduce mlx4_xdp_buff wrapper for
 xdp_buff
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20221121182552.2152891-1-sdf@google.com>
 <20221121182552.2152891-7-sdf@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221121182552.2152891-7-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/2022 8:25 PM, Stanislav Fomichev wrote:
> No functional changes. Boilerplate to allow stuffing more data after xdp_buff.
> 
> Cc: Tariq Toukan <tariqt@nvidia.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_rx.c | 26 +++++++++++++---------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 8f762fc170b3..467356633172 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -661,17 +661,21 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
>   #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
>   #endif
>   
> +struct mlx4_xdp_buff {
> +	struct xdp_buff xdp;
> +};
> +
>   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
>   {
>   	struct mlx4_en_priv *priv = netdev_priv(dev);
>   	int factor = priv->cqe_factor;
>   	struct mlx4_en_rx_ring *ring;
> +	struct mlx4_xdp_buff this would helpmxbuf;

as it doesn't go through an init function (only mxbuf.xdp does), better 
init to zero.

>   	struct bpf_prog *xdp_prog;
>   	int cq_ring = cq->ring;
>   	bool doorbell_pending;
>   	bool xdp_redir_flush;
>   	struct mlx4_cqe *cqe;
> -	struct xdp_buff xdp;
>   	int polled = 0;
>   	int index;
>   
> @@ -681,7 +685,7 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   	ring = priv->rx_ring[cq_ring];
>   
>   	xdp_prog = rcu_dereference_bh(ring->xdp_prog);
> -	xdp_init_buff(&xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
> +	xdp_init_buff(&mxbuf.xdp, priv->frag_info[0].frag_stride, &ring->xdp_rxq);
>   	doorbell_pending = false;
>   	xdp_redir_flush = false;
>   
> @@ -776,24 +780,24 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
>   						priv->frag_info[0].frag_size,
>   						DMA_FROM_DEVICE);
>   
> -			xdp_prepare_buff(&xdp, va - frags[0].page_offset,
> +			xdp_prepare_buff(&mxbuf.xdp, va - frags[0].page_offset,
>   					 frags[0].page_offset, length, false);
> -			orig_data = xdp.data;
> +			orig_data = mxbuf.xdp.data;
>   
> -			act = bpf_prog_run_xdp(xdp_prog, &xdp);
> +			act = bpf_prog_run_xdp(xdp_prog, &mxbuf.xdp);
>   
> -			length = xdp.data_end - xdp.data;
> -			if (xdp.data != orig_data) {
> -				frags[0].page_offset = xdp.data -
> -					xdp.data_hard_start;
> -				va = xdp.data;
> +			length = mxbuf.xdp.data_end - mxbuf.xdp.data;
> +			if (mxbuf.xdp.data != orig_data) {
> +				frags[0].page_offset = mxbuf.xdp.data -
> +					mxbuf.xdp.data_hard_start;
> +				va = mxbuf.xdp.data;
>   			}
>   
>   			switch (act) {
>   			case XDP_PASS:
>   				break;
>   			case XDP_REDIRECT:
> -				if (likely(!xdp_do_redirect(dev, &xdp, xdp_prog))) {
> +				if (likely(!xdp_do_redirect(dev, &mxbuf.xdp, xdp_prog))) {
>   					ring->xdp_redirect++;
>   					xdp_redir_flush = true;
>   					frags[0].page = NULL;
