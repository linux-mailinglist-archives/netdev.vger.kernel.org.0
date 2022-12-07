Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4FF64614B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 19:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLGSx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 13:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLGSx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 13:53:56 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F8B49B42
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:53:55 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f7so26225690edc.6
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 10:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pGpz+Hdu80xBR9hqsOFKdws2bU8+HwauioGzpq47VV8=;
        b=pHyMqA4g/DBbLagxsO6LAub/N04bKJlv+M/6McQ2Jyax1Pl6nvyspC336mfcTgPlWl
         7U2p4sEHMeCerRZczy4C9V3zgVsKoNT9pviwo9x2jYisTJGUY2FzUwoxw5qxdOXlhb+X
         /F2v374LPKP1pKGHOldbDUkROQQiya5nPqSczQf+4oRByaG7jceAy6wYSMfFFa7Pit38
         k0DarmpaAtcKTKeEjv6qKJqGBVsN1lmjYHs3RZKtCdZRKrsycbZ8i20pKpvkFo/oSNW/
         oIunNNFceE3DUaGAO6KpyA5AgRZcqhnS1EXdHWH0az/9ThwJMJGAbCTP6tEztESTlClY
         oP/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pGpz+Hdu80xBR9hqsOFKdws2bU8+HwauioGzpq47VV8=;
        b=hhq9bpC46CghFiMFwpXxDSQlafVb/iwopZ14tER3EukEuy+CNDwj56tHE8ZAMK2K0S
         ZbhwNWgOWfnpWmf1w42s87n4EQe3AF9WrVxJT8qEeWidJpQjrxwjvqxJrYoD+7J/jlYP
         0bfx4xhKKERqo0tiNy/Iyu/8+Of403TnWen21WhHM/JB39sf+cE10Y8SfNWpEqwTmcHI
         5KldbC5HJG78hTU3vzY0hdbi9Olw+xFLg5BoAPF3Iv/4B6Sa8CrGl8hyqJSQQJQl3i6n
         Rvj4ALu6qBq2qhXKNT92ciPYoMw23ZWNwzCSA5YrxEPRi9/JgY2pU8/SsmyTeNvesItZ
         2MfA==
X-Gm-Message-State: ANoB5pnkKdxEwGrQfQDr23qqxKQKXLRd1tHH/3JelxFshFkP26rdfR1w
        wZuDkRB6XdrM/yhzEt1BEVo=
X-Google-Smtp-Source: AA0mqf743J8BOj2NlWY6idkS2IsT0ZAA1McokeBg681OvuObjbFqIOmHViisxhqqaK3x0vw0IG8t1w==
X-Received: by 2002:aa7:d68d:0:b0:46a:e912:fbcd with SMTP id d13-20020aa7d68d000000b0046ae912fbcdmr46016309edr.378.1670439234003;
        Wed, 07 Dec 2022 10:53:54 -0800 (PST)
Received: from [192.168.0.105] ([77.126.19.155])
        by smtp.gmail.com with ESMTPSA id d18-20020a50fb12000000b004588ef795easm2552170edq.34.2022.12.07.10.53.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 10:53:53 -0800 (PST)
Message-ID: <7beeecae-8d6f-d4c2-db43-ddf468469ca0@gmail.com>
Date:   Wed, 7 Dec 2022 20:53:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 net-next 2/3] net/mlx4: MLX4_TX_BOUNCE_BUFFER_SIZE
 depends on MAX_SKB_FRAGS
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Wei Wang <weiwan@google.com>
References: <20221207141237.2575012-1-edumazet@google.com>
 <20221207141237.2575012-3-edumazet@google.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20221207141237.2575012-3-edumazet@google.com>
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



On 12/7/2022 4:12 PM, Eric Dumazet wrote:
> Google production kernel has increased MAX_SKB_FRAGS to 45
> for BIG-TCP rollout.
> 
> Unfortunately mlx4 TX bounce buffer is not big enough whenever
> an skb has up to 45 page fragments.
> 
> This can happen often with TCP TX zero copy, as one frag usually
> holds 4096 bytes of payload (order-0 page).
> 
> Tested:
>   Kernel built with MAX_SKB_FRAGS=45
>   ip link set dev eth0 gso_max_size 185000
>   netperf -t TCP_SENDFILE
> 
> I made sure that "ethtool -G eth0 tx 64" was properly working,
> ring->full_size being set to 15.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: Wei Wang <weiwan@google.com>
> Cc: Tariq Toukan <tariqt@nvidia.com>

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

