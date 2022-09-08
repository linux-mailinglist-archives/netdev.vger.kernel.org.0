Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D555B20DB
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 16:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiIHOks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbiIHOk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 10:40:28 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009A266138
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 07:39:56 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id y18so5410208ljh.12
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 07:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=JpcpFpvEB8psImxmDG9KUsbNAcN0FY24XTZzbqr2fhA=;
        b=SCmxItyGtef6kl4mGnpwBHwGe9KQKyhfaoDBzriXQIS/YAPjZGGdUwWxfGDK/+tb3D
         orouZPkzszIruohQW+FWn5oPqGnwXg4370Hm8JxYCCVvkXKycUbk1MrijOr2S1XQQFVy
         jSsyymNhTxymERuJSZ+6WQyzonFp4mQgWTY1+oXJAe5zeRTo6fX1wmzZHXwpWpAKhQ1W
         akFnhty780mMqQI+f8G8WgZaJRo0hwci6y1O1AHjtXOVPGWh+kq5mmTmdCfbmm4ihp2c
         HUpo+n6Wuik/rM7AJq5ootNBr+h3GHx/TS50/f1hbaDnMfEqjHMWtvjfkN+CAjimURXY
         X2cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=JpcpFpvEB8psImxmDG9KUsbNAcN0FY24XTZzbqr2fhA=;
        b=TPwsYRF3x1vtCmOXbrf13N1JYC8sQWOtszrb1YNZuioc1yu0rMwZtG18BkyvM0KbOC
         z7tkJyB6aQalhz+ak7rUDoBY81FQEp+ge+TavbDFI8LFmkSDTTqEr+d/UGhuukqiv2Sb
         2KZMm8XKkBZF5xityg8TNRHj7IQ0P+6kIEwgKeaWFIu8LwsnwnVjcUX8MFfxu0VBTU2s
         TJ/uwa6aEVN32b4LhFDJOWroMdTR1f/VRsbpCWXxwgUjKlrVEcwkFw2Mp1HqTs+Ti+3b
         K0P8TsSx8uICVVrlG5G6F1CKOSkjQvR2ziNlUyJ4FodTjhrBO1YnQj84fvvIrpWE9+YH
         LDZg==
X-Gm-Message-State: ACgBeo01RI5nyVTojDwzB2dQN5/AvbKH8Ktouo6e6WwcvjLMW8j7wsMc
        1NmWVsZ3XHkw6VNNxR4muM7o2w==
X-Google-Smtp-Source: AA6agR6fkcqxGRSQf8QGpIsGuz/BaE56SevT7m1ZoTBkSIBzv61JfzIYDfG9VYWYedjvtmNU9YY2Vw==
X-Received: by 2002:a2e:bf07:0:b0:261:cafb:d4a8 with SMTP id c7-20020a2ebf07000000b00261cafbd4a8mr2479468ljr.268.1662647994755;
        Thu, 08 Sep 2022 07:39:54 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id f23-20020a2eb5b7000000b0026bda31c10fsm250488ljn.61.2022.09.08.07.39.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 07:39:54 -0700 (PDT)
Message-ID: <d191cdd3-64be-4fc4-56d6-c0e6c5c80b19@linaro.org>
Date:   Thu, 8 Sep 2022 16:39:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 2/4] dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet
 ETHQOS compatibles
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
 <20220907204924.2040384-3-bhupesh.sharma@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220907204924.2040384-3-bhupesh.sharma@linaro.org>
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
> Add Qualcomm Ethernet ETHQOS compatible checks
> in snps,dwmac YAML binding document.
> 
> Cc: Bjorn Andersson <andersson@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: David Miller <davem@davemloft.net>
> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 2d4e7c7c230a..2b6023ce3ac1 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -65,6 +65,8 @@ properties:
>          - ingenic,x2000-mac
>          - loongson,ls2k-dwmac
>          - loongson,ls7a-dwmac
> +        - qcom,qcs404-ethqos
> +        - qcom,sm8150-ethqos

This must be squashed with previous one, otherwise patchset is not
bisectable.

Best regards,
Krzysztof
