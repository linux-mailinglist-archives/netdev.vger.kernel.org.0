Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB5B351F618
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbiEIHmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbiEIHZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:25:26 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066E13A1A0
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:21:27 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id p4so15205189edx.0
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 00:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=apRPpN65Ed047N8icEDO3pjLgB56IvwvctjTBVy4raw=;
        b=v1XVYtDcVcQE3s3lTIvZhOt3ikamNMOs90f2GvJQeJ83Z8u1YK/hbESpx0gX4MRpZc
         nBDF2yXXNqwpNUV67eV1xikynkDn8u7Ob8gHhrS218Un7qKv3MQCoOR2CGLjsLx+MJik
         k+8z1esgCPcww/URaz0mEe/24qLF2JKAdthwszSOZbQwM94UAGPp1Bjp1ytw+3My/KhQ
         s8mjM0X2l6U847F03xlLJaR+bf6fcVLJqTMQ55R6OxGryPAsW6DCxBChsovqaRQSOmKu
         XvgGm1BsvOcLlEZ41rgjBGbxS79TYPvJABKqJz+q08lvjEDLab+yTaXqSaDZVygplZ4R
         xjnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=apRPpN65Ed047N8icEDO3pjLgB56IvwvctjTBVy4raw=;
        b=5bwjJFWjuaEv0QRDGbXeDFHEGDKavgf4oc2afHhyOrRQHNfq7pnwcfwlwNLghiAJ2M
         oqiYmaoi2YZPamitT4I6DOAgSrvm1hXBTcBkg5eSNE0Bk6rmbmKx9ywZAdTMo30TGEfP
         zKv1mrYJSZFx+ZaPXIt6eijC6SFfQuBZdqo3kinet3okHgKtBtWL5l0r4V7G+Ouc5y33
         Iqxm7WkeH7wS4l1Xmxh5rEh9IfLImsu0Fxyets9s+dmC8v777k/vLZDczxcGom9x1sKA
         HnVOCNXZHeUXbi0TN3VLa5RYl1ScL7JD3hd7DKajxBWkqF3Og9hoCu25m+Q/LlrUuZJr
         I90g==
X-Gm-Message-State: AOAM532B7S0dHySW3xoHSnJuv0V1o05/jo/YK40WOt4NuFrAP9ooLhLH
        3FUsLVspkaeV7zapRnz0P1+Qbw/uqTovfUiv
X-Google-Smtp-Source: ABdhPJzAvF/ZP7115uFIBJ/kbDFYZ9RKMTlc/1BrICFKcZF2dodESHECcJ7jZPatBrsENpqF83QA4Q==
X-Received: by 2002:a05:6402:2318:b0:413:7645:fa51 with SMTP id l24-20020a056402231800b004137645fa51mr15979806eda.201.1652080881213;
        Mon, 09 May 2022 00:21:21 -0700 (PDT)
Received: from [192.168.0.242] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id hy21-20020a1709068a7500b006f3ef214e7bsm4778275ejc.225.2022.05.09.00.21.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 00:21:20 -0700 (PDT)
Message-ID: <1c0a2eca-b769-0078-41de-6735bb1880f2@linaro.org>
Date:   Mon, 9 May 2022 09:21:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3 1/3] dt-bindings: net: adin: document phy clock output
 properties
Content-Language: en-US
To:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Andrew Lunn <andrew@lunn.ch>,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220419102709.26432-1-josua@solid-run.com>
 <20220428082848.12191-1-josua@solid-run.com>
 <20220428082848.12191-2-josua@solid-run.com>
 <22f2a54a-12ac-26a7-4175-1edfed2e74de@linaro.org>
 <e46335cd-7e14-49aa-7d93-e88de0930f66@solid-run.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <e46335cd-7e14-49aa-7d93-e88de0930f66@solid-run.com>
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

On 08/05/2022 11:57, Josua Mayer wrote:
>>> +  adi,phy-output-reference-clock:
>>> +    description: Enable 25MHz reference clock output on CLK25_REF pin.
>>> +    $ref: /schemas/types.yaml#/definitions/flag
>> This could be just "type:boolean".
> Yes, it could be boolean, and default to false.
> So ... I figured its a flag, but whether to make it a flag or boolean is 
> better I do not know.
As I said, use "type:boolean", less typing and it is equivalent.

Best regards,
Krzysztof
