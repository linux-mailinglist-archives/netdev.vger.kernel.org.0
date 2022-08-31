Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9335A779F
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiHaHh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbiHaHh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:37:57 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A82BCCD7
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:37:55 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id bt10so18762976lfb.1
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 00:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=yV0Q/B0XwshgejdYWiZZL4lEpfYH4+n29m2VXh7RRNk=;
        b=Mpb/fFsJGrIPxVaNtfFLx695Ajlwkj/6pjPubbDa2vX34HXKOSRtX3pH/roJ8thsWJ
         7ki51ZrQSa6VVJ9k5Gy6PJtbf5WaVlRNIT2ewDJEh3THVRNGSsRA3j4hGh0fnh/z60lG
         xYl00kkiMj+a2JvQxVKmmKJnfDEa9IR+ooAC1W8YKqQdR2CyEEti0xXZESkMhGoNy0Nk
         RFfjs0TvU9V5pCPHUMlukGeR4Zknvb5dc5dlPJgSAJ4XJmxtoJbbMmSqAna14kt88YMi
         RtFtKN1m9JjpvH9+Lm8cwO+PZgifUid5rXz3oK9cbOWI7ZslDU7EPO86NNbJ+YTeTA0v
         gBvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=yV0Q/B0XwshgejdYWiZZL4lEpfYH4+n29m2VXh7RRNk=;
        b=dahwVFY9C21CUIYjjUDYv363nOf0K+y2W35hLWjDt1v+PnpbhY+zk7yjHdnByTQE/e
         jmhmbyQhisuMOvngI71T6yWMpA6OEpUMUzoVtV/G4WbJu9mdz9QTx5Pp0qSO9Ub6aUSf
         9oEWqL9punUIb04uAiu1lN4uFHb/Sx5MRVdOUiUnV3ytVBJvppFCHMrtiwqgEZVLebsF
         HLApqQP8x5rbL5FFTuP97BlqzsH4wnpMlxO0KJOPx15KjipIvkOsl61nYKDgrxwCG/Pg
         QqDaIu0CJd+98UL+TcSG1f6LRYrTDNFvbSQrgyhn84lsBnV57o3NlGfyUYlOVKAAACS5
         6UrQ==
X-Gm-Message-State: ACgBeo1mG/TnJlAjioCoeMSS2U1uZ3FbxXX0QPc8KQEciki64ruSkm6x
        KKwQNeOLfbU1/8PJvgughVolSA==
X-Google-Smtp-Source: AA6agR5boSacIQqXB/d2C7VV98i93eO6195dqw6oNKs9ez+yXfxtG4ZM3h9pwXz9k+QFVj5F3myy2w==
X-Received: by 2002:a05:6512:92f:b0:494:7095:135f with SMTP id f15-20020a056512092f00b004947095135fmr3223951lft.242.1661931473787;
        Wed, 31 Aug 2022 00:37:53 -0700 (PDT)
Received: from [192.168.28.124] (balticom-73-99-134.balticom.lv. [109.73.99.134])
        by smtp.gmail.com with ESMTPSA id a3-20020ac25e63000000b004947fbc5d28sm434943lfr.303.2022.08.31.00.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Aug 2022 00:37:53 -0700 (PDT)
Message-ID: <e0afa0fc-4718-2aa1-2555-4ebb2274850b@linaro.org>
Date:   Wed, 31 Aug 2022 10:37:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v1 08/14] dt-bindings: mtd: relax the nvmem compatible
 string
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-9-michael@walle.cc>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220825214423.903672-9-michael@walle.cc>
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

On 26/08/2022 00:44, Michael Walle wrote:
> The "user-otp" and "factory-otp" compatible string just depicts a
> generic NVMEM device. But an actual device tree node might as well
> contain a more specific compatible string. Make it possible to add
> more specific binding elsewere and just match part of the compatibles

typo: elsewhere

> here.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  Documentation/devicetree/bindings/mtd/mtd.yaml | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mtd/mtd.yaml b/Documentation/devicetree/bindings/mtd/mtd.yaml
> index 376b679cfc70..0291e439b6a6 100644
> --- a/Documentation/devicetree/bindings/mtd/mtd.yaml
> +++ b/Documentation/devicetree/bindings/mtd/mtd.yaml
> @@ -33,9 +33,10 @@ patternProperties:
>  
>      properties:
>        compatible:
> -        enum:
> -          - user-otp
> -          - factory-otp
> +        contains:
> +          enum:
> +            - user-otp
> +            - factory-otp

This does not work in the "elsewhere" place. You need to use similar
approach as we do for syscon or primecell.

>  
>      required:
>        - compatible


Best regards,
Krzysztof
