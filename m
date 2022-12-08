Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0916468EF
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 07:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLHGL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 01:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLHGLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 01:11:46 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C6C9B7A7;
        Wed,  7 Dec 2022 22:11:45 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id m18so1502090eji.5;
        Wed, 07 Dec 2022 22:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nzfVoeg9k4c+g14oj8AbfzWK7zcrvrSvT/ySZBlnXqc=;
        b=e0RPRbXhfmg2nwJtzaYM1w5XWLJnm0MbxMcKjLVPSN+M8iHHnd/ByR9YFqlaiOTbf5
         O5OGDB3eZQPE9+e19MgR1svcwlclER3kgzHNRfQ/cXNTT1/97JWLEzXVmzmlQorgOGu6
         p8M2ZwuAgF6ou3OJu1rOgxue9NVhnMgJgdlmMk4XgJv17yAQJnKbEfq3hbeqAYc3gkzD
         Fo562+Kau//8UKplYWHCALeaV/thWyfqaZN386e5+XkQr2IsjDoCVHUmM/PQVTCEdY3P
         uUHUiTpyr0wumFaNKmY8RHLRHEE1J+6MoqB3wWMKV2k8JcJcA+On0XLa3JxNcIeeBZlK
         WRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nzfVoeg9k4c+g14oj8AbfzWK7zcrvrSvT/ySZBlnXqc=;
        b=RTs1EZ989ZQ+52G7+go6cT2AAMMHVCz0Ayq+JRSwY5qAjeg2SWs9XNHMwxSJxVTV3k
         VJPgS622GjXv2bO9JajVFzfV3tOUnjP8HudYSXXbWpsWg3YP9PF/xuf3Sdts4bJFS4ap
         B4J5lHHfZLzy2JsfRQ5TysbE3XL9Bb89zw5SzY5GgkeVnIo2vPVlj4mv9wbmq1/LuW0D
         1I78EgrpbE2h/JZkdcL1uRlG0X2sNhH2xnduUZQ8COqHqSoWVkkV4SDr2//dbUX2/CDm
         z6s/4gU/BlhVep+H/2SJmo5AwYWEhzuUANzvVVJ7RF8MDTJUReqkSXaWq6hIB03kWXu+
         utCg==
X-Gm-Message-State: ANoB5pkikFVtslT5Xx5lENz82OZWkmQUP4Li8Q9Y7Or0OTtUtWF5nluh
        iDHk9a1Ge1g+tVUuiq5O8Ws=
X-Google-Smtp-Source: AA0mqf6NdJVPfCrmzM6vjMCluPbZZipK71na5jEX0OEUV80Ft2XpUNn1oBqJEx+K7+vhW5yB95G6Tg==
X-Received: by 2002:a17:907:9951:b0:7b2:7e7a:11c1 with SMTP id kl17-20020a170907995100b007b27e7a11c1mr61598889ejc.684.1670479904055;
        Wed, 07 Dec 2022 22:11:44 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id bj15-20020a170906b04f00b007b5903e595bsm9272045ejb.84.2022.12.07.22.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 22:11:43 -0800 (PST)
Message-ID: <8d5f451a-c49b-1abc-6573-71831aa09739@gmail.com>
Date:   Thu, 8 Dec 2022 08:11:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH bpf-next v3 07/12] mlx4: Introduce mlx4_xdp_buff wrapper
 for xdp_buff
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
References: <20221206024554.3826186-1-sdf@google.com>
 <20221206024554.3826186-8-sdf@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221206024554.3826186-8-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/2022 4:45 AM, Stanislav Fomichev wrote:
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
> index 8f762fc170b3..9c114fc723e3 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -661,9 +661,14 @@ static int check_csum(struct mlx4_cqe *cqe, struct sk_buff *skb, void *va,
>   #define MLX4_CQE_STATUS_IP_ANY (MLX4_CQE_STATUS_IPV4)
>   #endif
>   
> +struct mlx4_xdp_buff {
> +	struct xdp_buff xdp;
> +};
> +

Prefer name with 'en', struct mlx4_en_xdp_buff.

>   int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int budget)
>   {
>   	struct mlx4_en_priv *priv = netdev_priv(dev);
> +	struct mlx4_xdp_buff mxbuf = {};
>   	int factor = priv->cqe_factor;
>   	struct mlx4_en_rx_ring *ring;
>   	struct bpf_prog *xdp_prog;
> @@ -671,7 +676,6 @@ int mlx4_en_process_rx_cq(struct net_device *dev, struct mlx4_en_cq *cq, int bud
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
