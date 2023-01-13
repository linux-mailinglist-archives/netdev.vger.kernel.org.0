Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F30766A4C9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjAMVH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjAMVHj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:07:39 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50FE88A3F;
        Fri, 13 Jan 2023 13:07:33 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id tz12so55153702ejc.9;
        Fri, 13 Jan 2023 13:07:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y799U3pjQRIaLfXmIj4zBC/UY5a59GVSQHE28cjR+UA=;
        b=VecmKqX+y5k2hixW6pxEPzr76Apoh9mdcSNHZ0ExzA057R09OBvj2IH7NJ4H36sJlj
         RooQaRe1ElWCkd1XDbFeczVeRzXz/DlBtU/D6ctcw36lPNEHTLifWM2lNghUyamgDwOI
         vH8/j+UZpftNRLxxX3Znn6WNN0s9JsAYQBV5uU6xWNqgZ9Cq1XowOWjoj7tiIP8JYla4
         RY6SFmTtnQYoVfdw4Jj1iMmF1+SfXFcYEgkrZN/vCBUBzlLqJrQhJbcSRWoPE5DEoP6X
         V1/WOVY2ZhEspVOLU7ulakpGtu4HVKjOjFSYXe35csxqt1pXCkYA3JCnJXaEE8+AOSji
         FIQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y799U3pjQRIaLfXmIj4zBC/UY5a59GVSQHE28cjR+UA=;
        b=XOrOmpG3sBqgtkPntfD5OaJAeDCSBtJs31maYtupIapNsy6nuhZUdiU/Db7iDaMKUt
         k0jVu+ZnK7c+rEG5ZsYmRNVTO6PwXWsuzgkqfX3WzKUwPdlLJa0NCZYA570YyMm/DFwv
         SC8iTFweL+d/efBKSroWcrXYIO50tSKZXmKDIu0sZ2gEd19Bgb46LZwOHxcLmlnrPpjv
         QJfskR/WfIRr1Zbob9B75t1wPgNMmLNpi06xj9BcGBj9k4aRIQNb0Uv3w3F28f4PQiF1
         lw8u+dm414jK3W8IhwbqK47B5U+N5VLmHhj4Cc2ZxmhPe2QcLQSzSNZlprWUeywJ/vHM
         3RRQ==
X-Gm-Message-State: AFqh2krLlYGpHTUQ5jRaT/gJIDwR5lRgjewFodQIX2V/JXg6reUNJKoS
        5KkE54/7G0m6ILety8gCowQqu/seqR7habLD
X-Google-Smtp-Source: AMrXdXuleic1gqc2HKopibM/NzCjJpujxbhMsKeNamt9M3KTvADfZceQtmdZgdmZQ6InNgOOcWf/fw==
X-Received: by 2002:a17:907:a0cc:b0:78d:f454:37a6 with SMTP id hw12-20020a170907a0cc00b0078df45437a6mr74017652ejc.73.1673644052185;
        Fri, 13 Jan 2023 13:07:32 -0800 (PST)
Received: from [192.168.0.105] ([77.126.1.183])
        by smtp.gmail.com with ESMTPSA id j17-20020a17090623f100b00770812e2394sm6786689ejg.160.2023.01.13.13.07.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 13:07:31 -0800 (PST)
Message-ID: <4866ab1d-4d3c-577c-c94f-a51d82ca56a7@gmail.com>
Date:   Fri, 13 Jan 2023 23:07:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Content-Language: en-US
To:     Maxim Mikityanskiy <maxtram95@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220621175402.35327-1-gospo@broadcom.com>
 <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com> <87k0234pd6.fsf@toke.dk>
 <20230103172153.58f231ba@kernel.org> <Y73Ry+nNqOkeZtaj@dragonfly.lan>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <Y73Ry+nNqOkeZtaj@dragonfly.lan>
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



On 10/01/2023 22:59, Maxim Mikityanskiy wrote:
> On Tue, Jan 03, 2023 at 05:21:53PM -0800, Jakub Kicinski wrote:
>> On Tue, 03 Jan 2023 16:19:49 +0100 Toke Høiland-Jørgensen wrote:
>>> Hmm, good question! I don't think we've ever explicitly documented any
>>> assumptions one way or the other. My own mental model has certainly
>>> always assumed the first frag would continue to be the same size as in
>>> non-multi-buf packets.
>>
>> Interesting! :) My mental model was closer to GRO by frags
>> so the linear part would have no data, just headers.
>>
>> A random datapoint is that bpf_xdp_adjust_head() seems
>> to enforce that there is at least ETH_HLEN.
> 
> Also bpf_xdp_frags_increase_tail has the following check:
> 
> 	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
> 		return -EOPNOTSUPP;
> 
> However, I can't seem to find where the `frag_size > frame_sz` part is
> actually used. Maybe this condition can be dropped? Can someone shed
> some light?
> 
> BTW, Tariq, we seem to have missed setting frag_size to a non-zero
> value.

Hey Maxim,
Indeed. We use xdp_rxq_info_reg, it passes 0 as frag_size.

> Could you check that increasing the tail indeed doesn't work on
> fragmented packets on mlx5e? I can send a oneliner to fix that.

I can test early next week, and update.
