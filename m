Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31FE7671670
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 09:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjARIpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 03:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjARIpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 03:45:23 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D6E8F7E6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:00:23 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r30so8605942wrr.10
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 00:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6JHe7Mld7ca44zxKnapswWL8ppqp7gV/qk5d9Nzoevw=;
        b=KTEP6I1p+vMcKWOb9+hnvxwJhNZClYy3mVLwvEaRmwrc3+YVVJ1SuxIoRZsnnhmQGi
         /GnHcl1skgTY8B6z82bSuqdRFdYIel+Vg4WEEaP2iYUO4GnHRCa6P74G3zU7IPS1VyGT
         I8WGfAj5FAoWzLc2mcs0ibz3ops67DOkZLXOJKYrpuVfP3vuGc0qCAEespNvrpu5AYGJ
         Ldw/Xe/+zQtjzYJ/iv/riljurmbyz8fdRyf6p97zA0RBzok1XbAK6MqXtC1YSmuKwlPs
         6XZXTBfV9oOVt02092OtdJZLlEDuUVXCc8B3UksAff2U5txyp0T/VH1e6N2Wi9r6EYKt
         Z7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6JHe7Mld7ca44zxKnapswWL8ppqp7gV/qk5d9Nzoevw=;
        b=e7sFa+LIl44jZZtgf8O+KHzwRtYg0rq5y6Cdhug1PjJ5M/ixb6BIqFGYUYacN63RXa
         9IiHPSkcXOupY6dnSgtBDydtzvaDDIty6lypHJNupY5ZHPKVYzMhCCP/8M8YkSCjtBFA
         RRJxVuPOqR6K/b5FovWeX9m8qy4oLsUBOsbozBd5paPIZVGbezbDw5pXTsF6kAbcXP4Z
         TfgZ8mspcOWPUSayKnsJLUGhZqfzNogHI7f5vcRnbMwYU9ultGk5sdyFGPXUGGaJlo4l
         bSDENB5m/Xg+UDYYWneYWi0PoSMVtf23BYndh8TciPVHhB90E06lVxSIHbsN1ho92G2S
         KOMw==
X-Gm-Message-State: AFqh2kpxJEpWo6nzrMiccNv+MJ6x5YmilmuxRBCpc9sG9AX9fhx15tic
        xol44mEgvEfTYaQjHi3jI7D75w==
X-Google-Smtp-Source: AMrXdXuEmKllwaiidwPgTn+Gamv50gFRp4dBCIpq9KI5N/ug614mLjZGjAIslqwj4xHNNfCH7W417A==
X-Received: by 2002:a5d:6a86:0:b0:2bb:e805:c1ef with SMTP id s6-20020a5d6a86000000b002bbe805c1efmr4981345wru.52.1674028807988;
        Wed, 18 Jan 2023 00:00:07 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id f8-20020a0560001b0800b002423edd7e50sm30387327wrz.32.2023.01.18.00.00.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 00:00:06 -0800 (PST)
Message-ID: <787bb142-1ade-bd48-1f6a-0da992add3d3@linaro.org>
Date:   Wed, 18 Jan 2023 09:00:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3 4/7] dt-bindings: net: Add support StarFive dwmac
Content-Language: en-US
To:     yanhong wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20230106030001.1952-1-yanhong.wang@starfivetech.com>
 <20230106030001.1952-5-yanhong.wang@starfivetech.com>
 <c114239e-2dae-3962-24f3-8277ff173582@linaro.org>
 <9c59e7b4-ba5f-365c-7d71-1ff2953f6672@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <9c59e7b4-ba5f-365c-7d71-1ff2953f6672@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/01/2023 02:45, yanhong wang wrote:
> 
> 
> On 2023/1/6 20:45, Krzysztof Kozlowski wrote:
>> On 06/01/2023 03:59, Yanhong Wang wrote:
>>> Add documentation to describe StarFive dwmac driver(GMAC).
>>>
>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>> ---
>>>  .../devicetree/bindings/net/snps,dwmac.yaml   |   1 +
>>>  .../bindings/net/starfive,jh7110-dwmac.yaml   | 113 ++++++++++++++++++
>>>  MAINTAINERS                                   |   5 +
>>
>> Order the patches correctly. Why this binding patch is split from previous?
>>
> 
> The previous binding patch was considered to be compatible with JH7100, but after discussion,
> it is not compatible with JH7100 for the time being, so the name of binding has been modified
> in this patch.

I am not asking about name, but why this was split from the patch using
the compatible in the first time. This does not make any sense. Please
squash.

Best regards,
Krzysztof

