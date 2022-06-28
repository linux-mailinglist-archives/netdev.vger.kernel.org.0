Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9A955D01D
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344047AbiF1Izv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 04:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245665AbiF1Izu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 04:55:50 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B45A2DAA4
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:55:49 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q9so16627584wrd.8
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 01:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cXLmon6E49fL49p54fzyHUVUDFyaMPORq7KTqI3rgOA=;
        b=ma57vO6HCuMAlmIr8zOwYVtBRcU1EVRuDsTdG565qfs2EP6TN4bo4VbRpm9D62pJIU
         FO9uqMvBvkNMrPZqy3bDnwcSLe4i5/VUM524oLW2hKRqNT1Sz7NAgDnQzxQqwp/O/7aw
         r3WKrAyN0Xz3BdmiAXARjUwv+XQuUZGtkfEjR8+DGOpKvTDGyC8UFw/UWMrNc4n0got4
         wHR7SUTHJOiPiRJ2IhZVKpgcHzYHOei0z7+jMFFdy3qgoi1YzRs6E2Jb9k7DFsplkXkr
         vvu77wUuJQl5BVJN6PE51OeMYF81EbPBfkYWTqmBQttnU5FfNOPS8Yirv0ylD5WVQzF+
         cAMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cXLmon6E49fL49p54fzyHUVUDFyaMPORq7KTqI3rgOA=;
        b=vDF/3l3ijeULOdzPG6x8w0j1W8JuaZptH+0nH59nEE1zKfZOm1rGtNe2/1SDTYEJHG
         qfC7DauVWEG0vzDg0huWYNOewWr9nLADuNbQ2kQ9c+XXl4GWybOmEZAGEJNfO1Gs0nsF
         LIOE6aBalmGNWWyDc9Iun3e62C//v6jMjqhAzK6ZawQyThKxrECK7OR0qJ40CemWdq8C
         DDRNyu5eurAkigkWBlu1CrJOsc96/K6GT5RKDAy064UdUlnQaiI4eoU1ir/4b6imcxQY
         OcMdWVOWZp4bdI5RwjdylJIj/vXKK7tTJz2RIDWMzfps+AHcAexW16WdmGxftE4gjgpm
         Nsiw==
X-Gm-Message-State: AJIora92lPDQooUkvU2hAUaLrezQ/nzRzCiavL4XIb8l1XI3U3EL3QVh
        FDfqhsGVzv5GVleuP2IXpJQfUA==
X-Google-Smtp-Source: AGRyM1tgUbi0oAWiikQJqtra7mLXj++mz8ELXO0S8dEK+u8aBzZ56Xs6gJu/W3txzLVLpIZ2aT7xqQ==
X-Received: by 2002:a05:6000:102:b0:21b:9219:b28e with SMTP id o2-20020a056000010200b0021b9219b28emr16556920wrx.236.1656406548002;
        Tue, 28 Jun 2022 01:55:48 -0700 (PDT)
Received: from [192.168.0.252] (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id w13-20020a5d680d000000b0021b93a483dbsm12992800wru.32.2022.06.28.01.55.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jun 2022 01:55:47 -0700 (PDT)
Message-ID: <00c7c730-eb20-8d2e-713e-3e592a6d3b89@linaro.org>
Date:   Tue, 28 Jun 2022 10:55:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCHv2 2/2] dt-bindings: net: rockchip-dwmac: add rk3588 gmac
 compatible
Content-Language: en-US
To:     Sebastian Reichel <sebastian.reichel@collabora.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        kernel@collabora.com
References: <20220627170747.137386-1-sebastian.reichel@collabora.com>
 <20220627170747.137386-3-sebastian.reichel@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220627170747.137386-3-sebastian.reichel@collabora.com>
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

On 27/06/2022 19:07, Sebastian Reichel wrote:
> Add compatible string for RK3588 gmac, which is similar to the RK3568
> one, but needs another syscon device for clock selection.
> 
> Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
> ---
>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml     | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> index 083623c8d718..1783f5eb9e50 100644
> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
> @@ -25,6 +25,7 @@ select:
>            - rockchip,rk3368-gmac
>            - rockchip,rk3399-gmac
>            - rockchip,rk3568-gmac
> +          - rockchip,rk3588-gmac
>            - rockchip,rv1108-gmac
>    required:
>      - compatible
> @@ -50,6 +51,7 @@ properties:
>        - items:
>            - enum:
>                - rockchip,rk3568-gmac
> +              - rockchip,rk3588-gmac
>            - const: snps,dwmac-4.20a
>  
>    clocks:
> @@ -81,6 +83,10 @@ properties:
>      description: The phandle of the syscon node for the general register file.
>      $ref: /schemas/types.yaml#/definitions/phandle
>  
> +  rockchip,php-grf:
> +    description: The phandle of the syscon node for the peripheral general register file.

Please wrap at 80.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof
