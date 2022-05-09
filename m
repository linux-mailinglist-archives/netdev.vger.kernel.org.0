Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C4551F4B8
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 08:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbiEIGyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 02:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiEIGwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 02:52:55 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04703198764
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 23:48:59 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id i27so24833875ejd.9
        for <netdev@vger.kernel.org>; Sun, 08 May 2022 23:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Q1uIYNMhCGy4rHwwDKHArD0ERJS+cdwEigc/mkUrZDE=;
        b=Mb0zfiXOc10IiOZfJPPokzGs7XcA/7jpw/OIqiOD+eKHEEsR1Q8LBthkF/q+eCNL29
         CNGF1orY/xbxnus7pNzHJc2rJ4hOzmuJys+rDQCMyCEucN8qhlKgNcvURUdntg2LzHu7
         7E7lQyEi2FDEMzsqYFb2X+SLS1EAc6JlpK5VkFRL+zO5uZKLmlpNioK4Fj60HzsZN1vX
         ec7l2HQWwDeLv+WTTo+80RDvwoc1NYTcGHJmLSv7VC6l6mmS2ZGxNipWSLC08vksFOL0
         /M3W0fCxSW7ck/tuBf9nezQw4LZIk2fYn+hF5ajNJZzP/Ex0N+VLa979LoJK3QdeyuSK
         l13g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Q1uIYNMhCGy4rHwwDKHArD0ERJS+cdwEigc/mkUrZDE=;
        b=q54XaV4qrnapG6u0oE58QI+68zELQPIgjsac3Uz6qYNzxqreS+zszngTB1/REajHWW
         1kHVJUIUJWuIiRf/92M+F26NfPJV0s/iDvx6kMZV5sjlU4NowLCOyBAVsuLp229Sa0P+
         r8M1dCdzBn45L31CKUG28xeRJwWbacBIZ2M/kHZDyTTceJR6hn7Ehrggd00gRqfcHscA
         8ezGV9dOqwUJHQvMfMr7o4sJK5GMZEVEa67u2gtOfugXuA03KSeW3SEdvd651gqJKfjq
         Rnlx6yYpDNTMmZUKQZA39rivDRs79BuvHuQAyEGq6IG0oOgD65se3LQ+n1AnakULHOUw
         iLXA==
X-Gm-Message-State: AOAM532LfLg2tFNeQCbJ/aKIkuilMWfAPVSwtLlfClx6UDOUuN0Wk/CM
        dfPgM38G+AdJJs5xyZP5dWlShw==
X-Google-Smtp-Source: ABdhPJyVxgI4jg1+VhdIEC/Y1keifAQgLTtp3IHMJw9n628QQP1fmw3bGVB7LsEt9DCpBaOcdsvJsw==
X-Received: by 2002:a17:907:1623:b0:6f6:e9ce:9926 with SMTP id hb35-20020a170907162300b006f6e9ce9926mr10073326ejc.360.1652078934509;
        Sun, 08 May 2022 23:48:54 -0700 (PDT)
Received: from [192.168.0.242] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id e1-20020a1709062c0100b006f3ef214dafsm4714932ejh.21.2022.05.08.23.48.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 May 2022 23:48:53 -0700 (PDT)
Message-ID: <41d6b00f-d8ac-ca54-99db-ea99c9049e0a@linaro.org>
Date:   Mon, 9 May 2022 08:48:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 5/6] dt-bindings: net: dsa: make reset optional and add
 rgmii-mode to mt7531
Content-Language: en-US
To:     Peter Geis <pgwipeout@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <20220507170440.64005-1-linux@fw-web.de>
 <06157623-4b9c-6f26-e963-432c75cfc9e5@linaro.org>
 <DC0D3996-DFFE-4E71-B843-8D34C613D498@public-files.de>
 <2509116.Lt9SDvczpP@phil>
 <trinity-7f04b598-0300-4f3c-80e7-0c2145e8ba8f-1652011928036@3c-app-gmx-bap68>
 <CAMdYzYrG8bK-Yo15RjhhCQKS4ZQW53ePu1q4gbGxVVNKPJHBWg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAMdYzYrG8bK-Yo15RjhhCQKS4ZQW53ePu1q4gbGxVVNKPJHBWg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/05/2022 19:04, Peter Geis wrote:
> On Sun, May 8, 2022 at 8:12 AM Frank Wunderlich <frank-w@public-files.de> wrote:
>>>
>>> I think the issue is more for the description itself.
>>>
>>> Devicetree is only meant to describe the hardware and does in general don't
>>> care how any firmware (Linux-kernel, *BSD, etc) handles it. So going with
>>> "the kernel does it this way" is not a valid reason for a binding change ;-) .

Exactly. The argument in commit msg was not matching the change, because
driver implementation should not be (mostly) a reason for such changes.

>>>
>>> Instead in general want to reason that there are boards without this reset
>>> facility and thus make it optional for those.
>>
>> if only the wording is the problem i try to rephrase it from hardware PoV.
>>
>> maybe something like this?
>>
>> https://github.com/frank-w/BPI-R2-4.14/commits/5.18-mt7531-mainline2/Documentation/devicetree/bindings/net/dsa/mediatek%2Cmt7530.yaml

Looks ok.

>>
>> Another way is maybe increasing the delay after the reset (to give more time all
>> come up again), but imho it is no good idea resetting the gmac/mdio-bus from the
>> child device.
>>
>> have not looked into the gmac driver if this always  does the initial reset to
>> have a "clean state". In this initial reset the switch will be resetted too
>> and does not need an additional one which needs the gmac/mdio initialization
>> to be done again.
> 
> For clarification, the reset gpio line is purely to reset the phy.
> If having the switch driver own the reset gpio instead of the gmac
> breaks initialization that means there's a bug in the gmac driver
> handling phy init.
> In testing I've seen issues moving the reset line to the mdio node
> with other phys and the stmmac gmac driver, so I do believe this is
> the case.

Yes, this seems reasonable, although Frank mentioned that reset is
shared with gmac, so it resets some part of it as well?




Best regards,
Krzysztof
