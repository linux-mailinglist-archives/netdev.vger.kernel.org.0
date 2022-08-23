Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF5A59E4AD
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 15:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiHWNvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 09:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242349AbiHWNuh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 09:50:37 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C2C116571C
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:56:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b16so17515459edd.4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:56:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=CSfrhxT9VAnyJPjGSsK9FNWQxpzeB1/ysg0wyIKwNbo=;
        b=o+1s4+z44hI/KKr1Dk4qJ+cnrbPWDs8HpV/rQFs3+CacWfFtNXfe9dRvuqwkZRw1kc
         TbHlDRTcqTMkXvetmyrOJRl2dnEHtlVHiI/uo/qjVW9u8NexN9+2pO3bWk35B/ENgxbW
         PuyaXqnI/SSRC6U+OAa0UKqeKmsWjGhgBlaDxpIAzd/pNZtq0pWCHTY3lRym0DhiuZcU
         MEzvyxnEMTVFLDatcNczSPVgp6fbw7xKUfEq4R66aCk71Wu3cONBdxp6IuyaqMrlJ5T6
         67b0sOLDYkPeo95GXojgq758B2zAOnGyFmq/dkizAnzzjanAQ7dUQPg0y9qY9CULa868
         WH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=CSfrhxT9VAnyJPjGSsK9FNWQxpzeB1/ysg0wyIKwNbo=;
        b=5G2RDx3c6idyjcXNh9fv1qfTZHYIgam4dUXqHuUJu0c0/HzyJlvHTb6Sqx8aCmIAEE
         IXgE6aNZNAfK/b7cDhO2tii7BHXUP0vA2IrjLhjQuK1+qhIWHphmiM09NzberDfUlOhy
         3/xoBYyzo7TFMuX5InHhSQb5uxSNTj/LPehOI+g5sYsJOxJ5ta4jGGKspSAKsIDokDDJ
         nR1Dq5keUG53x7768EeoDHe9ISD6lkpZXAs9JhIp7p2/qXpmqN3/ef4b9mtCHTPV1Q/9
         TPN66nZ8eef3rEapa2eu/a69uBljBRqz1HEE2tPgPQmUySwUECxfuVmN4HxsCqcUzbKB
         IcBw==
X-Gm-Message-State: ACgBeo2jnhXHLypCJ3yNc0OwDcHr8Wl9ehhAQ4LnkZgtZ9IFFVNU+drf
        xX5cCpvQFhE7FOEA0MOIYQdA9BfxLWMoUl0A
X-Google-Smtp-Source: AA6agR4oA347epn9X35znOZfjzfSU5oXZ19wKjNx051aYhSs5BsqebDkkBZnPa3Fk9VNmwyv6D3b3w==
X-Received: by 2002:a05:6512:1322:b0:492:de5b:dc3c with SMTP id x34-20020a056512132200b00492de5bdc3cmr3880326lfu.503.1661251242988;
        Tue, 23 Aug 2022 03:40:42 -0700 (PDT)
Received: from [192.168.0.11] (89-27-92-210.bb.dnainternet.fi. [89.27.92.210])
        by smtp.gmail.com with ESMTPSA id t20-20020a2e8e74000000b0025e1ec74e25sm2300758ljk.43.2022.08.23.03.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 03:40:42 -0700 (PDT)
Message-ID: <70ae25b9-0500-7539-d71f-52c685783554@linaro.org>
Date:   Tue, 23 Aug 2022 13:40:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v4 1/6] dt-bindings: net: dsa: mediatek,mt7530: make
 trivial changes
Content-Language: en-US
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Sander Vanheule <sander@svanheule.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Daniel Golle <daniel@makrotopia.org>, erkin.bozoglu@xeront.com,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh@kernel.org>
References: <20220820080758.9829-1-arinc.unal@arinc9.com>
 <20220820080758.9829-2-arinc.unal@arinc9.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220820080758.9829-2-arinc.unal@arinc9.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2022 11:07, Arınç ÜNAL wrote:
> Make trivial changes on the binding.
> 
> - Update title to include MT7531 switch.
> - Add me as a maintainer. List maintainers in alphabetical order by first
> name.
> - Add description to compatible strings.
> - Stretch descriptions up to the 80 character limit.
> - Remove quotes from $ref: "dsa.yaml#".
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Rob Herring <robh@kernel.org>
> ---
>  .../bindings/net/dsa/mediatek,mt7530.yaml     | 36 ++++++++++++-------
>  1 file changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> index 17ab6c69ecc7..edf48e917173 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
> @@ -4,12 +4,13 @@
>  $id: http://devicetree.org/schemas/net/dsa/mediatek,mt7530.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Mediatek MT7530 Ethernet switch
> +title: Mediatek MT7530 and MT7531 Ethernet Switches
>  
>  maintainers:
> -  - Sean Wang <sean.wang@mediatek.com>
> +  - Arınç ÜNAL <arinc.unal@arinc9.com>
>    - Landen Chao <Landen.Chao@mediatek.com>
>    - DENG Qingfang <dqfext@gmail.com>
> +  - Sean Wang <sean.wang@mediatek.com>
>  
>  description: |
>    Port 5 of mt7530 and mt7621 switch is muxed between:
> @@ -61,10 +62,21 @@ description: |
>  
>  properties:
>    compatible:
> -    enum:
> -      - mediatek,mt7530
> -      - mediatek,mt7531
> -      - mediatek,mt7621
> +    oneOf:
> +      - description:
> +          Standalone MT7530 and multi-chip module MT7530 in MT7623AI SoC
> +        items:

You have one item, so don't make it a list. Just const:xxxxx

Same in other places.


Best regards,
Krzysztof
