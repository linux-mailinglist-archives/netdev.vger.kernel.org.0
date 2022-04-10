Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C744FAE35
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 16:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234839AbiDJOX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 10:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiDJOX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 10:23:28 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9926A2DDC
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 07:21:17 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id d10so15360435edj.0
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 07:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gASwY+f09SO5oiW5x66yrb2J4rEaxxvdloIBdLoK01c=;
        b=e/AfcBUZz/I6dQBcG0szDceGXWgFlW/wbJNS/VX67Nz45hF1tycMdCx66pQ1vFMpyp
         1BXEkDVAElfPUdxXpdnYTtpdN0hqfRm68+v/bN/3nnxSE9MmdDBk/tV1j1KbcGlp2Wj0
         PlL3yl8EEoBBJuqBg90w474M+GYOP16ZPPquli/B1eLngI2tcsyOZ5hFiPvFYj2pEG3+
         XLdAazsP5Mi/uq6BlhaISpeSC/0jkfNIpySwtc/IhPGPoJZigHY9lAOSfl1/zztYt0cF
         DIvIFsEMZyGHBZQiaz/b2Z0XKPgMuWK1qVKGFRLKcMbHVkQTL9vqSd7jyJZ2RdYDIqIn
         GK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gASwY+f09SO5oiW5x66yrb2J4rEaxxvdloIBdLoK01c=;
        b=CmcmnoJQW5onDc+eFgn4twfy8bdwJlV1xOwJAsLwB5NnJNjllNYBJXPAgbFaw7PJS7
         RqZai3kv9/Wmj9t5RH/M13qVBV4cTgeL85hQamKW9oJt9A+YurDuaMloc45jN68SVE4h
         TG6rgXfJzt1ywbZOLB6xa7LMR6shMCwcxImZWZo+BK2de+AZY0lDQ7cSoueZntrDEAVg
         a5/7FPdGH+yUqg5pdT/NQ644YPmrg+QRnxT3/N51JkQOCUTqEVA4aCHZZPtb9QwG+hJp
         p7zdduDEpjSk+z2VchfStb887kMtACMNLBy3WXYJh9rApWg0+Ke4mat45uG1W9Y7R3XN
         H6qQ==
X-Gm-Message-State: AOAM53009zZeYLQNSIdrQeaf0IY1T96xgNjBvnp/gbn23NMOdiq3QvOq
        I9tPJpvdOPACvJDwN1iqZaz7Fg==
X-Google-Smtp-Source: ABdhPJyKeIy9IbPa1hQatqb5BRFa35YVOEJwgcrBX8rFUHpF1iecs/u5V56E3PSQLG3qMbNXF6NUxA==
X-Received: by 2002:aa7:d059:0:b0:41d:76b4:bcc1 with SMTP id n25-20020aa7d059000000b0041d76b4bcc1mr3564348edo.389.1649600476067;
        Sun, 10 Apr 2022 07:21:16 -0700 (PDT)
Received: from [192.168.0.188] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.gmail.com with ESMTPSA id q22-20020a170906771600b006cf8a37ebf5sm10892537ejm.103.2022.04.10.07.21.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Apr 2022 07:21:15 -0700 (PDT)
Message-ID: <d83be897-55ee-25d2-4048-586646cd7151@linaro.org>
Date:   Sun, 10 Apr 2022 16:21:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/3] dt: adin: document clk-out property
Content-Language: en-US
To:     Josua Mayer <josua@solid-run.com>, netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
References: <20220410104626.11517-1-josua@solid-run.com>
 <20220410104626.11517-2-josua@solid-run.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220410104626.11517-2-josua@solid-run.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/04/2022 12:46, Josua Mayer wrote:
> The ADIN1300 supports generating certain clocks on its GP_CLK pin.
> Add a DT property to specify the frequency.
> 
> Due to the complexity of the clock configuration register, for now only
> 125MHz is documented.

Thank you for your patch. There is something to discuss/improve.

Adjust subject prefix to the subsystem (dt-bindings, not dt, missing net).

> 
> Signed-off-by: Josua Mayer <josua@solid-run.com>
> ---
>  Documentation/devicetree/bindings/net/adi,adin.yaml | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/adi,adin.yaml b/Documentation/devicetree/bindings/net/adi,adin.yaml
> index 1129f2b58e98..4e421bf5193d 100644
> --- a/Documentation/devicetree/bindings/net/adi,adin.yaml
> +++ b/Documentation/devicetree/bindings/net/adi,adin.yaml
> @@ -36,6 +36,11 @@ properties:
>      enum: [ 4, 8, 12, 16, 20, 24 ]
>      default: 8
>  
> +  adi,clk-out-frequency:

Use types defined by the dtschema, so "adi,clk-out-hz". Then no need for
type/ref.

> +    description: Clock output frequency in Hertz.
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    enum: [125000000]

If only one value, then "const: 125000000", but why do you need such
value in DT if it is always the same?


Best regards,
Krzysztof
