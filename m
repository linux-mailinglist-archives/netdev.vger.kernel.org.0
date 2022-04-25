Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB9A50E9E1
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 22:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245106AbiDYUHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 16:07:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232591AbiDYUHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 16:07:07 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5F910783E
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 13:04:02 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id u5so3508002pjr.5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 13:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+BQJuR3jB5z1g3mLkmmAzi+pICUbBBnyVvV45O5HMLs=;
        b=llIW1pQjd8r5pNF5OmD6jFzDJC8BtO9a4mmOBVqXWM1Q1T2tvi8kMdnEBhSGrIaSZ4
         tckFfI+QpLPCCBaZ0FXumLq5ZY1KaBHrxmxvSH4kGnxBNV7fl4b2JzRykBtrPFhusVEc
         LJRctYnS4bdGvtyKpBzcg0fDtjqovrgMXBQmfPcQ+n07Bsik23M4A9xrIQ53qbvm9ShG
         7BY1ku1GFSs3Yf9B4ztiO/LgRvISjRl3HiTe3j59J1ZX/UT65jjjgRNB8gs4Lvd91w9a
         OsRT+Ms1HBv0tN3djNmqZI9FENUlySp6xb3kQHZBbMeJMdFVUkVBpI1MnTOQR7ppeFiy
         4XUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+BQJuR3jB5z1g3mLkmmAzi+pICUbBBnyVvV45O5HMLs=;
        b=IJ78KG5hYq3ICQgtxgb5hu1FM1ve+xOle0leW0SFsgc+R20XnI9e4Y9Sdj2GPH1DZO
         p+kQ4XYi4cdwrR74ksaUA//H9QQUAbh2i8gYf+B3+Y91UbupQaoWqfZHnZ+ApQ0kk0Pa
         e4CyHWpH4nlUjQVVEV+SJeSYYzL0qk6YJo4OkSYsDospXxarb444ziHyMRvDgfMqDM0H
         ja7/BG2yX8IJB8uzshpZ7GoA7R9Mn5k1APzN3rZ6MU6xiR4i2prFfzyDoqd3L5RpYMGk
         4zt+1NwW+uidxACtJKWDmeWNse2kAB66oR35UiZit0jcR/9rhV9HJ/FrkT3y/3IjwIbo
         IJaQ==
X-Gm-Message-State: AOAM5325TllYlmr2EsMoN6pvivYL0LdILr7KwryXwGkSeRofGTUpPjsX
        hC5UVlRElwpIQFAtznynQKg=
X-Google-Smtp-Source: ABdhPJwfCLX3PzTv2am7x2ndrYv8xL9SbboBP+eMRs5kFEIfdx82x1XwEmPpBzezCS5cZubdB/KQ0g==
X-Received: by 2002:a17:903:4052:b0:155:fc0b:48fb with SMTP id n18-20020a170903405200b00155fc0b48fbmr19583650pla.27.1650917042439;
        Mon, 25 Apr 2022 13:04:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t9-20020a63b249000000b003aae4f10d86sm8023769pgo.94.2022.04.25.13.04.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 13:04:01 -0700 (PDT)
Message-ID: <d4558414-f58f-2a51-5957-9e9454f3cad4@gmail.com>
Date:   Mon, 25 Apr 2022 13:03:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next RESEND] net: bcmgenet: hide status block before
 TX timestamping
Content-Language: en-US
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, opendmb@gmail.com,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, kuba@kernel.org
References: <20220424165307.591145-1-jonathan.lemon@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220424165307.591145-1-jonathan.lemon@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/22 09:53, Jonathan Lemon wrote:
> The hardware checksum offloading requires use of a transmit
> status block inserted before the outgoing frame data, this was
> updated in '9a9ba2a4aaaa ("net: bcmgenet: always enable status blocks")'
> 
> However, skb_tx_timestamp() assumes that it is passed a raw frame
> and PTP parsing chokes on this status block.
> 
> Fix this by calling __skb_pull(), which hides the TSB before calling
> skb_tx_timestamp(), so an outgoing PTP packet is parsed correctly.
> 
> As the data in the skb has already been set up for DMA, and the
> dma_unmap_* calls use a separately stored address, there is no
> no effective change in the data transmission.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Without restructuring the way we do time-stamping within the driver to 
be before bcmgenet_insert_tsb() this appears to get you what you want 
without being too intrusive. I would slap a:

Fixes: d03825fba459 ("net: bcmgenet: add skb_tx_timestamp call")

since this is a bug fix that should be fixed back when this was added. 
It was only made recently problematic by default with the enabling of 
the transmit checksum offload which implicit forces the use of a 64 byte 
transmit status block.

With that said:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Now, if we wanted to avoid playing tricks with the sk_buff, we could 
place skb_tx_timestamp() earlier in the transmit path with the risk that 
we are no longer as close as possible from hitting the DMA, and subject 
to DMA mapping or allocation failures. Food for thought.

Thanks!
-- 
Florian
