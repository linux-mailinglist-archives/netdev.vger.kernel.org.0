Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46555E7B42
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 15:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbiIWNCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 09:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiIWNCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 09:02:31 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 774AD13A060
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:02:25 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id g20so13373323ljg.7
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 06:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=eSh9lQlxR1gFInxcwx9nPyD8UC9VTqVGCwfXX2VWpoE=;
        b=UovPoYoZTR7j58R4ZiTzpBg6X75Fbh4OHuNXCuAKYGWsStit1G6qDwPyinFxKZA2CM
         Ok/j44lXFa9jNi9/3htbd5kAY1WeBWtOWXXXxCX9f6/k78Mor5U+zq/ez/XpWWIxTiTW
         gBgy1WgeFwegshL4yZhiQ+SwB/kveGJxscwhywriEQHzAhqDa3fb6BBK1w4ZOEZklf0S
         zfb3crXHhigd9JIp+SSAHAZ66Kg1Y+hC6kpFZsq1mDjgNOneL5r/1GSrSPa+5LE3LsNg
         Cq/FSHNiedH6MwKNQEqy0TXjSFWZgTchQOiWXva5l9+gj7IRJoT9edwGmmCzhTTkqagm
         l5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eSh9lQlxR1gFInxcwx9nPyD8UC9VTqVGCwfXX2VWpoE=;
        b=7hyh5jZdir3M8jWOjv+2zUkUBNY7xK07ttZYgw0Q43qRRFx+NIIRPuBskqvwrLBx7S
         MnriG8pOS5GHexVpPN4Cl85xzOod7Ur9arVSU3eZ0pLHFdEw5gQaFMObXGdU4VjPyJuD
         +6AKTMpM1S1qnbNVds9JTm7+uju75P/KWmTG4UJssPka8pd85TAHR7b5vKNFfsP7jMzS
         nNEVZmCJ9AqTN6dv1NWWGTAtFFm2Ejg+Kk7Fhmejpt0l4Rx1pqlUmaXcvAWbUDKk5WQp
         yaWMi3rxdGTLDXwywf6ah1jWZRcUT5gNduBDd4aIFs5timansdRAbcHuWPUdV5Vz/7cq
         LeaA==
X-Gm-Message-State: ACrzQf1jDvOq7J0KURoidd7USbg1amVRl0YVFiVFrBYcf0QuMAvkJ3vN
        k/sy/2xbNG6j1qJs8EJN2DMVOg==
X-Google-Smtp-Source: AMsMyM7qVPPrkR+mwYzG7QUbaiI4bu86AdzgPZgHy75KHEJknXL0Rg1SXgR20+plVTkV408sVjI3LQ==
X-Received: by 2002:a2e:984a:0:b0:26a:d00a:790f with SMTP id e10-20020a2e984a000000b0026ad00a790fmr2932714ljj.358.1663938142995;
        Fri, 23 Sep 2022 06:02:22 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id h6-20020a19ca46000000b0048b26d4bb64sm1450938lfj.40.2022.09.23.06.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 06:02:22 -0700 (PDT)
Message-ID: <3022c139-d25c-4fcf-33d5-1baf8aa9e61e@linaro.org>
Date:   Fri, 23 Sep 2022 15:02:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v4 net-next 00/10] dt-bindings and mt7621 devicetree
 changes
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     robh+dt@kernel.org, matthias.bgg@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, tsbogend@alpha.franken.de,
        gregkh@linuxfoundation.org, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, dqfext@gmail.com,
        sergio.paracuellos@gmail.com, erkin.bozoglu@xeront.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20220920172556.16557-1-arinc.unal@arinc9.com>
 <166392781809.11802.14314301597128820257.git-patchwork-notify@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <166392781809.11802.14314301597128820257.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/09/2022 12:10, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Tue, 20 Sep 2022 20:25:46 +0300 you wrote:
>> Hello there!
>>
>> This patch series removes old MediaTek bindings, improves mediatek,mt7530
>> and mt7621 memory controller bindings and improves mt7621 DTs.
>>
>> v4:
>> - Keep memory-controller node name.
>> - Change syscon to memory-controller on mt7621.dtsi.
>>
>> [...]
> 
> Here is the summary with links:
>   - [v4,net-next,01/10] dt-bindings: net: drop old mediatek bindings
>     https://git.kernel.org/netdev/net-next/c/e8619b05870d
>   - [v4,net-next,02/10] dt-bindings: net: dsa: mediatek,mt7530: change mt7530 switch address
>     https://git.kernel.org/netdev/net-next/c/3737c6aaf22d
>   - [v4,net-next,03/10] dt-bindings: net: dsa: mediatek,mt7530: expand gpio-controller description
>     https://git.kernel.org/netdev/net-next/c/0fbca84eea37
>   - [v4,net-next,04/10] dt-bindings: memory: mt7621: add syscon as compatible string
>     https://git.kernel.org/netdev/net-next/c/862b19b7d4a1
>   - [v4,net-next,05/10] mips: dts: ralink: mt7621: fix some dtc warnings
>     https://git.kernel.org/netdev/net-next/c/5ae75a1ae5c9
>   - [v4,net-next,06/10] mips: dts: ralink: mt7621: remove interrupt-parent from switch node
>     https://git.kernel.org/netdev/net-next/c/08b9eaf454ee
>   - [v4,net-next,07/10] mips: dts: ralink: mt7621: change phy-mode of gmac1 to rgmii
>     https://git.kernel.org/netdev/net-next/c/97721e84f546
>   - [v4,net-next,08/10] mips: dts: ralink: mt7621: change mt7530 switch address
>     https://git.kernel.org/netdev/net-next/c/2b653a373b41
>   - [v4,net-next,09/10] mips: dts: ralink: mt7621: fix external phy on GB-PC2
>     https://git.kernel.org/netdev/net-next/c/247825f991b3
>   - [v4,net-next,10/10] mips: dts: ralink: mt7621: add GB-PC2 LEDs
>     https://git.kernel.org/netdev/net-next/c/394c3032fe0e


DTS patches should not go via network tree... We keep them separate on
purpose - to split hardware description from OS-specific implementation.

Best regards,
Krzysztof

