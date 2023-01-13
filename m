Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8531466A4A9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 21:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjAMU53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 15:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231388AbjAMU4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 15:56:43 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFDA8F8FF;
        Fri, 13 Jan 2023 12:55:20 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id cf18so48686320ejb.5;
        Fri, 13 Jan 2023 12:55:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F7yrGtMitcTjHgK1Vg0nmkRC811zM1e09Uti8Ps2/ts=;
        b=g3zWrVVCk/tjJRJAFTQ7V3zcPvxjCGWREwkoTudKG1luqpaOe7uO5YuGEX43ZC4sHy
         jddDURfxiDPvwTvh69TR7IN4kjmtfwKryAZWnyEq1Gy2WdhYIupazBoAqJZhXSCmW2Jq
         Aea2Fd55zPV4SUU65shwDF+BTMjE/mvo/+k6QOJ7abZrlR08akIXBGZjM8iGgb0kJhh/
         39NU/5isjvVKt9NJLqeC2HVspyn1mOJV58r0+DBmgkvqWTuCzJSQODVH4+esx8Gpbd5K
         1qthyw7ak6VGF+c4+LmVRwkgIhxE6KoGRABQyhttuDv5m8CA6+PqaOUVtn8WG5xcjFUA
         prhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F7yrGtMitcTjHgK1Vg0nmkRC811zM1e09Uti8Ps2/ts=;
        b=PlhKw7xAYQIsaIlnYd89NAmQ2Xm7LDngEn/Z3K61jttHya+nWUpkkIlHgSfGkl++YK
         FWnt7oz5+9xIhR5Q6NjUTaw3ZBe0MuNscb0WB4NYHeEqVQJmbRPkll6ZSO0i0tyQcKE4
         Dsi7ZKucPU98KXes+dhqMid6ne7cd3MPEXc2VeoBAJzTx6q5ksRGXdOMX7MKNtTfvaOe
         q7M+QQFdAFRATHg54Sb5xEhrgF8ljkqMPIoAhMrTzgxB+iENcwozlHZtdlTXvAKELTzF
         77qJ4F0lwWgo2ViNPVK9byT73XHih4Hh5vSJ7OuCDLxB/wguyK1iPc75XMIQkVc5FrB7
         LGjQ==
X-Gm-Message-State: AFqh2koldCmpUpSqtyY+Q64M2npi+HSYSsi5L2ZwtkpyNGEbZoJzqE8h
        6EZkpyDYc0s7ejsbIGTQklE=
X-Google-Smtp-Source: AMrXdXvQXUgZx98X9zdEOuZyzYBVGGagkseoDszBNsyZ2Fmf0zsAnjnsZk/sX5qVKpZNXeXPaMma0Q==
X-Received: by 2002:a17:907:a682:b0:84d:430a:5e63 with SMTP id vv2-20020a170907a68200b0084d430a5e63mr20048320ejc.27.1673643319416;
        Fri, 13 Jan 2023 12:55:19 -0800 (PST)
Received: from [192.168.0.105] ([77.126.1.183])
        by smtp.gmail.com with ESMTPSA id 15-20020a170906310f00b00738795e7d9bsm8818859ejx.2.2023.01.13.12.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 12:55:18 -0800 (PST)
Message-ID: <2f18629f-60e0-12c0-cb6b-84f81ed61533@gmail.com>
Date:   Fri, 13 Jan 2023 22:55:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce
 wrapper for xdp_buff
Content-Language: en-US
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
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
 <CAKH8qBvBsAj0s36=xHKz3XN5Nq1bDcEP1AOsnf9+Sgtm5wWUyQ@mail.gmail.com>
 <87edrzfkt5.fsf@toke.dk>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <87edrzfkt5.fsf@toke.dk>
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



On 13/01/2023 0:29, Toke Høiland-Jørgensen wrote:
> Stanislav Fomichev <sdf@google.com> writes:
> 
>> On Thu, Jan 12, 2023 at 1:55 PM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>>
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
>>>>>>>    drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>>>>>>>    .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>>>>>>>    .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>>>>>>>    .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>>>>>>>    .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++----------
>>>>>>>    5 files changed, 50 insertions(+), 43 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>> index 2d77fb8a8a01..af663978d1b4 100644
>>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>>>>>>> @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>>>>>>>    union mlx5e_alloc_unit {
>>>>>>>        struct page *page;
>>>>>>>        struct xdp_buff *xsk;
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
>>
>> Seems more invasive? I don't care much tbf, but what's wrong with
>> keeping 'xdp_buff xsk' member and use it consistently?
> 
> Yeah, it's more invasive, but it's also more consistent with the non-xsk
> path where every usage of struct xdp_buff is replaced with the wrapping
> struct?
> 
> Both will work, I suppose (in fact I think the resulting code will be
> more or less identical), so it's more a matter of which one is easier to
> read and where we put the type-safety-breaking casts.
> 
> I can live with either one (just note you'll have to move the
> 'mxbuf->rq' initialisation next to the one for mxbuf->cqe for yours, but
> that's probably fine too). Let's see which way Tariq prefers...
> 
> -Toke
> 

I think both of the above will still have issues. See my comments in the 
email that I've just sent.
