Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3706066AF92
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 08:02:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjAOG7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 01:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjAOG7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 01:59:22 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B4478A69;
        Sat, 14 Jan 2023 22:59:20 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mp20so14702034ejc.7;
        Sat, 14 Jan 2023 22:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pxptz55Cwqa7TpAzHO0z5FDEjV2lumpg9wAZM72elNg=;
        b=JJLLEQgRY8DYBbiWq2xF5D9kdSxHL0qfjS5P89tvbL5voWDJTqILYtQBfZ0c2TC38Q
         ewlZql/yKF2SCoUBhwX0MQBJFzPUIfWXrByIn+PfqJgAo4XW5gWr6PWJcDbXSftB6EvB
         0AH24918SLfEnKtzAQd17nkexOYFfpfARbarIql48bB0zXOqKCASiEjQvT+u6j+lYnMv
         Ne3dKlMv63QtDIuV5Uk8jXO6qibeWbloLXqczDjZ/MyJwS1sQ336aSBzwkMWg42zfxYy
         qGLNPI47DK84vLZhGpz/qIvKntQOBMRphV2znK4wpmPU5GHqBlfcZ/C4l5DY0CpUpzW+
         EBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pxptz55Cwqa7TpAzHO0z5FDEjV2lumpg9wAZM72elNg=;
        b=vlJPRog0I3xM0xA7ewTij3zW4NogDIg5IURjbLb3JVUXMYoMZtxMLUjuiYgkADI2fG
         ViiHGQ+OATJnaA0yh7DV8McsX+iHJJnS0Y1jIXnKb8uSZg0YQ3zJW30819Fkhe2o57Ez
         yFL8reLimhPpPfI8npFk9XOpFZqq7WKNVdniOQoxXaHKL5Ou3Pi8xwniOkR+2VF3eWUh
         MDyQsYAmjK+bDKAxt1CJ3vlM7bJC/Rj5Jw2al9OyUNLwCLaH0BfseEccvEEhA+Girdgh
         qAhyiAv8q1ryNPCQE6X/z0GZ1Y+wUG3JK7ZUqrJIudGZuo/a525zh+MZQ6CJuRnNxXL8
         nhCw==
X-Gm-Message-State: AFqh2kpLpME4sqa1eeSYbUiZfUugSRSORMtfkLNEOeVA9FrGTG94XLDY
        gtR/mVWELHYYGn5YpskL33Y=
X-Google-Smtp-Source: AMrXdXs/4YNUrETD4uk5muY15beC2zfbcOD5E6EY0AZhx7iryPCNpstuSanYkngaPdSTXzRnPHFftw==
X-Received: by 2002:a17:906:88b:b0:850:52f8:5ca9 with SMTP id n11-20020a170906088b00b0085052f85ca9mr21257815eje.28.1673765958735;
        Sat, 14 Jan 2023 22:59:18 -0800 (PST)
Received: from [192.168.0.103] ([77.126.105.148])
        by smtp.gmail.com with ESMTPSA id kx1-20020a170907774100b0084d368b1628sm9249006ejc.40.2023.01.14.22.59.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Jan 2023 22:59:18 -0800 (PST)
Message-ID: <493fd525-10b3-c136-8458-a1560ed2cdcb@gmail.com>
Date:   Sun, 15 Jan 2023 08:59:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce
 wrapper for xdp_buff
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
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
 <d83f2193-3fb9-e30f-cfb0-f1098f039b67@gmail.com> <87358ef7e8.fsf@toke.dk>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <87358ef7e8.fsf@toke.dk>
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



On 13/01/2023 23:31, Toke Høiland-Jørgensen wrote:
> Tariq Toukan <ttoukan.linux@gmail.com> writes:
> 
>> On 12/01/2023 23:55, Toke Høiland-Jørgensen wrote:
>>> Toke Høiland-Jørgensen <toke@redhat.com> writes:
>>>
>>>> Stanislav Fomichev <sdf@google.com> writes:
>>>>
>>>>> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.com> wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
>>>>>>> From: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>>
>>>>>>> Preparation for implementing HW metadata kfuncs. No functional change.
>>>>>>>
>>>>>>> Cc: Tariq Toukan <tariqt@nvidia.com>
>>>>>>> Cc: Saeed Mahameed <saeedm@nvidia.com>
>>>>>>> Cc: John Fastabend <john.fastabend@gmail.com>
>>>>>>> Cc: David Ahern <dsahern@gmail.com>
>>>>>>> Cc: Martin KaFai Lau <martin.lau@linux.dev>
>>>>>>> Cc: Jakub Kicinski <kuba@kernel.org>
>>>>>>> Cc: Willem de Bruijn <willemb@google.com>
>>>>>>> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>>>>>>> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>>>>>>> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>>>>>>> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>>>>>>> Cc: Maryam Tahhan <mtahhan@redhat.com>
>>>>>>> Cc: xdp-hints@xdp-project.net
>>>>>>> Cc: netdev@vger.kernel.org
>>>>>>> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
>>>>>>> Signed-off-by: Stanislav Fomichev <sdf@google.com>
>>>>>>> ---
>>>>>>>     drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>>>>>>     .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>>>>>>>     .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>>>>>>>     .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>>>>>>>     .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++----------
>>>>>>>     5 files changed, 50 insertions(+), 43 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>> index 2d77fb8a8a01..af663978d1b4 100644
>>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>> @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>>>>>>>     union mlx5e_alloc_unit {
>>>>>>>         struct page *page;
>>>>>>>         struct xdp_buff *xsk;
>>>>>>> +     struct mlx5e_xdp_buff *mxbuf;
>>>>>>
>>>>>> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf and
>>>>>> alloc_units[page_idx].xsk, while both fields share the memory of a union.
>>>>>>
>>>>>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
>>>>>> need to change the existing xsk field type from struct xdp_buff *xsk
>>>>>> into struct mlx5e_xdp_buff *xsk and align the usage.
>>>>>
>>>>> Hmmm, good point. I'm actually not sure how it works currently.
>>>>> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
>>>>> am I missing something?
>>>>
>>>> It's initialised piecemeal in different places; but yeah, we're mixing
>>>> things a bit...
>>>>
>>>>> I'm thinking about something like this:
>>>>>
>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>> index af663978d1b4..2d77fb8a8a01 100644
>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>> @@ -469,7 +469,6 @@ struct mlx5e_txqsq {
>>>>>    union mlx5e_alloc_unit {
>>>>>           struct page *page;
>>>>>           struct xdp_buff *xsk;
>>>>> -       struct mlx5e_xdp_buff *mxbuf;
>>>>>    };
>>>>
>>>> Hmm, for consistency with the non-XSK path we should rather go the other
>>>> direction and lose the xsk member, moving everything to mxbuf? Let me
>>>> give that a shot...
>>>
>>> Something like the below?
>>>
>>> -Toke
>>>
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> index 6de02d8aeab8..cb9cdb6421c5 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>> @@ -468,7 +468,6 @@ struct mlx5e_txqsq {
>>>    
>>>    union mlx5e_alloc_unit {
>>>    	struct page *page;
>>> -	struct xdp_buff *xsk;
>>>    	struct mlx5e_xdp_buff *mxbuf;
>>>    };
>>>    
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
>>> index cb568c62aba0..95694a25ec31 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
>>> @@ -33,6 +33,7 @@
>>>    #define __MLX5_EN_XDP_H__
>>>    
>>>    #include <linux/indirect_call_wrapper.h>
>>> +#include <net/xdp_sock_drv.h>
>>>    
>>>    #include "en.h"
>>>    #include "en/txrx.h"
>>> @@ -112,6 +113,21 @@ static inline void mlx5e_xmit_xdp_doorbell(struct mlx5e_xdpsq *sq)
>>>    	}
>>>    }
>>>    
>>> +static inline struct mlx5e_xdp_buff *mlx5e_xsk_buff_alloc(struct xsk_buff_pool *pool)
>>> +{
>>> +	return (struct mlx5e_xdp_buff *)xsk_buff_alloc(pool);
>>
>> What about the space needed for the rq / cqe fields? xsk_buff_alloc
>> won't allocate it.
> 
> It will! See patch 14 in the series that adds a 'cb' field to
> xdp_buff_xsk, meaning there's actually space after the xdp_buff struct
> being allocated by the xsk_buff_alloc API. The XSK_CHECK_PRIV_TYPE macro
> call is there to ensure the cb field is big enough for the struct we're
> casting to in the driver.
> 

Oh okay, got it.

>>> +}
>>> +
>>> +static inline void mlx5e_xsk_buff_free(struct mlx5e_xdp_buff *mxbuf)
>>> +{
>>> +	xsk_buff_free(&mxbuf->xdp);
>>> +}
>>> +
>>> +static inline dma_addr_t mlx5e_xsk_buff_xdp_get_frame_dma(struct mlx5e_xdp_buff *mxbuf)
>>> +{
>>> +	return xsk_buff_xdp_get_frame_dma(&mxbuf->xdp);
>>> +}
>>> +
>>>    /* Enable inline WQEs to shift some load from a congested HCA (HW) to
>>>     * a less congested cpu (SW).
>>>     */
>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>>> index 8bf3029abd3c..1f166dbb7f22 100644
>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
>>> @@ -3,7 +3,6 @@
>>>    
>>>    #include "rx.h"
>>>    #include "en/xdp.h"
>>> -#include <net/xdp_sock_drv.h>
>>>    #include <linux/filter.h>
>>>    
>>>    /* RX data path */
>>> @@ -21,7 +20,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
>>>    	if (unlikely(!xsk_buff_can_alloc(rq->xsk_pool, rq->mpwqe.pages_per_wqe)))
>>>    		goto err;
>>>    
>>> -	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) != sizeof(wi->alloc_units[0].xsk));
>>> +	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) != sizeof(wi->alloc_units[0].mxbuf));
>>>    	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
>>>    	batch = xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->alloc_units,
>>>    				     rq->mpwqe.pages_per_wqe);
>>
>> This batching API gets broken as well...
>> xsk_buff_alloc_batch fills an array of struct xdp_buff pointers, it
>> cannot correctly act on the array of struct mlx5e_xdp_buff, as it
>> contains additional fields.
> 
> See above for why this does, in fact, work. I agree it's not totally
> obvious, and in any case there's going to be a point where the cast
> happens where type safety will break, which is what I was alluding to in
> my reply to Stanislav.
> 
> I guess we could try to rework the API in xdp_sock_drv.h to make this
> more obvious instead of using the casting driver-specific wrappers I
> suggested here. Or we could go with Stanislav's suggestion of keeping
> allocation etc using xdp_buff and only casting to mlx5e_xdp_buff in the
> function where it's used; then we can keep the casting localised to that
> function, and put a comment there explaining why it works?
> 

Stanislav's proposal LGTM.
Let's keep the casting localised, and make sure there's a comment there.

>> Maybe letting mlx5e_xdp_buff point to its struct xdp_buff (instead of
>> wrapping it) will solve the problems here, then we'll loop over the
>> xdp_buff * array and copy the pointers into the struct mlx5e_xdp_buff *
>> array.
>> Need to give it deeper thoughts...
>>
>> struct mlx5e_xdp_buff {
>> 	struct xdp_buff *xdp;
>> 	struct mlx5_cqe64 *cqe;
>> 	struct mlx5e_rq *rq;
>> };
> 
> This was actually my original proposal; we discussed this back on v2 of
> this patch series. People generally felt that the 'cb' field approach
> (originally suggested by Jakub) was better.

I agree.

> See the discussion starting
> from here:
> 
> https://lore.kernel.org/r/20221123111431.7b54668e@kernel.org
> 
> -Toke
> 

