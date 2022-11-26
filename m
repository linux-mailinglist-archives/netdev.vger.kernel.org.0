Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156D4639619
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 14:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiKZN0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 08:26:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKZN0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 08:26:30 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26C4272C
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 05:26:28 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id b9so8039527ljr.5
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 05:26:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o4HSsW8BSppm65SzOgKkp1ueBN0+yQmM4nOdtdewie4=;
        b=fQ948lgQWtUyPvTbVqFz9q/GMnUuxAq/xfBCHkJL16BWRoGwSi7N3Ll1/vKlrlTWf1
         LN96gsqTnvCQpGN5YjYG10xuR+YaL9zM4L9WUOz8Xvv/hqroWL6TL3HT309cLxm2/KBG
         eCLfmz7owAKXhMPNkUHj3S0eRZidLboTGGrQwNMJE7IkX0/mvqgGT/rW5cwGPyNDqE7l
         ghJ5zdtCgdSttJXsAZjStUGWjArFUF3kjd7WbsSD6HxDO++Jp1lZM81h3ML1cpov6FmI
         82K6z1t3VYJgrwpxQfkNtIMovDVq3xdq/yyUPZ01D40tY1sWMoYYT774LPidZ0QcrhD/
         rlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4HSsW8BSppm65SzOgKkp1ueBN0+yQmM4nOdtdewie4=;
        b=SGUO/lYUCjBQDjNmXCaWv8D9Uoq4uEG3c+Q8UgCCy2bIeCeNY3Fs0WFBqtELBzj7zj
         z/QhPc8WD0fRGPWIq856ju+iyGKkuSALnmrjZFtAKv8Supl0uUYpUp1j146gRv8JIma2
         8B0UwA/4esAlyMlA+uWWK06NWgzuW66+rI9jyGNBjwxBu4697WSY98anE6ttQav4xvpG
         jMs5KimicnGgvrC4rv+vk4wPBxWj4o3vQvENwGlP/dl3pzFbdmi4WP214qu6F53PcrQ0
         sx9JEgR359BcCK7m4WRBqdzY+LTdaUrzVCjGQ39gaBLNqNkyJc9Ds59vejmKLCRGIUZI
         zrPw==
X-Gm-Message-State: ANoB5pndztERQ4DiZavOxIud4Arx80RyXEsYIrn9fh+XTi5iflJ/tQBW
        rgx1BUF+9Jz9LoIxQSMWgCLb4Q==
X-Google-Smtp-Source: AA0mqf4diqUCufc5o5ynb6ePA7iRhvGzndvX4FgyVTV8biyv9XJ3eZhD7JtIGLRQ2Y+XGxyaz98WZg==
X-Received: by 2002:a05:651c:11c1:b0:279:7b1c:9add with SMTP id z1-20020a05651c11c100b002797b1c9addmr5996583ljo.151.1669469187372;
        Sat, 26 Nov 2022 05:26:27 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id y30-20020a0565123f1e00b004a2386b8cf9sm931748lfa.206.2022.11.26.05.26.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Nov 2022 05:26:26 -0800 (PST)
Message-ID: <5b05317d-28cc-bfc8-f415-e6acf453dc7c@linaro.org>
Date:   Sat, 26 Nov 2022 14:26:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 2/3] dt-bindings: net: sun8i-emac: Fix snps,dwmac.yaml
 inheritance
Content-Language: en-US
To:     Samuel Holland <samuel@sholland.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
References: <20221125202008.64595-1-samuel@sholland.org>
 <20221125202008.64595-3-samuel@sholland.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221125202008.64595-3-samuel@sholland.org>
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

On 25/11/2022 21:20, Samuel Holland wrote:
> The sun8i-emac binding extends snps,dwmac.yaml, and should accept all
> properties defined there, including "mdio", "resets", and "reset-names".
> However, validation currently fails for these properties because the

validation does not fail:
make dt_binding_check -> no problems

Maybe you meant that DTS do not pass dtbs_check?


> local binding sets "unevaluatedProperties: false", and snps,dwmac.yaml
> is only included inside an allOf block. Fix this by referencing
> snps,dwmac.yaml at the top level.

There is nothing being fixed here...

> 
> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---
> 
>  .../devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml     | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> index 1432fda3b603..34a47922296d 100644
> --- a/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> +++ b/Documentation/devicetree/bindings/net/allwinner,sun8i-a83t-emac.yaml
> @@ -10,6 +10,8 @@ maintainers:
>    - Chen-Yu Tsai <wens@csie.org>
>    - Maxime Ripard <mripard@kernel.org>
>  
> +$ref: "snps,dwmac.yaml#"
> +
>  properties:
>    compatible:
>      oneOf:
> @@ -60,7 +62,6 @@ required:
>    - syscon
>  
>  allOf:
> -  - $ref: "snps,dwmac.yaml#"
>    - if:
>        properties:
>          compatible:

Best regards,
Krzysztof

