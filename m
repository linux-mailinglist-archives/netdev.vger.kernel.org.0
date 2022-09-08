Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0E95B20F4
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbiIHOnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbiIHOnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:43:18 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E446582A
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:43:16 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id x14so12732713lfu.10
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 07:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=n8VGGC+7+I4IjFN0ib/PUjyurgUsEjooklHf6RmDYUg=;
        b=ZxdGhDBFjbOpQmDm+bvokfEUhGG1h4jISBv5G5/iyMzHUYo7MnhY5DCOp8n4Is7E0Z
         TQTTn9foxYpacFYzuB0/d1SJabnhH/mgJR82/CeiVTjvwgeQHI53w1FF2AL2D7UwIFGY
         W2LUkr6K/RkMpBo8gNMhXcp4LiQSyz1W11dvTKUjs3+Ux4uh2UZTfG2vk7bkaCnY+eRm
         jTT/Chbtx29UvPTz+OGPLt1w/xNbNEERAhEFW+5WAGTncArweLWKH/9D5pyl2efWhl3i
         pIAhsH2AWnyEwLTYmujSexcgV4wPY/rtEZpEDVNeYcsz1uwAGG2Cc5lC2ROg/Z9A00TD
         vFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=n8VGGC+7+I4IjFN0ib/PUjyurgUsEjooklHf6RmDYUg=;
        b=TlgvZWOlK0SGVABHFhVg5J4kfMiSsidzsDCCvYrQLa24w0ea1IVOwnJgCDO2aYJGt6
         wBScaHRO1ZqsRN7uck7INP8FObPxshE9hQoXmLzxLkLFcAyS8ZmxXrzy6PIYBI48QZqr
         ekRrymgaCwWelGM3lylYRU4dTZByg2/4RpOp8jTwfVd5aNHZUbPUiUTGSWpqE5J11fNf
         xsOOz0YT7pdIrQCltMc7cdH70HjTuVKMt2maGsJTfHANvBKx5bY1X1MDcLcLq+deyQ4k
         yV3Jp/B5mnfJEuwxw4aWTA9w9WYWYo6uCjcgML4ijqApl6eyy6bij/OTC+6wJ3e9cY1N
         DbHw==
X-Gm-Message-State: ACgBeo29OZZKpiUGlQoyZXWWPh5GaotkkjXtxuChF1q55nNHgU2NYF6H
        bKP+/2yAbxFMdEPyho6ySOTQ/w==
X-Google-Smtp-Source: AA6agR4vo2geJ+bD2HdOnszq/5/BOl1SbzOVNQ+QLutzfKR1QkYQv+a7YFX6i+H7RE1zgYN8hG1jsA==
X-Received: by 2002:a05:6512:152a:b0:496:80f3:7fe0 with SMTP id bq42-20020a056512152a00b0049680f37fe0mr2823929lfb.579.1662648195222;
        Thu, 08 Sep 2022 07:43:15 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id a6-20020a05651c010600b002688cceee44sm3221569ljb.132.2022.09.08.07.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 07:43:14 -0700 (PDT)
Message-ID: <71d970bc-fe6f-91e7-80c1-711af1af5530@linaro.org>
Date:   Thu, 8 Sep 2022 16:43:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 4/4] dt-bindings: net: snps,dwmac: Update interrupt-names
Content-Language: en-US
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>,
        devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
 <20220907204924.2040384-5-bhupesh.sharma@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220907204924.2040384-5-bhupesh.sharma@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/09/2022 22:49, Bhupesh Sharma wrote:
> As commit fc191af1bb0d ("net: stmmac: platform: Fix misleading
> interrupt error msg") noted, not every stmmac based platform
> makes use of the 'eth_wake_irq' or 'eth_lpi' interrupts.
> 
> So, update the 'interrupt-names' inside 'snps,dwmac' YAML
> bindings to reflect the same.
> 
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index f89ca308d55f..4d7fe4ee3d87 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -105,10 +105,12 @@ properties:
>  
>    interrupt-names:
>      minItems: 1
> -    items:
> -      - const: macirq
> -      - const: eth_wake_irq
> -      - const: eth_lpi
> +    maxItems: 3
> +    contains:
> +      enum:
> +        - macirq
> +        - eth_wake_irq
> +        - eth_lpi
>  

This gives quite a flexibility, e.g. missing macirq. Instead should be
probably a list with enums:
items:
  - const: macirq
  - enum: [eth_wake_irq, eth_lpi]
  - enum: [eth_wake_irq, eth_lpi]


Best regards,
Krzysztof
