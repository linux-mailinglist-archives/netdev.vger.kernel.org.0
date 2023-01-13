Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD15F66A49F
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 21:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjAMUzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 15:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231328AbjAMUyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 15:54:33 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A281D8A21E;
        Fri, 13 Jan 2023 12:53:52 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id qk9so55072925ejc.3;
        Fri, 13 Jan 2023 12:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uiZKYWVMv8+GN0imjMsXpdWU7oNMb2M3F3lY1kxZB0M=;
        b=E04DXtWkoWWMmcc89AI2TjatqKMNJdsJRJJTkP/dQ+B2zn6ZFyW2QZK5g2A2tqnuO4
         i/fw8PpK6oUN5EewtqcbrPdEPO3cSQul0MIyAzyxqBwpEMHs1GjcampZcfW5oYN/F+N+
         iPFrPxfpVE4LY73lWfu9GrEvKwXEyli7qMOD78fhe1TYD0SFRcHzFgKduDxk+J72junR
         G3ezVVmXKtYyll9cAmIJ+45lh1wftk8qlAkeoY6Xitl/t2rSSqo0LiY7uj7mmZFEM5TQ
         lBlziO/5LrQCkh7+kDZqc3gMMOLAE80A9KDtMTjgqyCVNNOkNCe/ECGMyC4go0ZzJibf
         pa7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uiZKYWVMv8+GN0imjMsXpdWU7oNMb2M3F3lY1kxZB0M=;
        b=VExBLBB3udaGtOfI1moRHsHULvN6QEzda1BW1qM0+Y7LcIjSOjXei+WcAkGsmpbeW7
         bjBFYuj9N66kcRdNWkFgZUb/RnE60WeLDCPDSvB9aQFS6GF9TooEro8kU9uT3HoweBUi
         9zth9meVEShKb/QxTa+Yo6NggTLqPRgaZdNCTSi9C1l2rdcshY4+RUU+AMd96A1GJjNW
         lp4TUyD6BrU2WnvHfBdflJXn/MykhB1qMTngZSgloVIGujmqis8+It13KpUhMpmeuVXl
         h5PVOZb3W3rrMY8Eby6N3qDU7ZCe7v3fWqPpCs/N0TzAzBv6KAn821oDKpCB4LVYtcU6
         8v6g==
X-Gm-Message-State: AFqh2kpPT4kY98YBvOUNYlCbL+blImTNejmr3F5lptU9by68RWCcN5un
        5PRStBhlPMvDs9o04RgM8maTePeA+BrIKQ==
X-Google-Smtp-Source: AMrXdXvUam3G+6mz6b2/+Ow2DYTvGkjNvwb7ubtevMGdq5UXZxdK/W/UtMFvEWizyJCeKUOXWx2lKA==
X-Received: by 2002:a17:907:a802:b0:84d:430a:5e5c with SMTP id vo2-20020a170907a80200b0084d430a5e5cmr22934024ejc.32.1673643231114;
        Fri, 13 Jan 2023 12:53:51 -0800 (PST)
Received: from [192.168.0.105] ([77.126.1.183])
        by smtp.gmail.com with ESMTPSA id c23-20020a170906155700b007a9c3831409sm8892590ejd.137.2023.01.13.12.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 12:53:50 -0800 (PST)
Message-ID: <d83f2193-3fb9-e30f-cfb0-f1098f039b67@gmail.com>
Date:   Fri, 13 Jan 2023 22:53:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce
 wrapper for xdp_buff
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
 <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
 <87k01rfojm.fsf@toke.dk> <87h6wvfmfa.fsf@toke.dk>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <87h6wvfmfa.fsf@toke.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/01/2023 23:55, Toke Høiland-Jørgensen wrote:
