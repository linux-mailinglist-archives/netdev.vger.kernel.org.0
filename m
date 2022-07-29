Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399F758569F
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 23:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239452AbiG2Vmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 17:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239394AbiG2Vmn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 17:42:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4268C3EC;
        Fri, 29 Jul 2022 14:42:42 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id o3so5690447ple.5;
        Fri, 29 Jul 2022 14:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=U9ERdoGkMZvzk0d296BdeQvJN+IjPfb6o7FkoQLdR/M=;
        b=fdotl0qjEyBLviXLZ7UQZzfRFUehs5ZVx2Sw1z8xatQbb40IxuBdUylQNU9hajyT4Y
         rIC8eF+3v0t9nHDrZsXvRIZSSlRrmXmlPIsJHI0obVYKvZTghy1+4mTeHqt4cU9VYp3+
         WmQgsxV4lCHR6LnyWIJdAst/XhE24O/DNLGdxA94DeIeIjNa7y02U8hMy8bORaimutzI
         x4t2DwXVj99kFNxp9CXcH6AX+nq0iVI1WoMPcFbVWrLAFnLwtCyhGaR1WW7JEwFhgt/B
         AZrdqSiIbQ0fi8PpOi9yMRdgTYpUnKMfA1Zx1zuMK9SmFDVIrbk/tuat2jBRCLGrRutM
         qiOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=U9ERdoGkMZvzk0d296BdeQvJN+IjPfb6o7FkoQLdR/M=;
        b=14yaJ3xb5RVh4DXiYEHV3vPCp0qmAUMQ1dfRnxkPye2JHnn3yDB+OwI+GzUQ610RDR
         /23h7oJUbStEHMus8eoifL8zv4o14HL2vnrLhFz+Kqg3du6KoaJRkqZC+GDlaHNymLT5
         S4A7wsQajcNH6S2wheRxv6tRXbTBq4azZAGGwqGS35SeWFuY9f0L560loSy5Vhk3CzUy
         pNaiB4Qv4K4o+Xf2VXkZB57QyxxWzxOnYKS166b+I5nP7rlo5+MdjTYVM00v21Cv9x3f
         8SM3kZZJPyKWThqavlfM6av1s6bkWnmeI5GexpGVrcBpXLtq7bI6sggrzvtMVoCtGDEP
         dM/w==
X-Gm-Message-State: ACgBeo0tbSu+joOPP7609nDLLCWwWAptKuCgY+458hIgbtvoUZlL6mB1
        R0rvU343R1PBYOjF3a7bXCI=
X-Google-Smtp-Source: AA6agR5NV2m98QvIUu5Am0bVzQka0nv0zoEyUght5ByGJnRE3IVJPC0yfV3R/cqdS5uzjXRMCfEPOw==
X-Received: by 2002:a17:90b:4b4d:b0:1ef:bff5:de4f with SMTP id mi13-20020a17090b4b4d00b001efbff5de4fmr6834388pjb.120.1659130962281;
        Fri, 29 Jul 2022 14:42:42 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d63-20020a636842000000b00412a708f38asm3010053pgc.35.2022.07.29.14.42.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Jul 2022 14:42:41 -0700 (PDT)
Message-ID: <55aafcc6-e558-dffb-babb-d3bacea615e8@gmail.com>
Date:   Fri, 29 Jul 2022 14:42:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [net-next PATCH v5 00/14] net: dsa: qca8k: code split for qca8k
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, gregkh@linuxfoundation.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20220727113523.19742-1-ansuelsmth@gmail.com>
 <165907261973.17632.10185478057101306176.git-patchwork-notify@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <165907261973.17632.10185478057101306176.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8
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

On 7/28/22 22:30, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Wed, 27 Jul 2022 13:35:09 +0200 you wrote:
>> This is needed ad ipq4019 SoC have an internal switch that is
>> based on qca8k with very minor changes. The general function is equal.
>>
>> Because of this we split the driver to common and specific code.
>>
>> As the common function needs to be moved to a different file to be
>> reused, we had to convert every remaining user of qca8k_read/write/rmw
>> to regmap variant.
>> We had also to generilized the special handling for the ethtool_stats
>> function that makes use of the autocast mib. (ipq4019 will have a
>> different tagger and use mmio so it could be quicker to use mmio instead
>> of automib feature)
>> And we had to convert the regmap read/write to bulk implementation to
>> drop the special function that makes use of it. This will be compatible
>> with ipq4019 and at the same time permits normal switch to use the eth
>> mgmt way to send the entire ATU table read/write in one go.
>>
>> [...]
> 
> Here is the summary with links:
>   - [net-next,v5,01/14] net: dsa: qca8k: cache match data to speed up access
>     https://git.kernel.org/netdev/net-next/c/3bb0844e7bcd
>   - [net-next,v5,02/14] net: dsa: qca8k: make mib autocast feature optional
>     https://git.kernel.org/netdev/net-next/c/533c64bca62a
>   - [net-next,v5,03/14] net: dsa: qca8k: move mib struct to common code
>     https://git.kernel.org/netdev/net-next/c/027152b83043
>   - [net-next,v5,04/14] net: dsa: qca8k: move qca8k read/write/rmw and reg table to common code
>     https://git.kernel.org/netdev/net-next/c/d5f901eab2e9
>   - [net-next,v5,05/14] net: dsa: qca8k: move qca8k bulk read/write helper to common code
>     https://git.kernel.org/netdev/net-next/c/910746444313
>   - [net-next,v5,06/14] net: dsa: qca8k: move mib init function to common code
>     https://git.kernel.org/netdev/net-next/c/fce1ec0c4e2d
>   - [net-next,v5,07/14] net: dsa: qca8k: move port set status/eee/ethtool stats function to common code
>     https://git.kernel.org/netdev/net-next/c/472fcea160f2
>   - [net-next,v5,08/14] net: dsa: qca8k: move bridge functions to common code
>     https://git.kernel.org/netdev/net-next/c/fd3cae2f3ac1
>   - [net-next,v5,09/14] net: dsa: qca8k: move set age/MTU/port enable/disable functions to common code
>     https://git.kernel.org/netdev/net-next/c/b3a302b171f7
>   - [net-next,v5,10/14] net: dsa: qca8k: move port FDB/MDB function to common code
>     https://git.kernel.org/netdev/net-next/c/2e5bd96eea86
>   - [net-next,v5,11/14] net: dsa: qca8k: move port mirror functions to common code
>     https://git.kernel.org/netdev/net-next/c/742d37a84d3f
>   - [net-next,v5,12/14] net: dsa: qca8k: move port VLAN functions to common code
>     https://git.kernel.org/netdev/net-next/c/c5290f636624
>   - [net-next,v5,13/14] net: dsa: qca8k: move port LAG functions to common code
>     https://git.kernel.org/netdev/net-next/c/e9bbf019af44
>   - [net-next,v5,14/14] net: dsa: qca8k: move read_switch_id function to common code
>     https://git.kernel.org/netdev/net-next/c/9d1bcb1f293f
> 
> You are awesome, thank you!

Oh well, at least I reviewed the patches :)
-- 
Florian
