Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D88A580491
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 21:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236433AbiGYTjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 15:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiGYTjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 15:39:53 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A23AC205D1
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:39:52 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id b16so7104872lfb.7
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 12:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=7TgkwMCGH8mTLYpuQJ03GCo0HTr07mExTrfJu7QnTBk=;
        b=btN2MagO7hPo507CmIAjmr7FW6Se5tqp2OzRQNuVFFQw+dEh9SkA+t4wsS36uYIYXf
         0WU5rQuz+J5wpTpZzdr6Hw+8wOWOw3+NJaEQFQEld775tTqM4nqqcCJzFql/NZcW9PxI
         mIpuPHy2oNM6U38ry7XrMfD3EGVqphUbjsA1d0AgmG+dPk0zNGyITpqJ+4VQJYmY0RqC
         IKyylCeq9f/Y/4DTzZms2KGHmZpOEihDhLM9MoZDxbIR9apxWYNRPqS1MQNeVi1fep1l
         Mf9ifJu9aOTO8y8t4qu1W7wCEDwwW7+H44joqMZk0CsJYYGE6xnPlnyzd598QSX6AH9C
         OQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7TgkwMCGH8mTLYpuQJ03GCo0HTr07mExTrfJu7QnTBk=;
        b=Txf8jW7xMiFMhb+7NDz8P8IfgO46bYzdSiQtN2eg68fkoK2EQ+3PKVwtG5g46eCFJx
         RqNmJJrzswbYCmiLX1Ba1q+fDQTLIwn32IBUCh8aEJAFept/JjNOLs8Q76R8IMQ4nm04
         kNAgIgEidhkswx9XsZve3tx2CbWZxIkTuep0NmloG1sxgaXy3tNUQQTdgEY5u++HVHEt
         JwF72kltI5i1wosYsGq21Q5qu5GxB3wgyhb1PKtKohAva7+8QaHM1G9uGa3LdaDpaCna
         wkhYrb5w+xOhyc07oA8p/4/IO3CZMxkEU5/nsDrB1mTRN1FKyWJqqkhCMtKYzsJ5aX8Q
         khSg==
X-Gm-Message-State: AJIora+STwHGdNZS5MjAFLi1IUT9SGjlwqiKqiTzdqXcS7rkOp9dplO8
        oSxJVIEfpIqBnDtjDzwj86VO6Q==
X-Google-Smtp-Source: AGRyM1uIxsFuo/Pf7kus3RXxJczb4yO8MmUcIhtfROj3yAJgnLiwbh25xjc+u6hAotpQjJH7fjSMyA==
X-Received: by 2002:a05:6512:22c2:b0:485:8c7a:530d with SMTP id g2-20020a05651222c200b004858c7a530dmr5325325lfu.459.1658777990943;
        Mon, 25 Jul 2022 12:39:50 -0700 (PDT)
Received: from [192.168.3.197] (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id be9-20020a056512250900b0047f8790085csm2574646lfb.71.2022.07.25.12.39.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 12:39:50 -0700 (PDT)
Message-ID: <017a3722-d61f-6762-d17f-57417f1e3165@linaro.org>
Date:   Mon, 25 Jul 2022 21:39:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/3] dt-bindings: net: cdns,macb: Add versal compatible
 string
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>,
        Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        harini.katakam@amd.com, devicetree@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com
References: <20220722110330.13257-1-harini.katakam@xilinx.com>
 <20220722110330.13257-2-harini.katakam@xilinx.com>
 <20220725193356.GA2561062-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220725193356.GA2561062-robh@kernel.org>
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

On 25/07/2022 21:33, Rob Herring wrote:
> On Fri, Jul 22, 2022 at 04:33:28PM +0530, Harini Katakam wrote:
>> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>>
>> Add versal compatible string.
>>
>> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
>> ---
>> v2:
>> Sort compatible string alphabetically.
>>
>>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/cdns,macb.yaml b/Documentation/devicetree/bindings/net/cdns,macb.yaml
>> index 9c92156869b2..762deccd3640 100644
>> --- a/Documentation/devicetree/bindings/net/cdns,macb.yaml
>> +++ b/Documentation/devicetree/bindings/net/cdns,macb.yaml
>> @@ -20,6 +20,7 @@ properties:
>>  
>>        - items:
>>            - enum:
>> +              - cdns,versal-gem       # Xilinx Versal
>>                - cdns,zynq-gem         # Xilinx Zynq-7xxx SoC
>>                - cdns,zynqmp-gem       # Xilinx Zynq Ultrascale+ MPSoC
> 
> Uh, how did we start this pattern? The vendor here is Xilinx, not 
> Cadence. It should be xlnx,versal-gem instead.

I missed that piece entirely... Un-ack.

Best regards,
Krzysztof
