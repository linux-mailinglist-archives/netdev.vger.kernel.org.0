Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A76F5A695E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 19:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiH3RPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 13:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiH3RO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 13:14:58 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6D415811
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:14:56 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id j14so6099166lfu.4
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=wqM8poQSBkP5+AJNOGOym7LP5PEFsyVQuT3qGSt/MeQ=;
        b=t8SfeBC0CMrKUskuld6g6k95a+OrKLt1l4p4i4wYP5WfVoRA9m4tYKjPyeefFS2Sth
         W1k3LmTakdmvBcyR4Of4koYIRweWQg1g2QJ4DIBUy63ug74x8XdiZhKyg5c8s9mnL3w2
         OMf8+BGfeuk97J9Kb/7Bciy1t29Izl5eUd7Qfwrs+K2XPZlN3lCL1uoP3U+yPLarKhbI
         j3hiitXgHkTlYj/jZcEyCynSBMBxjlotKnR9RFOh5Z8i37jEyurjLHMi7qvxxj4/VDl9
         rN1+tbMgUjAexZWmGr9d34icgOVS3D99IvFNGEc29Q7A7JRku2sQ4VSnOgO7GnRMm0bX
         UwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=wqM8poQSBkP5+AJNOGOym7LP5PEFsyVQuT3qGSt/MeQ=;
        b=4zyeV0e99W+GJ6JwZSZHsoiYagV07qyYn2rE4DJvkyPFe/MlQx6nGzHDSulMj2Ii52
         JxmBnSklplwObDOhndZfHXrMzto+mL4/amWB+fdchlTbkGqGLAJ2XwyaGHMaRG73KskN
         +tHiiLqNuQSV0rPmuKpjEZK4xJC5Nlow4wZ/p4soMsSVlrYoeuMndQT+OIo6sNbt+8ER
         guSw/LZJiqVamvgi65CohGX6LHGxyk4bCIhU1U5f5DnYVU60eKMDwJALmG2J/8/fI7xO
         zMVnGjhBwo5fou1JGs7IjNZwbjzkxfs1Xb8q2BkfhzYWFsWy5ig7vbbjNv3j8VLkHRWs
         AtlQ==
X-Gm-Message-State: ACgBeo3oAib8iaLl5JErzR31FGW0LNy+eoTKeCB0lRF4wJIOBkGRmxPi
        FZ8jgH5OKgy2sf4gmxkHFKGzXQ==
X-Google-Smtp-Source: AA6agR7f3qJImjMtLOVfjApYz2NAbNuJJj7Daybtc1K7dNVuZS10wfEilsUloLI82Iu8FA5wnfynyQ==
X-Received: by 2002:a05:6512:159b:b0:492:c1c0:5aab with SMTP id bp27-20020a056512159b00b00492c1c05aabmr7875077lfb.523.1661879694642;
        Tue, 30 Aug 2022 10:14:54 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id c17-20020a05651200d100b00492ea54beeasm384652lfp.306.2022.08.30.10.14.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 10:14:53 -0700 (PDT)
Message-ID: <c8236663-055c-d6da-64ed-ae3f7fb2e690@linaro.org>
Date:   Tue, 30 Aug 2022 20:14:52 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v2 5/5] dt-bindings: net: altera: tse: add an
 optional pcs register range
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
References: <20220830095549.120625-1-maxime.chevallier@bootlin.com>
 <20220830095549.120625-6-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220830095549.120625-6-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/08/2022 12:55, Maxime Chevallier wrote:
> Some implementations of the TSE have their PCS as an external bloc,
> exposed at its own register range. Document this, and add a new example
> showing a case using the pcs and the new phylink conversion to connect
> an sfp port to a TSE mac.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> V1->V2 :
>  - Fixed example
> 
>  .../devicetree/bindings/net/altr,tse.yaml     | 29 ++++++++++++++++++-
>  1 file changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/altr,tse.yaml b/Documentation/devicetree/bindings/net/altr,tse.yaml
> index 1676e13b8c64..4b314861a831 100644
> --- a/Documentation/devicetree/bindings/net/altr,tse.yaml
> +++ b/Documentation/devicetree/bindings/net/altr,tse.yaml
> @@ -39,6 +39,7 @@ allOf:
>        properties:
>          reg:
>            minItems: 6
> +          maxItems: 7
>          reg-names:
>            minItems: 6
>            items:
> @@ -48,6 +49,7 @@ allOf:
>              - const: rx_resp
>              - const: tx_csr
>              - const: tx_desc
> +            - const: pcs
>  
>  properties:
>    compatible:
> @@ -58,7 +60,7 @@ properties:
>  
>    reg:
>      minItems: 4
> -    maxItems: 6
> +    maxItems: 7
>  
>    reg-names:
>      minItems: 4
> @@ -69,6 +71,7 @@ properties:
>        - const: rx_resp
>        - const: tx_csr
>        - const: tx_desc
> +      - const: pcs
>        - const: s1
>  

So now 8 items?

>    interrupts:
> @@ -122,6 +125,30 @@ required:
>  unevaluatedProperties: false
>  
>  examples:
> +  - |
> +    tse_sub_0: ethernet@c0100000 {
> +        compatible = "altr,tse-msgdma-1.0";
> +        reg = <0xc0100000 0x00000400>,
> +              <0xc0101000 0x00000020>,
> +              <0xc0102000 0x00000020>,
> +              <0xc0103000 0x00000008>,
> +              <0xc0104000 0x00000020>,
> +              <0xc0105000 0x00000020>,
> +              <0xc0106000 0x00000100>;
> +        reg-names = "control_port", "rx_csr", "rx_desc", "rx_resp", "tx_csr", "tx_desc", "pcs";
> +        interrupt-parent = <&intc>;
> +        interrupts = <0 44 4>,<0 45 4>;
> +        interrupt-names = "rx_irq","tx_irq";
> +        rx-fifo-depth = <2048>;
> +        tx-fifo-depth = <2048>;
> +        max-frame-size = <1500>;
> +        local-mac-address = [ 00 0C ED 00 00 02 ];

00 00 00 00 00 00
(easier to spot that it is invalid)

Best regards,
Krzysztof
