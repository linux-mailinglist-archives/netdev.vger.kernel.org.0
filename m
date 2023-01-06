Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD04C65FE13
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjAFJew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:34:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233965AbjAFJeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:34:07 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8629C81127
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 01:26:11 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id m7so722593wrn.10
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 01:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OzjZkwhDPrrcLXve7rYhUcMyijjyvM53BT53pIm7uHU=;
        b=g+n1cnPdI/JdQo/jMHI0OkwWEjtwDLK0fL4cH4EyguAc63VVcTOvNiy8LZnR1GwgRl
         3Lmyl+oNocRPIY9rb9+CINkbG6/1olcm4cZm5Kk2drBZlkii4nQT982gY7kKRCnQE0Hy
         up7gfmmmFjMfeCPf7gdh2yD3qeNa8+Apq690Y6mQt4zNPQtoZAzYM7CzHXEGo0NaWPSM
         kqW9cd35+gSr+k9FcaqzQCn9EMjxG46igwN9SlXadZ9Pz+5PMAEsInHpXv2HvrXitijf
         dN7HK+6g53AW0ZKZlfZiqwl0alE9HJf1Nk6flcgKapvDMBsT4sOFvXmtW2mmdv7kogGr
         WQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OzjZkwhDPrrcLXve7rYhUcMyijjyvM53BT53pIm7uHU=;
        b=HKaBUnwENggZo14tzkxzihwjxQjYFInAvCOB39z3sHENh3/lmIlPxCkByRsGQ4NpSP
         wWnccDmtxUmtM+VEz3FL2P1qtRjGP28+BDDZcPdtuGzlGJ3+FAWZSGTpFXGdIw//roOA
         xaerwGAyG2CmAEUPMcetilzpXidbHkww3tDiOJAsye8TCHYbSrMHHxyKrewvMw7Lyg8V
         pDck0gK+8i9s0WyXUAEMxXTqLTCxW4U6wJYrFFUaIPmbKAFJFBP1eYaPm72E01ZIZ2Is
         z9xeD0sAOvOTHMIha3MNFUpMCNR04kU5jk9sxqyusysr+2bUqFxEQ5ZEvPvw5DAzGCCC
         Ug/A==
X-Gm-Message-State: AFqh2kosV5tUk7Enyx0A2e5wNBVeF+sQgfos0a8ad4Z/dWaWMO/hg3Wy
        81gjyfLCyQzfJdREC9M8nruLAQ==
X-Google-Smtp-Source: AMrXdXsk4DyQ2BVf7+eVPQLAp9uSQAAZtSiQP1YMsjZ+EX5uYdaeKz4wvaK8AvaFvqbYTFzAkoXOcA==
X-Received: by 2002:a5d:5c12:0:b0:242:800:9a7f with SMTP id cc18-20020a5d5c12000000b0024208009a7fmr36467648wrb.65.1672997142546;
        Fri, 06 Jan 2023 01:25:42 -0800 (PST)
Received: from [192.168.1.102] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id bx11-20020a5d5b0b000000b002366f9bd717sm752424wrb.45.2023.01.06.01.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 01:25:41 -0800 (PST)
Message-ID: <23ee90c0-b6cb-bc71-9e92-72c51a169373@linaro.org>
Date:   Fri, 6 Jan 2023 10:25:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
Content-Language: en-US
To:     "Frank.Sae" <Frank.Sae@motor-comm.com>,
        Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
 <b74baadf-37a4-c9a2-c821-3c3e0143fa4a@linaro.org>
 <8fa89dac-6859-af93-0dc0-ffcb42b5bb30@motor-comm.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <8fa89dac-6859-af93-0dc0-ffcb42b5bb30@motor-comm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01/2023 10:17, Frank.Sae wrote:
> Hi Krzysztof Kozlowski,
> 
> On 2023/1/6 16:26, Krzysztof Kozlowski wrote:
>> On 05/01/2023 08:30, Frank wrote:
>>> Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.
>>>
>>
>> Subject: drop second, redundant "Driver bindings".
> 
> Change Subject from
> dt-bindings: net: Add Motorcomm yt8xxx ethernet phy Driver bindings
> to
> dt-bindings: net: Add Motorcomm yt8xxx ethernet phy
> ?

Yes.

> 
>>
>>> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
>>
>> Use full first and last name. Your email suggests something more than
>> only "Frank".
>>
> 
> OK , I will use  Frank.Sae <Frank.Sae@motor-comm.com>

Without "dot" between parts of name.

> 
>>> ---
>>>  .../bindings/net/motorcomm,yt8xxx.yaml        | 180 ++++++++++++++++++
>>>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>>>  MAINTAINERS                                   |   1 +
Best regards,
Krzysztof

