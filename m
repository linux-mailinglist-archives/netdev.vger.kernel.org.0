Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE1B619E37
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 18:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbiKDRNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 13:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKDRNj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:13:39 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78B7731ED0
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:13:37 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id o8so3619232qvw.5
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V9d/XoPw51yk/pI4pLP90kowufRsgkaEdGWppnSDAkE=;
        b=nl4idPg6vMNt0oI4SBlEgipBnS7ZrmdQOCvz6ALUQsrc6BtD+bhod/KyLM/Kn/yaFT
         Eph1kx+nWdV831rx21gd82njO+H3KEqvuuZpksRl50C6FOSwK13ypYmNzEBskoMGSzDN
         JPoVFdVF3QbsUHrWqWYNE5TouaK9k/mA4mGmEj3ab+JKZExUVYOlRV5nixFt9/s+XCeu
         /C97BPwdv8CAXzZBsvL+57TRksCg3zBJe4NsCAooCbem6tMyzBDespTm6OjfUuEiWESp
         G7oJqsoYXPhOrT1PcFEIml0PBvyu/6ERlh8j1dmHM1BH6JHKwcWvAXz/eulmJzGTBOCs
         74Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V9d/XoPw51yk/pI4pLP90kowufRsgkaEdGWppnSDAkE=;
        b=2OmBzljQi+DymE0FEdDM3kCedEbkD93ACjfy8UsSxUp4NshLA6rW3cDkTT/y9HqvSQ
         xM0Pa5tPPPHI5KLYZYfMfo8jCRD8Rf6IkSKE+XkCADjrtwwUG2HDhOadV7gK+ntGqaoE
         HeNpl1EIQYhnLqS/3uSoxam5qfAXY5PukRjKjtpIS++rKY+STw44oLzGa8nnPA4a0dKr
         O8TzM5MmhMlacbSnyaZXIntGSYbKmpNvknxdgPiZK4qEYMcBpeaaON3SxIWN3WrlmgWX
         H5Ze5KC8tWwEZfG5nyK1T4J/2JnMu9kWCz4pftDKUNLhgh5YwyAHJ/DtnS/72v3B1ppM
         vIIw==
X-Gm-Message-State: ACrzQf1BYzrBehinnAzUVVjigjyv46t2pvHya7WhU5Z8RVmuyeAT2Nc3
        qnMKS2Jk2j4EZfskFUtarMR/fw==
X-Google-Smtp-Source: AMsMyM5My89DYXgpJIfD94Z5eFq3R7YTf92Y24BjUOWx99Z2hVSwPVsG1a0ndzH4FuZ8R0AdzYVsCg==
X-Received: by 2002:ad4:5962:0:b0:4bb:6b78:c599 with SMTP id eq2-20020ad45962000000b004bb6b78c599mr32894711qvb.35.1667582016609;
        Fri, 04 Nov 2022 10:13:36 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:aad6:acd8:4ed9:299b? ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id 145-20020a370b97000000b006eeb3165565sm3176724qkl.80.2022.11.04.10.13.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 10:13:35 -0700 (PDT)
Message-ID: <61945062-4261-ba3d-0d39-8c1cc46ad33b@linaro.org>
Date:   Fri, 4 Nov 2022 13:13:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] dt-bindings: net: nxp,sja1105: document spi-cpol/cpha
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221102185232.131168-1-krzysztof.kozlowski@linaro.org>
 <20221103233319.m2wq5o2w3ccvw5cu@skbuf>
 <698c3a72-f694-01ac-80ba-13bd40bb6534@linaro.org>
 <20221104020326.4l63prl7vxgi3od7@skbuf>
 <6056fe63-26f8-bbda-112a-5b7cf25570ad@linaro.org>
 <20221104165230.oquh3dzisai2dt7e@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221104165230.oquh3dzisai2dt7e@skbuf>
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

On 04/11/2022 12:52, Vladimir Oltean wrote:
> On Fri, Nov 04, 2022 at 09:09:02AM -0400, Krzysztof Kozlowski wrote:
>>> I think that spi-cpha/spi-cpol belongs to spi-peripheral-props.yaml just
>>> as much as the others do.
>>>
>>> The distinction "device specific, not controller specific" is arbitrary
>>> to me. These are settings that the controller has to make in order to
>>> talk to that specific peripheral. Same as many others in that file.
>>
>> Not every fruit is an orange, but every orange is a fruit. You do not
>> put "color: orange" to schema for fruits. You put it to the schema for
>> oranges.
>>
>> IOW, CPHA/CPOL are not valid for most devices, so they cannot be in
>> spi-peripheral-props.yaml.
> 
> Ok, then this patch is not correct either. The "nxp,sja1105*" devices
> need to have only "spi-cpha", and the "nxp,sja1110*" devices need to
> have only "spi-cpol".

Sure, I'll add allOf:if:then based on your input.

Best regards,
Krzysztof

