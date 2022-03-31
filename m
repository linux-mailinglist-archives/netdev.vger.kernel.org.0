Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE44EE2D2
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 22:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241512AbiCaUro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 16:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233946AbiCaUrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 16:47:43 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31901965D0
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 13:45:54 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id c10so1669489ejs.13
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 13:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=hrushPIifaJMbhX/D5OgtEyyLGYhBGFXWtYmvQr1CG8=;
        b=Kgtyd0AkXJGT1r4sxTxz17MzmIjQdk+iU+hsHcUzIJT6EnymL6nQqAaCaW7RHLEJCB
         F+XOmMjF/1lm04ymqZvJknr7zLRXTIUUnjfLYlEm2ZpPttRsVYdyV946NKJ1UILanT+f
         S6ebmyeG8Q+oi0v4kZcewNUkTa0L0sXrzO/5x9rbgUN5y5uyRt1ZyqB37Esi82UlLP8E
         256GWHvL5UEAhri/4mfKzoR1cx++q7/PRErD8j3MN3kW0yLZ/u1YuXg8adshwiUpVB0U
         6fhwBXel+g3HLeMirOVQ7veGewBkytIcGvllCDlQ+SPGFvR0E/IkrXnVcWPd7h1ECSgX
         zuzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=hrushPIifaJMbhX/D5OgtEyyLGYhBGFXWtYmvQr1CG8=;
        b=e5h+OL96QMELAp1WjBVgGspuS3ucU5NY5j3cRiAPjoNB+cA15bsdiJAgL1feK928z4
         Cz1N7q0GkUJldy8EqiZlZ2CxameMdTGoOoHe9GCdKFR+a5NplKz2kXsel9DfaoCr731q
         nPz4frHna2WYroxzZ6QLNAtXPd5d1HpoyY5M/xVL+t3VLTAzpsfi3SUYzVObJHSSRQcJ
         JiARIIbW3IitCD0fXe6zKD0aPqKEyif2wnMsUhAbGcIs0cCSNGPJNYCiNA32uFHYtAJI
         6iJ3oFYS7gTeJehYSH/ikgWcmMkaZhC4MR4xze9BmgxItWTXjoJg7InCcTHWVyocpOxN
         /zmg==
X-Gm-Message-State: AOAM531bz/+RToh88ogenrqL/lligl5MubN3YBDNDO8Bk+5kOu0Fab+l
        HcEHyLCxIlwbj28CfT/6xzGW+w==
X-Google-Smtp-Source: ABdhPJxQcTE7XkMAIVQK9kiJTdoua6mXCjN4D0gpGnHKyw5vjpQMMkd5Fpxe0nf8+F+y4YhzSVFbsw==
X-Received: by 2002:a17:907:7f09:b0:6e0:395d:cc88 with SMTP id qf9-20020a1709077f0900b006e0395dcc88mr6675257ejc.566.1648759553334;
        Thu, 31 Mar 2022 13:45:53 -0700 (PDT)
Received: from [192.168.0.168] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id i25-20020a056402055900b004191a652e3bsm233329edx.30.2022.03.31.13.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 13:45:52 -0700 (PDT)
Message-ID: <dce02cb9-c173-f1c5-a645-461d314e467a@linaro.org>
Date:   Thu, 31 Mar 2022 22:45:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <YkR57poibmnvmkjk@shell.armlinux.org.uk>
 <259ac0f4-50e9-291b-9ed3-91b52840fb9e@linaro.org>
In-Reply-To: <259ac0f4-50e9-291b-9ed3-91b52840fb9e@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2022 18:51, Krzysztof Kozlowski wrote:
> On 30/03/2022 17:40, Russell King (Oracle) wrote:
>>
>>>> +
>>>> +  - | # Serdes to PHY to SFP connection
>>>> +    #include <dt-bindings/gpio/gpio.h>
>>>
>>> Are you sure it works fine? Double define?
>>
>> Err what? Sorry, I don't understand what you're saying here, please
>> explain what the issue is.
> 
> Including the same header twice causes duplicate defines, which should
> be visible when testing the binding.

I don't see such errors now, so either something changed or I confused
with something else. It should work, so let's skip my comment here.

Best regards,
Krzysztof
