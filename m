Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 952445910D4
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 14:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiHLMgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 08:36:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbiHLMgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 08:36:51 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE706A3D41
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 05:36:49 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id w15so832028ljw.1
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 05:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=2Tr6s6oL+tsJZTa2fS1ZrFcsPmdVMztbv0oSJXbRlXA=;
        b=FwnpfPvU0mr6T2+sNySqjij72Ea3ibh6EfoI4nRmF2+EnuB4vPoGgl0XCl9+/I8zJS
         MeusBGqCgyx77QPPt26Y3P4E/yihI+MwKoWf5sMolOoUivOpBqkomTiOAPAkkOqEVWDx
         /dauYc/ZSD2Div6Im4iBUaka1PSIzemPTCy8FcbYoVK7T83VgCxVNrWWO7c2i6b0mMOZ
         E+rsvY/NK8O12PrSuXu9u7eMBeq5bB07/2fipqaqPbYDYPmle8p5r8BRGpWUPSPtf4vn
         SWgLg3IzHEoSm9nf3QXfyo7tFWzSFBf6theP2tmI8W8UyD1LTOjXR4xryxU0o/KJ8dLK
         DW2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=2Tr6s6oL+tsJZTa2fS1ZrFcsPmdVMztbv0oSJXbRlXA=;
        b=CfJBxbnWS6Nx0+zNGy0gjMLlMNipuuAWwTePAdMRK44Fnk1geBGnOYaoR7FXz1TkjY
         TJar+nASVSeN3LTLBQVSs0T7dDY1jwWTswk6fM6q1CC/pQF4o2QRkS0f2bkoHF5eqpxe
         Reouhb/Qaw+GSITeYG/2mR7OireubR1PoO/Fi/0Odn/siMI5iYsEYWhXOE5dfT5dFJgk
         1o1FEIQSTZw9dS2z41nWiFNrMYJXUN9Fije4y9WFZRJakMLcWYqKisQAlTAdcJcttXXN
         SuAMyKwmWzRGTf6nOX3sO/Dj0WroDIilRnvvpMAeWjKe66QgYsqQq2m4wcIB8Zg6wydE
         e2+g==
X-Gm-Message-State: ACgBeo1awbZgv1BN8oP7C8Nf1P8kv4748WgcK2p3Ddp/mtk2jgSTERY+
        G0hQK3WblYGz2SQOxfrqo4Loqg==
X-Google-Smtp-Source: AA6agR78QUiU7vpTO8Aqve0sIQhhsaLLDdk1wAfRnsgtfOx1KMpbzpIIP5CArpfpjrSkQ97qI8rOgA==
X-Received: by 2002:a2e:712:0:b0:25e:c39b:45cf with SMTP id 18-20020a2e0712000000b0025ec39b45cfmr1196685ljh.511.1660307807962;
        Fri, 12 Aug 2022 05:36:47 -0700 (PDT)
Received: from [192.168.1.39] ([83.146.140.105])
        by smtp.gmail.com with ESMTPSA id f14-20020a05651232ce00b0048b2a5a65d0sm198830lfg.256.2022.08.12.05.36.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 05:36:47 -0700 (PDT)
Message-ID: <01021dde-106c-5660-ea96-a8b8fd89ad50@linaro.org>
Date:   Fri, 12 Aug 2022 15:36:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net 1/2] dt: ar803x: Document disable-hibernation property
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Wei Fang <wei.fang@nxp.com>, "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220812145009.1229094-1-wei.fang@nxp.com>
 <20220812145009.1229094-2-wei.fang@nxp.com>
 <0cd22a17-3171-b572-65fb-e9d3def60133@linaro.org>
 <DB9PR04MB81060AF4890DEA9E2378940288679@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <14cf568e-d7ee-886e-5122-69b2e58b8717@linaro.org>
 <YvY7Vjtj+WV3BI59@shell.armlinux.org.uk>
 <4cf8d73e-9f14-fe8d-d6e2-551920c1f29e@linaro.org>
 <YvZH9avGaZ3z5B5H@shell.armlinux.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YvZH9avGaZ3z5B5H@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/08/2022 15:30, Russell King (Oracle) wrote:
> On Fri, Aug 12, 2022 at 03:04:41PM +0300, Krzysztof Kozlowski wrote:
>> I did not propose a property to enable hibernation. The property must
>> describe hardware, so this piece is missing, regardless whether the
>> logic in the driver is "enable" or "disable".
>>
>> The hardware property for example is: "broken foo, so hibernation should
>> be disabled" or "engineer forgot to wire cables, so hibernation won't
>> work"...
> 
> From the problem description, the PHY itself isn't broken. The stmmac
> hardware doesn't reset properly when the clock from the PHY is stopped.

There is nothing like that in the property name or property description.
Again - DT is not for describing driver behavior or driver policy.

> That could hardly be described as "broken" - it's quite common for
> hardware specifications to state that clocks must be running for the
> hardware to operate correctly.
> 
> This is a matter of configuring the hardware to inter-operate correctly.
> Isn't that the whole purpose of DT?
> 
> So, nothing is broken. Nothing has forgotten to be wired. It's a matter
> of properly configuring the hardware. Just the same as selecting the
> correct interface mode to connect two devices together.

I just gave you two examples what could be written, don't need to stick
them. You can use some real one...

Best regards,
Krzysztof