> Toke Høiland-Jørgensen <toke@redhat.com> writes:
> 
>> Stanislav Fomichev <sdf@google.com> writes:
>>
>>> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>
>>>>> Preparation for implementing HW metadata kfuncs. No functional change.
>>>>>
>>>>> Cc: Tariq Toukan <tariqt@nvidia.com>
>>>>> Cc: Saeed Mahameed <saeedm@nvidia.com>
>>>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>>>> Cc: David Ahern <dsahern@gmail.com>
>>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>>> Cc: Willem de Bruijn <willemb@google.com>
>>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>>>> Cc: xdp-hints@xdp-project.net
>>>>> Cc: netdev@vger.kernel.org
>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>>> ---
>>>>>    drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>>>>    .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>>>>>    .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>>>>>    .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>>>>>    .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++----------
>>>>>    5 files changed, 50 insertions(+), 43 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>> index 2d77fb8a8a01..af663978d1b4 100644
>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>> @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>>>>>    union mlx5e_alloc_unit {
>>>>>        struct page *page;
>>>>>        struct xdp_buff *xsk;
>>>>> +     struct mlx5e_xdp_buff *mxbuf;
>>>>
>>>> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf and
>>>> alloc_units[page_idx].xsk, while both fields share the memory of a union.
>>>>
>>>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
>>>> need to change the existing xsk field type from struct xdp_buff *xsk
>>>> into struct mlx5e_xdp_buff *xsk and align the usage.
>>>
>>> Hmmm, good point. I'm actually not sure how it works currently.
>>> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
>>> am I missing something?
>>
>> It's initialised piecemeal in different places; but yeah, we're mixing
>> things a bit...
>>
>>> I'm thinking about something like this:
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> index af663978d1b4..2d77fb8a8a01 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> @@ -469,7 +469,6 @@ struct mlx5e_txqsq {
>>>   union mlx5e_alloc_unit {
>>>          struct page *page;
>>>          struct xdp_buff *xsk;
>>> -       struct mlx5e_xdp_buff *mxbuf;
>>>   };
>>
>> Hmm, for consistency with the non-XSK path we should rather go the other
>> direction and lose the xsk member, moving everything to mxbuf? Let me
>> give that a shot...
> 
> Something like the below?
> 
> -Toke
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 6de02d8aeab8..cb9cdb6421c5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -468,7 +468,6 @@ struct mlx5e_txqsq {
>   
>   union mlx5e_alloc_unit {
>   	struct page *page;
> -	struct xdp_buff *xsk;
>   	struct mlx5e_xdp_buff *mxbuf;
>   };
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> index cb568c62aba0..95694a25ec31 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
> @@ -33,6 +33,7 @@
>   #define __MLX5_EN_XDP_H__
>   
>   #include <linux/indirect_call_wrapper.h>
> +#include <net/xdp_sock_drv.h>
>   
>   #include "en.h"
>   #include "en/txrx.h"
> @@ -112,6 +113,21 @@ static inline void mlx5e_xmit_xdp_doorbell(struct mlx5e_xdpsq *sq)
>   	}
>   }
>   
> +static inline struct mlx5e_xdp_buff *mlx5e_xsk_buff_alloc(struct xsk_buff_pool *pool)
> +{
> +	return (struct mlx5e_xdp_buff *)xsk_buff_alloc(pool);

What about the space needed for the rq / cqe fields? xsk_buff_alloc 
won't allocate it.

> +}
> +
> +static inline void mlx5e_xsk_buff_free(struct mlx5e_xdp_buff *mxbuf)
> +{
> +	xsk_buff_free(&mxbuf->xdp);
> +}
> +
> +static inline dma_addr_t mlx5e_xsk_buff_xdp_get_frame_dma(struct mlx5e_xdp_buff *mxbuf)
> +{
> +	return xsk_buff_xdp_get_frame_dma(&mxbuf->xdp);
> +}
> +
>   /* Enable inline WQEs to shift some load from a congested HCA (HW) to
>    * a less congested cpu (SW).
>    */
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> index 8bf3029abd3c..1f166dbb7f22 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
> @@ -3,7 +3,6 @@
>   
>   #include "rx.h"
>   #include "en/xdp.h"
> -#include <net/xdp_sock_drv.h>
>   #include <linux/filter.h>
>   
>   /* RX data path */
> @@ -21,7 +20,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   	if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wqe)))
>   		goto err;
>   
> -	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) != sizeof(wi->alloc_units[0].xsk));
> +	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) != sizeof(wi->alloc_units[0].mxbuf));
>   	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
>   	batch = xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->alloc_units,
>   				     rq->mpwqe.pages_per_wqe);

This batching API gets broken as well...
xsk_buff_alloc_batch fills an array of struct xdp_buff pointers, it 
cannot correctly act on the array of struct mlx5e_xdp_buff, as it 
contains additional fields.

Maybe letting mlx5e_xdp_buff point to its struct xdp_buff (instead of 
wrapping it) will solve the problems here, then we'll loop over the 
xdp_buff * array and copy the pointers into the struct mlx5e_xdp_buff * 
array.
Need to give it deeper thoughts...

struct mlx5e_xdp_buff {
	struct xdp_buff *xdp;
	struct mlx5_cqe64 *cqe;
	struct mlx5e_rq *rq;
};


