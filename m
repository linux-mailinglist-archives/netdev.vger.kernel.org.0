Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 558D06279A9
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236423AbiKNJ4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236343AbiKNJ4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:56:36 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21026A464
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:56:33 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id a29so18366970lfj.9
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x8chpSCweIkEehH0LuFm3Awls5omUQV3c5J0T5cGVX4=;
        b=UltxDKNSsC0dIzDpREoAgUzlNRMOlyNuqR3zpdv4x5kpuUaPOvDtlDnFE4NLYuk/pP
         dVUh2YI92B4aTmkno4CQ9J0Ss/v25P37mzNiVXjde0H1j1B69L+r/talmLYQMvJLHJy1
         ROi952zRZfYgIm/d2ZLWQfoHYIpc+J6ec/LUUOry8uCie7fPdCr0kmXLSKCI3wrCnbOs
         AIEqiG5CqcLSsxPKHON5R4kFFj3IWSHhK838KhbwVodnVPHqSEg7JSeu+dhI4m/LpoN6
         D5prLyHG1qpL1g9rXJNYmVO5X9I0KKB+BrjWFFpKEx+JLASQhaMWZ3Nn3mkF2U0Y+q+t
         LevQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x8chpSCweIkEehH0LuFm3Awls5omUQV3c5J0T5cGVX4=;
        b=o2vL/buhQI+o8UaJQYoAbPZCKYhb83KAr08LBbFvZGqAxSM8g8cpwmkIxl7pUt1hmC
         EJN+shhPZlwqjeCitLEe6GDdA3DSg5NKHCXrNGtrlel970f5CWxhIbsifkiOZkYhcSmr
         KF0J3CUhQTQvVJcYad92Pt+9cSkJZEehNc8qoyINron38d6tP3uTIeDKfVBBWlt8NNLO
         /RBNkydpb2CbrfB+cqtknpEW1J3wWvQIlQqcyrtQ/82i1vzDgrEjscixq6ntZi8Uq3pn
         8nQBNPlC9Krp/R7jhuCTqiuzNf9aNU7MkHwX7KI8dD02UMCltW8gfV58ONkTjUl3NeSr
         i6xQ==
X-Gm-Message-State: ANoB5pk7DyRbrnb4aZ5Q8ZiJxZJhAifpOPXDx3DHhkGWVXYKVD0cpvKe
        H9YiIh8gnZDHO0MDmWiejng5AQ==
X-Google-Smtp-Source: AA0mqf7ESogb7qBezaKzO4iAGNxpKmSohIBTvAUHOsPYskR7JS8uYXVXe1x9s2F2wXDSeJhV1qd7gw==
X-Received: by 2002:a05:6512:1115:b0:4a2:6238:e7f9 with SMTP id l21-20020a056512111500b004a26238e7f9mr3821288lfg.294.1668419792271;
        Mon, 14 Nov 2022 01:56:32 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id k19-20020a2eb753000000b00277078d4504sm1956378ljo.13.2022.11.14.01.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 01:56:31 -0800 (PST)
Message-ID: <de98dbb4-afb5-de05-1e75-2959aa720333@linaro.org>
Date:   Mon, 14 Nov 2022 10:56:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 1/5] dt-bindings: net: qcom,ipa: deprecate
 modem-init
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221112200717.1533622-1-elder@linaro.org>
 <20221112200717.1533622-2-elder@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221112200717.1533622-2-elder@linaro.org>
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

On 12/11/2022 21:07, Alex Elder wrote:
> GSI firmware for IPA must be loaded during initialization, either by
> the AP or by the modem.  The loader is currently specified based on
> whether the Boolean modem-init property is present.
> 
> Instead, use a new property with an enumerated value to indicate
> explicitly how GSI firmware gets loaded.  With this in place, a
> third approach can be added in an upcoming patch.
> 
> The new qcom,gsi-loader property has two defined values:
>   - self:   The AP loads GSI firmware
>   - modem:  The modem loads GSI firmware
> The modem-init property must still be supported, but is now marked
> deprecated.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  .../devicetree/bindings/net/qcom,ipa.yaml     | 59 +++++++++++++++----
>  1 file changed, 46 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index e752b76192df0..0dfd6c721e045 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -124,12 +124,22 @@ properties:
>        - const: ipa-clock-enabled-valid
>        - const: ipa-clock-enabled
>  
> +  qcom,gsi-loader:
> +    enum:
> +      - self
> +      - modem
> +    description:
> +      This indicates how GSI firmware should be loaded.  If the AP loads

s/This indicates/Indicate/
(or any other grammar without describing DT syntax but hardware/system)

> +      and validates GSI firmware, this property has value "self".  If the
> +      modem does this, this property has value "modem".
> +
>    modem-init:
> +    deprecated: true
>      type: boolean
>      description:
> -      If present, it indicates that the modem is responsible for
> -      performing early IPA initialization, including loading and
> -      validating firwmare used by the GSI.
> +      This is the older (deprecated) way of indicating how GSI firmware
> +      should be loaded.  If present, the modem loads GSI firmware; if
> +      absent, the AP loads GSI firmware.
>  
>    memory-region:
>      maxItems: 1
> @@ -155,15 +165,36 @@ required:
>    - interconnects
>    - qcom,smem-states
>  
> -# If modem-init is not present, the AP loads GSI firmware, and
> -# memory-region must be specified
> -if:
> -  not:
> -    required:
> -      - modem-init
> -then:
> -  required:
> -    - memory-region
> +allOf:
> +  # If qcom,gsi-loader is present, modem-init must not be present
> +  - if:
> +      required:
> +        - qcom,gsi-loader
> +    then:
> +      properties:
> +        modem-init: false

This is ok, but will not allow you to keep deprecated property in DTS
for the transition period. We talked about this that you need to keep
both or wait few cycles before applying DTS cleanups.

> +
> +      # If qcom,gsi-loader is "self", the AP loads GSI firmware, and
> +      # memory-region must be specified
> +      if:
> +        properties:
> +          qcom,gsi-loader:
> +            contains:
> +              const: self
> +      then:
> +        required:
> +          - memory-region
> +    else:
> +      # If qcom,gsi-loader is not present, we use deprecated behavior.
> +      # If modem-init is not present, the AP loads GSI firmware, and
> +      # memory-region must be specified.
> +      if:
> +        not:
> +          required:
> +            - modem-init
> +      then:
> +        required:
> +          - memory-region
>  
>  additionalProperties: false
>  
> @@ -196,7 +227,9 @@ examples:
>          ipa@1e40000 {
>                  compatible = "qcom,sdm845-ipa";
>  
> -                modem-init;
> +                qcom,gsi-loader = "self";
> +                memory-region = <&ipa_fw_mem>;
> +                firmware-name = "qcom/sc7180-trogdor/modem-nolte/mba.mbn";

Isn't this example based on sdm845?

>  
>                  iommus = <&apps_smmu 0x720 0x3>;
>                  reg = <0x1e40000 0x7000>,

Best regards,
Krzysztof

