Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9C359E8EC
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiHWRRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:17:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbiHWRRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:17:09 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF93CAB079
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 06:41:52 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bt10so6746045lfb.1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 06:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=94ObA0sxNMfnUjuPe8k5nNJuRKk7+0BvBgJlyDjNB6U=;
        b=MDkEhUd3g66BHtv8ayb5PFnYCSFsUOgMs1J3OFRtFIDpx5xhG7xgYbSmjimRv6ufky
         0wfiKTXYXbklnpVEt8tDV6m2bVs5LPglAFfaoUDTPIGO+GoX/RuIhFzfuv6ktR2mq6Bm
         XslsG1lxC6yywPsVcLVlAjbeWcpCz2+qrLnSTa7/rLHuRufNM/MTRldUkatcSxYQuae7
         4G8OafImliELiwM/yF4BMHPZa6QWfkELACZZ74akC/cKMfVHwJ1t5R4ZXZDHXtC3EhHW
         DMI7bWkl64txNuxh2FKPvy0o+5mFvYDc7zCn7cjkMOtZFrBAJALhoUCrkv9loDPHUF1f
         8SkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=94ObA0sxNMfnUjuPe8k5nNJuRKk7+0BvBgJlyDjNB6U=;
        b=xPWgkHFR8UrdNe3QDh58wzWTBL8EWlr9UnZqz2y0dylnar9WDvE4/PMPOCKs49itVd
         TWRWv6VkmTOmdttG8nw7cD0HaoJmi80THFa3AV2u2wPOFiBYbiNZ0MsCougElEVZqDwS
         ATA1IMMmgF1kRzff6NbSo2n5Jt8Y+IDRDxKQvuheZHvTAlygGaPCVyqC9YQzamufUu6D
         Ym8SliftPTY1KvELeERtY3ejOu9v0gEUtFQfn5ibAI8aylEW4aLUoZnIFjVFYVvlioo6
         0bAoq0FqhkLWboTfGTsPpMmkx9hjmrKpvek/47jdqdpAAgmoZzAWkbwjD+v3hJZPYuDx
         Xm4w==
X-Gm-Message-State: ACgBeo1Tt2bNDBOVJ5rMbp06PVpHe49ioDn6ZL3LvvpyREWW44vFLF0V
        Nfd7g1Ggoqf6NtTovsqgXbIOIw==
X-Google-Smtp-Source: AA6agR54aEjYHox84XnSc1aRIIM9Si6SlFqPQS60naXJqyyEDfTdI9sa1/BQZa7FkPZn6RojlDJEQQ==
X-Received: by 2002:a05:6512:39d3:b0:492:e172:e313 with SMTP id k19-20020a05651239d300b00492e172e313mr3623919lfu.628.1661262111019;
        Tue, 23 Aug 2022 06:41:51 -0700 (PDT)
Received: from [192.168.0.11] (89-27-92-210.bb.dnainternet.fi. [89.27.92.210])
        by smtp.gmail.com with ESMTPSA id p16-20020ac24ed0000000b0048b1b2233ddsm1493031lfr.120.2022.08.23.06.41.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 06:41:49 -0700 (PDT)
Message-ID: <fe2041cc-dd8b-6695-1fc8-6c1c49dd7220@linaro.org>
Date:   Tue, 23 Aug 2022 16:41:44 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [RFC PATCH v2 1/4] dt-bindings: net: can: add STM32 bxcan DT
 bindings
Content-Language: en-US
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        linux-kernel@vger.kernel.org
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        michael@amarulasolutions.com, Dario Binacchi <dariobin@libero.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
References: <20220820082936.686924-1-dario.binacchi@amarulasolutions.com>
 <20220820082936.686924-2-dario.binacchi@amarulasolutions.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220820082936.686924-2-dario.binacchi@amarulasolutions.com>
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

On 20/08/2022 11:29, Dario Binacchi wrote:
> Add documentation of device tree bindings for the STM32 basic extended
> CAN (bxcan) controller.
> 
> Signed-off-by: Dario Binacchi <dariobin@libero.it>
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> 
> ---
> 
> Changes in v2:
> - Change the file name into 'st,stm32-bxcan-core.yaml'.
> - Rename compatibles:
>   - st,stm32-bxcan-core -> st,stm32f4-bxcan-core
>   - st,stm32-bxcan -> st,stm32f4-bxcan
> - Rename master property to st,can-master.
> - Remove the status property from the example.
> - Put the node child properties as required.
> 
>  .../bindings/net/can/st,stm32-bxcan.yaml      | 136 ++++++++++++++++++
>  1 file changed, 136 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> new file mode 100644
> index 000000000000..288631b5556d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/st,stm32-bxcan.yaml
> @@ -0,0 +1,136 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/can/st,stm32-bxcan.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: STMicroelectronics bxCAN controller
> +
> +description: STMicroelectronics BxCAN controller for CAN bus
> +
> +maintainers:
> +  - Dario Binacchi <dario.binacchi@amarulasolutions.com>
> +
> +allOf:
> +  - $ref: can-controller.yaml#
> +
> +properties:
> +  compatible:
> +    enum:
> +      - st,stm32f4-bxcan-core
> +
> +  reg:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  clocks:
> +    description:
> +      Input clock for registers access
> +    maxItems: 1
> +
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 0
> +
> +additionalProperties: false
> +
> +required:
> +  - compatible
> +  - reg
> +  - resets
> +  - clocks
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +patternProperties:

No improvements here, so my comment stay. Please fix it.


> +  "^can@[0-9]+$":
> +    type: object
> +    description:
> +      A CAN block node contains two subnodes, representing each one a CAN
> +      instance available on the machine.

I still do not understand why you need children. You did not CC me on
driver change, so difficult to say. You did not describe the parent
device - there is no description. Why do you need parent device at all?
This looks like some driver-driven-bindings instead of just real
hardware description.

Best regards,
Krzysztof
