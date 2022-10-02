Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C775F21D7
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 10:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJBIA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 04:00:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJBIA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 04:00:57 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634AD326CD
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 01:00:54 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id bu25so12661680lfb.3
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 01:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=4vfWsjY57/5il+Q1FyIltb4lN+Qrd7nGTflpU17Qi8A=;
        b=jLbk83gCtDhr6Oc319IjTZW1fGmVAQBNCMI0L1H6XX9Rz7ppPIhCAqr+iE8SnvaU2A
         VkSoJ6HJhWCT8xMJEy+sZ36Ko5nkwaf2cNMcut6Xw7+El6Jc9EphakEbTOCbxfP6Swp1
         met5VMtERbykbHKHceLQFfa2mMloBkyXP1Jt3Q+8khYTlMQ59QuwGMErVzZBtuWJg4/A
         yHzUpbB0G1pacP5r80Kbe39re4RusIWkiM5p4WdBUHBnUmpIfQb+KbGzjZsLPvugFveX
         jveuxh90nQhhMVXRaXsipfrYpg/D8nTLDHbp1ZDYyZaz8mLDhMwqe4PIwLOl0OW0t+CI
         478Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4vfWsjY57/5il+Q1FyIltb4lN+Qrd7nGTflpU17Qi8A=;
        b=hF8pZGUC1+AGiHoAvG5UQjQ2/DCRuX8fDfihh0C1JLXSkaspr9Sg7eYm208x0ZmJX0
         zDOoww9YeUCEXXjEE6yLhGtmsQRRekdF3I8jm+3X/4/0rnH+vwZ5JB96KmfL2XQwhLjf
         7iBiTjNFibl99YYYelawwY5ORK8kar/aeZKit5USOapVVAhB7uJfJCaDPIBEly4cXORx
         YDorS5DHIh5iE18PRbrcBMDOt0yxhFPk+KDUjkgZ0c79x10F811HKlpBX/G+29gw2EyE
         LUn/6ZxuluPSSmOkfF1SZYBSEy2hapOKXI6NJOoKKHiaQBn6bYV537g6OeCFjdaUeRCn
         ID5Q==
X-Gm-Message-State: ACrzQf2brFfjDqkeiGR31DoNc/yqhDTdwB802DwFY1B657piqxZ5Hhcz
        /iKzFzlBF0C9nS2OCWfs3tTdWQ==
X-Google-Smtp-Source: AMsMyM7+kHoRC+VPQm9KMnd4hh8egehS2ji53cPn2tzNmurKTV6rvmEeXw8FG3kcZi/fzGyIEPUs7Q==
X-Received: by 2002:a05:6512:224b:b0:49f:9e09:584e with SMTP id i11-20020a056512224b00b0049f9e09584emr5564423lfu.524.1664697652137;
        Sun, 02 Oct 2022 01:00:52 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id n5-20020a0565120ac500b0048af3c090f8sm1008733lfu.13.2022.10.02.01.00.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Oct 2022 01:00:51 -0700 (PDT)
Message-ID: <3b234066-268d-8da9-caa6-ca4d693dc0d0@linaro.org>
Date:   Sun, 2 Oct 2022 10:00:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2] dt-bindings: net: marvell,pp2: convert to json-schema
Content-Language: en-US
To:     =?UTF-8?Q?Micha=c5=82_Grzelak?= <mig@semihalf.com>
Cc:     davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, netdev@vger.kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, upstream@semihalf.com
References: <db7055da-b01f-3ca6-20f8-e9bc7ed892bc@linaro.org>
 <20221001155353.10211-1-mig@semihalf.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221001155353.10211-1-mig@semihalf.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/10/2022 17:53, Michał Grzelak wrote:
> Hi Krzysztof,
> 
> Thanks for your comments and time spent on reviewing my patch.
> All of those improvements will be included in next version. 
> Also, I would like to know your opinion about one. 
> 
>>> +
>>> +  marvell,system-controller:
>>> +    $ref: /schemas/types.yaml#/definitions/phandle
>>> +    description: a phandle to the system controller.
>>> +
>>> +patternProperties:
>>> +  '^eth[0-9a-f]*(@.*)?$':
>>
>> The name should be "(ethernet-)?port", unless anything depends on
>> particular naming?
> 
> What do you think about pattern "^(ethernet-)?eth[0-9a-f]+(@.*)?$"?
> It resembles pattern found in net/ethernet-phy.yaml like
> properties:$nodename:pattern:"^ethernet-phy(@[a-f0-9]+)?$", while 
> still passing `dt_binding_check' and `dtbs_check'. It should also 
> comply with your comment.

Node names like ethernet-eth do not make much sense because they contain
redundant ethernet or eth. AFAIK, all other bindings like that call
these ethernet-ports (or sometimes shorter - ports). Unless this device
is different than all others?

Best regards,
Krzysztof

