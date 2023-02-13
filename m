Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F22D6940A1
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjBMJRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjBMJRD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:17:03 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB7413DC7
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:16:57 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id y1so11391584wru.2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h74cDQbgTdYncRWX3Uv32ARg+TAO4xNXRfIu6VensXg=;
        b=PB29dGCSLCehErz5UeBpdIOyvUGN56QP4ynMmbXeBxyEGhFJ7uSuTgA/Rlw71C66OZ
         f00/AxjW5MnvGhuwbFF7LycdMP0seIbtfJUYw1xhsLRwMcKrkhIPjiKTtTMjkuvc2q1s
         kF8Iq9c1/x8WltmS0xjbdYk9PaKhnq2cVegZs6nx7Dl2Zb1g+VXnWEYBwWO1WJD+/N99
         2BpFoHBkfPkwUZRuRyjtevZuMLz5YlzE0A6zv0KoZ2hL9MQ8tuwZtHh5Itn7ARaCUvXF
         QlX8FQZiFvP4NfpbawPmAAQRyYCZp+s25aUrHEY7P9EBzoh3+twL+vbkBFtMEmTndU81
         ndUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h74cDQbgTdYncRWX3Uv32ARg+TAO4xNXRfIu6VensXg=;
        b=ldfUuIIGwn1oKorqIwdHXYWAi+lnwDUO7V6xHsLdSAWbLU0hpGxhlMFlKrjbiXbk20
         6dFo/ueoVV40wnBNslVTBDp64FQAeRcIaAUhXbLDgrFjHhzhyDBNCdL1Of/AT1N/7SJ/
         DsUjmPIGPtE3eU6cuggyU3eykWWlH3Hfwgn0xn6k09edJCjWEk4rj8LFb5bZLcXFipZY
         iJFVncqGW9NkzP/IJ1T80W4mrd+Qlq1K5U9JafofhzF1TDeC2puNf50X+fiVs/xzax5u
         8uyNfjoKnGa8VJ7ubSguGiq9YfbHmI3rvkkybFkBru6pLZ+026yPTCFVLq843l+Q8Kl6
         2arg==
X-Gm-Message-State: AO0yUKVvKQDFseQJVFKlTlLfT4CJCbTG3ieeokPjMoU5ebwf0r6xbyNN
        dUyzb0G7JGklnrFwfIRB5nwNtq8vaHIT+MLk
X-Google-Smtp-Source: AK7set+IshfpqoWnvctuQzvDvkpgdvAbbagtzROSYTvPetRlM7bQOGDBLySLCCSZsdmI7Nz/eTh+Kg==
X-Received: by 2002:adf:cd84:0:b0:2c3:dafd:c729 with SMTP id q4-20020adfcd84000000b002c3dafdc729mr20385856wrj.47.1676279816339;
        Mon, 13 Feb 2023 01:16:56 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id v14-20020adfe28e000000b0027cb20605e3sm9983692wri.105.2023.02.13.01.16.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:16:56 -0800 (PST)
Message-ID: <0000e9d1-7876-0830-4ec3-dadc69f8c54d@linaro.org>
Date:   Mon, 13 Feb 2023 10:16:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v5 04/12] dt-bindings: arm: mediatek: sgmiisys: add MT7981
 SoC
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Jianhui Zhao <zhaojh329@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
References: <cover.1676128246.git.daniel@makrotopia.org>
 <7273678366079b93ee19c4c6f6ea9bc13cd8dcfb.1676128246.git.daniel@makrotopia.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <7273678366079b93ee19c4c6f6ea9bc13cd8dcfb.1676128246.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 17:02, Daniel Golle wrote:
> Add mediatek,pnswap boolean property as well as an example for the
> MediaTek MT7981 SoC making use of that new property.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  .../arm/mediatek/mediatek,sgmiisys.yaml       | 22 +++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
> index 99ceb08ad7c0..97d4ab70e541 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,sgmiisys.yaml
> @@ -23,6 +23,8 @@ properties:
>            - enum:
>                - mediatek,mt7622-sgmiisys
>                - mediatek,mt7629-sgmiisys
> +              - mediatek,mt7981-sgmiisys_0
> +              - mediatek,mt7981-sgmiisys_1
>                - mediatek,mt7986-sgmiisys_0
>                - mediatek,mt7986-sgmiisys_1
>            - const: syscon
> @@ -33,6 +35,10 @@ properties:
>    '#clock-cells':
>      const: 1
>  
> +  mediatek,pnswap:
> +    description: Invert polarity of the SGMII data lanes
> +    type: boolean
> +
>  required:
>    - compatible
>    - reg
> @@ -51,3 +57,19 @@ examples:
>          #clock-cells = <1>;
>        };
>      };
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +      sgmiisys0: syscon@10060000 {
> +        compatible = "mediatek,mt7981-sgmiisys_0", "syscon";
> +        reg = <0 0x10060000 0 0x1000>;
> +        mediatek,pnswap;

No really need for three almost the same nodes. Just choose one - with
or without pnswap.

Best regards,
Krzysztof