> @@ -33,8 +32,8 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   	 * the first error, which will mean there are no more valid descriptors.
>   	 */
>   	for (; batch < rq->mpwqe.pages_per_wqe; batch++) {
> -		wi->alloc_units[batch].xsk = xsk_buff_alloc(rq->xsk_pool);
> -		if (unlikely(!wi->alloc_units[batch].xsk))
> +		wi->alloc_units[batch].mxbuf = mlx5e_xsk_buff_alloc(rq->xsk_pool);
> +		if (unlikely(!wi->alloc_units[batch].mxbuf))
>   			goto err_reuse_batch;
>   	}
>   
> @@ -44,7 +43,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   
>   	if (likely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_ALIGNED)) {
>   		for (i = 0; i < batch; i++) {
> -			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
> +			dma_addr_t addr = mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].mxbuf);
>   
>   			umr_wqe->inline_mtts[i] = (struct mlx5_mtt) {
>   				.ptag = cpu_to_be64(addr | MLX5_EN_WR),
> @@ -53,7 +52,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   		}
>   	} else if (unlikely(rq->mpwqe.umr_mode == MLX5E_MPWRQ_UMR_MODE_UNALIGNED)) {
>   		for (i = 0; i < batch; i++) {
> -			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
> +			dma_addr_t addr = mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].mxbuf);
>   
>   			umr_wqe->inline_ksms[i] = (struct mlx5_ksm) {
>   				.key = rq->mkey_be,
> @@ -65,7 +64,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   		u32 mapping_size = 1 << (rq->mpwqe.page_shift - 2);
>   
>   		for (i = 0; i < batch; i++) {
> -			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
> +			dma_addr_t addr = mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].mxbuf);
>   
>   			umr_wqe->inline_ksms[i << 2] = (struct mlx5_ksm) {
>   				.key = rq->mkey_be,
> @@ -91,7 +90,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   		__be32 frame_size = cpu_to_be32(rq->xsk_pool->chunk_size);
>   
>   		for (i = 0; i < batch; i++) {
> -			dma_addr_t addr = xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
> +			dma_addr_t addr = mlx5e_xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].mxbuf);
>   
>   			umr_wqe->inline_klms[i << 1] = (struct mlx5_klm) {
>   				.key = rq->mkey_be,
> @@ -137,7 +136,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>   
>   err_reuse_batch:
>   	while (--batch >= 0)
> -		xsk_buff_free(wi->alloc_units[batch].xsk);
> +		mlx5e_xsk_buff_free(wi->alloc_units[batch].mxbuf);
>   
>   err:
>   	rq->stats->buff_alloc_err++;
> @@ -156,7 +155,7 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
>   	 * allocate XDP buffers straight into alloc_units.
>   	 */
>   	BUILD_BUG_ON(sizeof(rq->wqe.alloc_units[0]) !=
> -		     sizeof(rq->wqe.alloc_units[0].xsk));
> +		     sizeof(rq->wqe.alloc_units[0].mxbuf));
>   	buffs = (struct xdp_buff **)rq->wqe.alloc_units;
>   	contig = mlx5_wq_cyc_get_size(wq) - ix;
>   	if (wqe_bulk <= contig) {
> @@ -177,8 +176,9 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
>   		/* Assumes log_num_frags == 0. */
>   		frag = &rq->wqe.frags[j];
>   
> -		addr = xsk_buff_xdp_get_frame_dma(frag->au->xsk);
> +		addr = mlx5e_xsk_buff_xdp_get_frame_dma(frag->au->mxbuf);
>   		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
> +		frag->au->mxbuf->rq = rq;
>   	}
>   
>   	return alloc;
> @@ -199,12 +199,13 @@ int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk)
>   		/* Assumes log_num_frags == 0. */
>   		frag = &rq->wqe.frags[j];
>   
> -		frag->au->xsk = xsk_buff_alloc(rq->xsk_pool);
> -		if (unlikely(!frag->au->xsk))
> +		frag->au->mxbuf = mlx5e_xsk_buff_alloc(rq->xsk_pool);
> +		if (unlikely(!frag->au->mxbuf))
>   			return i;
>   
> -		addr = xsk_buff_xdp_get_frame_dma(frag->au->xsk);
> +		addr = mlx5e_xsk_buff_xdp_get_frame_dma(frag->au->mxbuf);
>   		wqe->data[0].addr = cpu_to_be64(addr + rq->buff.headroom);
> +		frag->au->mxbuf->rq = rq;
>   	}
>   
>   	return wqe_bulk;
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index 7b08653be000..4313165709cb 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -41,7 +41,6 @@
>   #include <net/gro.h>
>   #include <net/udp.h>
>   #include <net/tcp.h>
> -#include <net/xdp_sock_drv.h>
>   #include "en.h"
>   #include "en/txrx.h"
>   #include "en_tc.h"
> @@ -434,7 +433,7 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
>   		 * put into the Reuse Ring, because there is no way to return
>   		 * the page to the userspace when the interface goes down.
>   		 */
> -		xsk_buff_free(wi->au->xsk);
> +		mlx5e_xsk_buff_free(wi->au->mxbuf);
>   		return;
>   	}
>   
> @@ -515,7 +514,7 @@ mlx5e_free_rx_mpwqe(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi, bool recycle
>   		 */
>   		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
>   			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
> -				xsk_buff_free(alloc_units[i].xsk);
> +				mlx5e_xsk_buff_free(alloc_units[i].mxbuf);
>   	} else {
>   		for (i = 0; i < rq->mpwqe.pages_per_wqe; i++)
>   			if (no_xdp_xmit || !test_bit(i, wi->xdp_xmit_bitmap))
> 
