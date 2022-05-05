Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493DD51CA83
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 22:24:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384831AbiEEU1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 16:27:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384539AbiEEU1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 16:27:50 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0195EDF3
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 13:24:09 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id q20so3315470wmq.1
        for <netdev@vger.kernel.org>; Thu, 05 May 2022 13:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0m+MAH53hS5P1EannDL6w5zPjpYrBEhq4qwoGkSwZuU=;
        b=jra6JLnzGBBA3osFG+6nfF8s0GYUwShF1bXzFzWMxR/rZ5abxQ93S2cutgg+iMVJlT
         gF7ILiCcc+lbCBI4kOoyCCC+pxeaZKNT3OTvr++8DZR0ZxU6qbdiCk2yEG1QXa5J1ZQO
         54br+XTn4VPvWJDP/ayGSFQ1RBUUrw/zRVsxJWMyt2jRrdUNHJgdyRIiHCtJrCrPszsU
         TQZ0LLdE/GpkOOOpyd5VV7S/xZtD5SLFlHhw4Pi0Ph9SMP4+8ZjksSKZQ1mrrWtpx6xk
         2NOG5UMTNo7ppzmHU1DgquJhnp5Fv5aBuej5PIMps8MkMPaa7Z+hXBoRnnzSDP1QwbvJ
         m7oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0m+MAH53hS5P1EannDL6w5zPjpYrBEhq4qwoGkSwZuU=;
        b=S7e4eZJk3Ut7iNdYmNolRcwWJx+Hzz/Sm2seTh9AJxgcuGQt57BcIWN+TD4V77RGYf
         7gEcjs3Fbqx0faU6d/iX9xIFns7EIe5FUVOo09GHpWyUON5HVoY59+BD4JD0ACFRaHd1
         cyhR7iC7QuaX8BsaziJhdzXKJMxbZ8lIT5Br6QIFKGRM7/yALM71cSl3RN/ix0BDD5yl
         UhFg0I3iJcv/DSwiXX9OsKgYY4opdeqreSu9/7udnXEjk2sM3a20lcXa8wdZNPicimr5
         5JBXjnI7V2zVZTvZghktaJXVSXbTANah0+RnN1SIQx8y30Ov/0xwBvr/6KQIlLXbR9rl
         TQ/Q==
X-Gm-Message-State: AOAM533FSmzivG1Qa6STMsjL6c8kQp3ym6TpJR4gRV1WjGDwBQAm2/s+
        9D2cNpKpBukEIK1G2HUjwXUlBw==
X-Google-Smtp-Source: ABdhPJzggBRPK/gNppxALBB1ELnpQjl1CUeqdi2mA/5JOKzx4ur1UNxWVrR4SwptL49VPjnAn3iZtA==
X-Received: by 2002:a05:600c:1f17:b0:392:5c1a:5ed9 with SMTP id bd23-20020a05600c1f1700b003925c1a5ed9mr6855434wmb.148.1651782247689;
        Thu, 05 May 2022 13:24:07 -0700 (PDT)
Received: from [192.168.0.222] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id p11-20020a1c544b000000b003942a244f30sm7713475wmi.9.2022.05.05.13.24.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 May 2022 13:24:06 -0700 (PDT)
Message-ID: <22f2a54a-12ac-26a7-4175-1edfed2e74de@linaro.org>
Date:   Thu, 5 May 2022 22:24:05 +0200
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220428082848.12191-2-josua@solid-run.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2022 10:28, Josua Mayer wrote:

Thank you for your patch. There is something to discuss/improve.

> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> index 1129f2b58e98..3e0c6304f190 100644
> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -36,6 +36,23 @@ properties:
>      enum: [ 4, 8, 12, 16, 20, 24 ]
>      default: 8
>  
> +  adi,phy-output-clock:
> +    description: Select clock output on GP_CLK pin. Three clocks are available:
> +      A 25MHz reference, a free-running 125MHz and a recovered 125MHz.
> +      The phy can also automatically switch between the reference and the
> +      respective 125MHz clocks based on its internal state.
> +    $ref: /schemas/types.yaml#/definitions/string
> +    enum:
> +    - 25mhz-reference
> +    - 125mhz-free-running
> +    - 125mhz-recovered
> +    - adaptive-free-running
> +    - adaptive-recovered

Missing two spaces of indentation for all these items.

> +
> +  adi,phy-output-reference-clock:
> +    description: Enable 25MHz reference clock output on CLK25_REF pin.
> +    $ref: /schemas/types.yaml#/definitions/flag

This could be just "type:boolean".

Best regards,
Krzysztof
