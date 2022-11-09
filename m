Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 947FE6229CA
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiKILLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKILLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:11:05 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CADE2873C
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:11:03 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id k19so25237926lji.2
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:11:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RBYC2sQin+8K6ysS38BCoDSJAXb+ifX+8YqSQIM6ZNE=;
        b=PT7IdvLowfx3KdqSMDXmaDTaWI+owL9r4MbPbtgI8uN1LsJa/SsSKSbfdvPpsFUz+b
         qrbzfspBUTgop+tdztUoMusYGwyj55hlUTJ5Qicgmz90ixY8sRUQsCtg3EAicRj62vXL
         GguVtP+Cfc1lmZ/pKjjifXO3oLmYZcauuvtHXOt+SHTkQxNl9mkzI2iemqICbMGk2NjS
         ZQPAJT4JF9F9vUfhc+GtIkG3vVbJAUFnffwzMeOwSBqRh6rgbcLpNKBF28m4zwd7sgLP
         I6CG1teRO/3/moE3b3GKMxNDH0HGAkTEwpcPcS4iCpmRRIGzEoww9wZZnTmjcCc3Hl+R
         t6ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RBYC2sQin+8K6ysS38BCoDSJAXb+ifX+8YqSQIM6ZNE=;
        b=WYGrZ5zeQzB/Pem5VrgG0scupwAT2/PpIqI+ZCFqEccjDJl8fWXQukUCS0JL0MlWoN
         IjZXwTJtHp3boZHXi2n+BAPXxzVm2yjriMohqWitAZ+qC1BOnDLX3lnPQzck/vSJMjJk
         Siuad8scRk2mzijJW8IjwVrJItX+t6RQVypg+WKnzPzs72if3g9YzjginDtrVfYVLjcJ
         lsY6+OfRjZzYBtLyuercW2M3qsCTncFlgZ0+/oYAYkTuiBy/RscEZeanQqSy3GOjh3TB
         Y13dbMO4eCoU2jyuFosaiJF2vhqV8TzMJS66x8+UKNUt/in7Als7sUj/dm6D/H5FthrE
         38vg==
X-Gm-Message-State: ACrzQf2uMTYEfrMhcSUiUjO0n5VFx3gjg44Cs9svgCB9ANrgdsBlPC7O
        29+c2KpBxBL77EwcK02lcG6u9w==
X-Google-Smtp-Source: AMsMyM7UtzPEqp3da7BV+7So92Og/3kSdtsDjfAfnH8rib/01LUvRanVw1xriRs6aLAVUpLm3c/8KA==
X-Received: by 2002:a05:651c:88b:b0:26e:261:5052 with SMTP id d11-20020a05651c088b00b0026e02615052mr19368472ljq.182.1667992261625;
        Wed, 09 Nov 2022 03:11:01 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id r26-20020ac25c1a000000b00497a879e552sm2154796lfp.291.2022.11.09.03.11.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 03:11:01 -0800 (PST)
Message-ID: <fe9b3e7f-c852-5f5e-1d3b-d30218ee497a@linaro.org>
Date:   Wed, 9 Nov 2022 12:11:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 2/6] dt-bindings: can: mcan: Add ECC functionality to
 message ram
Content-Language: en-US
To:     Vivek Yadav <vivek.2311@samsung.com>, rcsekar@samsung.com,
        krzysztof.kozlowski+dt@linaro.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
References: <20221109100928.109478-1-vivek.2311@samsung.com>
 <CGME20221109100249epcas5p142a0a9f7e822c466f7ca778cd341e6d9@epcas5p1.samsung.com>
 <20221109100928.109478-3-vivek.2311@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221109100928.109478-3-vivek.2311@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 11:09, Vivek Yadav wrote:
> Whenever the data is transferred or stored on message ram, there are
> inherent risks of it being lost or corruption known as single-bit errors.
> 
> ECC constantly scans data as it is processed to the message ram, using a
> method known as parity checking and raise the error signals for corruption.
> 
> Add error correction code config property to enable/disable the
> error correction code (ECC) functionality for Message RAM used to create
> valid ECC checksums.
> 
> Signed-off-by: Chandrasekar R <rcsekar@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> ---
>  .../bindings/net/can/bosch,m_can.yaml         | 31 +++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> index 26aa0830eea1..91dc458ec33f 100644
> --- a/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> +++ b/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml
> @@ -50,6 +50,12 @@ properties:
>        - const: hclk
>        - const: cclk
>  
> +  tesla,mram-ecc-cfg:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    description:
> +      Handle to system control region that contains the ECC INIT register
> +      and register offset to the ECC INIT register.

That's not way to describe syscon phandle. Property name is ok. For the
rest look at:
https://elixir.bootlin.com/linux/v5.18-rc1/source/Documentation/devicetree/bindings/soc/samsung/exynos-usi.yaml#L42

Anyway, this looks like SoC-specific hack, so it does not really fit to
the driver. You have to think of something generic.


Best regards,
Krzysztof

