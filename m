Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FE86396A4
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 15:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiKZOsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 09:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKZOsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 09:48:41 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F841B9FA
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 06:48:36 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id g7so10932715lfv.5
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 06:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NCkEcXssRQbmgG+L+8GoHzRRDs8zdXaeqWwBNyHJxUs=;
        b=SuypPEb1ok0pZ47WzmQfbMraruPLcGJ+eF2/bqoCL8998ndLQCEOWHg8W+zb31ZOxo
         chldLp4jpNjwvi5D2OhgfAksJZIAu5uBt5Wg5LDYWEGwhj/W3K5eT48Mp7N+swJJnLE/
         jtfeiGTuhIriPBNI5BsN6cQCAYV8zdi+2/OXJ+RjuZqwObjpwRilb2h5ncnwPzXqn2oH
         QEeVL8j0SHJ+uSSl9BF+9JkCRQpfsEVpJ/uI1Dwjzr+uk45W3bt+bBtwXGTEyNDKov6G
         3FkC4cBtvq9FCH7Ni7+OVz1kSz9D0ekCr7cawlBwKES/N0wh2+YE8ovFhWmaOJJOFNQQ
         AmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NCkEcXssRQbmgG+L+8GoHzRRDs8zdXaeqWwBNyHJxUs=;
        b=6Mfe/EryhIY3MMAuU4ZwxY5NjxAapROPtFpQusk2C1k1Kcs+K3JRskoZ1iyj5M/jHD
         cNkans2eAo+FFJqdOHTpo6IVhZl0M6XaKUWVurLX+fL0Mxg8MBZJPQwq/F5EA71n1xd4
         ltaXEaVeZC5LmuKl4mWZJVzmSwI6VGFpnBqM60S7rJIuWBmsWzywFnsFZ/o/5cdjd32T
         auRKQLbQE7HjxJFl/+ecgbDpq1cHrpi9eNLDegan0dFk7k6bhXihlMYspaTU/Fv9dH5e
         D212ALwK+bzQAW3Xup0UzjsFr3QSId/RoZcHouVmaivoaX6jISJ+3mzqZxfw5H7rPYyX
         WBsQ==
X-Gm-Message-State: ANoB5pm5KXgJJ37UQo5vQJ5eD5zkjgntfCDl/2KfWklZJwcPpgXm15K2
        HwMjQszDB9wk9t92mI2AU0zsWw==
X-Google-Smtp-Source: AA0mqf53IjUhz0NUpmCvDHwNUZVIhvLBfrBuGuqctcLItqr8LzS5CanyELMQHPrj/HKH131QMnFrZA==
X-Received: by 2002:a19:c506:0:b0:4b1:c15c:126c with SMTP id w6-20020a19c506000000b004b1c15c126cmr9044037lfe.8.1669474115345;
        Sat, 26 Nov 2022 06:48:35 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id bj35-20020a2eaaa3000000b0026bf43a4d72sm212966ljb.115.2022.11.26.06.48.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Nov 2022 06:48:34 -0800 (PST)
Message-ID: <99c3e666-ec26-07a0-be40-0177dd449d84@linaro.org>
Date:   Sat, 26 Nov 2022 15:48:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/3] dt-bindings: net: sun8i-emac: Fix snps,dwmac.yaml
 inheritance
Content-Language: en-US
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     Samuel Holland <samuel@sholland.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
References: <20221125202008.64595-1-samuel@sholland.org>
 <20221125202008.64595-3-samuel@sholland.org>
 <5b05317d-28cc-bfc8-f415-e6acf453dc7c@linaro.org>
 <20221126142735.47dcca6d@slackpad.lan>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221126142735.47dcca6d@slackpad.lan>
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

On 26/11/2022 15:28, Andre Przywara wrote:
> On Sat, 26 Nov 2022 14:26:25 +0100
> Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:
> 
> Hi,
> 
>> On 25/11/2022 21:20, Samuel Holland wrote:
>>> The sun8i-emac binding extends snps,dwmac.yaml, and should accept all
>>> properties defined there, including "mdio", "resets", and "reset-names".
>>> However, validation currently fails for these properties because the  
>>
>> validation does not fail:
>> make dt_binding_check -> no problems
>>
>> Maybe you meant that DTS do not pass dtbs_check?
> 
> Yes, that's what he meant: If a board actually doesn't have Ethernet
> configured, dt-validate complains. I saw this before, but didn't find
> any solution.
> An example is: $ dt-validate ... sun50i-a64-pinephone-1.2.dtb
> arch/arm64/boot/dts/allwinner/sun50i-a64-pinephone-1.2.dtb:
>   ethernet@1c30000: Unevaluated properties are not allowed ('resets', 'reset-names', 'mdio' were unexpected)
>   From schema: Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> 
> Why exactly is beyond me, but this patch removes this message.

I don't think this should be fixed like this. That's the problem of
dtschema (not ignoring fully disabled nodes) and such patch only moves
from one correct syntax to another correct syntax, which fixes dtschema
problem, but changes nothing here.

Best regards,
Krzysztof

