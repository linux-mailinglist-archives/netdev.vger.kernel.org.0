Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C11B52D18B
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237503AbiESLdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237447AbiESLd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:33:27 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15826B0A66
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:33:25 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id d15so8600906lfk.5
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oZEhROINlJWM7vdViG2IE8Bwfk0C1vKAbaV7Oeo94UQ=;
        b=EGYii0kO3qs08FhyjVI9Y2ePF+IohLbIeqqa7oK57S3FHkA5RVZPqNblDLIW75kFcH
         6oX9s2gDFeGn/Roq1TarZsxyRUt40VFfb5c7GuE3GAwRVG6wR8/7g+uoxQtyoal+s1Bb
         DURdbTlR841WX2Cbo1oPkbROxz3gHWrGzyDokChBKsDSyyNLlTTlKnxN/3AY28EWxs81
         7LfNbBhSuRzanMHZYwj8TfSLIbfXB9SULTllFtS5cdp1cEyf+zg05PoipkxYaZYsOqld
         9XXXp7qDW7uDXI0zwLWNUMJpf5xEn0ESsqk27e/JgyB/aRM43jaj70OtEgW7UJkTnhV5
         lftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oZEhROINlJWM7vdViG2IE8Bwfk0C1vKAbaV7Oeo94UQ=;
        b=WYSaUaQsfWZXUdOVySoTFI+isWWchmLwS3tHhxaD0KG/QA1frsQx+fvCcg3VHXRb9N
         SxrfZoo35/B6rPd0tJyfRuie6a3Pf1Exv6tvm25zYdcOY/GBsQsTjpStubt6j7LB2asK
         aU0f0qzZtyigWG8FLF6euWRNyGF14MNl6oGXcny6U2SHDfdpO/xJZnRHxFGhejPFdiJ7
         uhkAjfuOhyE7aG7Hi31P2aeLy7cV57OLrZVM8yRQgNSTwDWVuFITf/9fGL5/HvZv2b9f
         7KzM62v5qEUazdX6HRRsH8ItSZ+WorGBpLpA3udVED9NYw7yal40+0F6/IbkniUHg7NS
         qEYA==
X-Gm-Message-State: AOAM531DZL8fSqM90kS/3ZwYcSDiKm9liXrSt5/q6Z9w8k0UprSGJnZZ
        6WnnL9n9iG659e79kDbzJU4zHQ==
X-Google-Smtp-Source: ABdhPJyUim5e9pHHMifbYzMw77E1dUklze9AipVmBtmLAVQKy142zJwXyX5rENYYXJsuBfOx5tzKxw==
X-Received: by 2002:a05:6512:2215:b0:473:c124:434b with SMTP id h21-20020a056512221500b00473c124434bmr3049278lfu.24.1652960003454;
        Thu, 19 May 2022 04:33:23 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id 189-20020a2e09c6000000b00253b5bb829esm556593ljj.98.2022.05.19.04.33.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 04:33:22 -0700 (PDT)
Message-ID: <c74b0524-60c6-c3af-e35f-13521ba2b02e@linaro.org>
Date:   Thu, 19 May 2022 13:33:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 4/5] dt-bindings: net: Add documentation for optional
 regulators
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>
Cc:     Corentin Labbe <clabbe@baylibre.com>, andrew@lunn.ch,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
References: <20220518200939.689308-1-clabbe@baylibre.com>
 <20220518200939.689308-5-clabbe@baylibre.com>
 <95f3f0a4-17e6-ec5f-6f2f-23a5a4993a44@linaro.org>
 <YoYqmAB3P7fNOSVG@sirena.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YoYqmAB3P7fNOSVG@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2022 13:31, Mark Brown wrote:
> On Thu, May 19, 2022 at 11:55:28AM +0200, Krzysztof Kozlowski wrote:
>> On 18/05/2022 22:09, Corentin Labbe wrote:
> 
>>> +  regulators:
>>> +    description:
>>> +       List of phandle to regulators needed for the PHY
> 
>> I don't understand that... is your PHY defining the regulators or using
>> supplies? If it needs a regulator (as a supply), you need to document
>> supplies, using existing bindings.
> 
> They're trying to have a generic driver which works with any random PHY
> so the binding has no idea what supplies it might need.

OK, that makes sense, but then question is why not using existing
naming, so "supplies" and "supply-names"?

Best regards,
Krzysztof
