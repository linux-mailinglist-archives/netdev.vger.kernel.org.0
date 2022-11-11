Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83927625530
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 09:26:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232969AbiKKI0q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 03:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbiKKI0p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 03:26:45 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25047F58
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:26:44 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id l12so7303076lfp.6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8rpVKE67IBmA7XtteX2UDcMQHdjbr00NDENJT6r74jo=;
        b=rVyoTLGZn9mJFxahXkOBGebTf4V/UVm9x7ea3vJ4MlkqaEingvwMH6LThe0n89yA3M
         Dqz93cqHAgMDuBIAW+jJWNe2kD56W6P6cOY9LllNqulQqWE04C+DXVShqhFRi3+1hboK
         X0xHG2tL2ltm3aYAovIrOo9yf/DRLsEXMk3ZG4m6RUI4PBdaRBjBYOA1rBHhXTvotKai
         GlIkEycBZ2y9txHNCwxN1EyHkgnHFZuLXP7BFguCX0GJTcTYs+GwvpfX2Hfd8u+pbglU
         ClrZwpaw6lZT3QrNwnTWc43FxosLOPkkRILh4O6G34Qd8hJDNBE+hCKdUvbmGNt9Q7BX
         kffA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8rpVKE67IBmA7XtteX2UDcMQHdjbr00NDENJT6r74jo=;
        b=rhEhqq4F/u7/6ym+qiQbMqs+3tuoqLKON0KfU+zr7FdaIqQ0GvcCAxXd+halvTf9su
         XKkspBC5n/zKkaB+By0pZ9ieth21eCwpqDR0SJKrI39mu0zWSkAmxigSpHg5xzSV/Lv4
         hu+Hwe3QQEtnIRn6nooDqf82RDUIIurFN/rqvLpIp4tGEd31UW2vP5FfCDQbb6mhznV2
         daZaR/s/DXiwgeYsslegEKtZRy+U8NCRIy4nqaatH0E34SlzSZ2dvA8IzsAeVdDhS70h
         9thIlgH2zTq/PwVhmJ9FiLbNmzZW1kEELGYdkL21EoxRz06kPSlUfJdgy3evmqKVrQUq
         VfNA==
X-Gm-Message-State: ANoB5pnfP7JcJBJ86qsFdHszAo6eOiyA3xLF6mX7R2O5dGQ4f57lkN7g
        UZvZs1mN4exZF9YNnDT0Y9sW3A==
X-Google-Smtp-Source: AA0mqf40KWGiBUxr2c5SK3GVpLInNlmJgA1Y+Gb3thXl4jUVA9nIYqvQ5QbV1/zxPa/lpRQLIvHctw==
X-Received: by 2002:a19:491d:0:b0:4b1:7f47:2ecd with SMTP id w29-20020a19491d000000b004b17f472ecdmr378034lfa.333.1668155202512;
        Fri, 11 Nov 2022 00:26:42 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id b9-20020a0565120b8900b004a4251c7f75sm211248lfv.202.2022.11.11.00.26.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 00:26:41 -0800 (PST)
Message-ID: <900e6177-0a21-e2f5-6c03-81d1dd182c68@linaro.org>
Date:   Fri, 11 Nov 2022 09:26:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: qcom,ipa: remove an
 unnecessary restriction
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221110195619.1276302-1-elder@linaro.org>
 <20221110195619.1276302-2-elder@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221110195619.1276302-2-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 20:56, Alex Elder wrote:
> Commit d8604b209e9b3 ("dt-bindings: net: qcom,ipa: add firmware-name
> property") added a requirement for a "firmware-name" property that
> is more restrictive than necessary.
> 
> If the AP loads GSI firmware, the name of the firmware file to use
> may optionally be provided via a "firmware-name" property.  If the
> *modem* loads GSI firmware, "firmware-name" doesn't need to be
> supplied--but it's harmless to do so (it will simply be ignored).
> 
> Remove the unnecessary restriction, and allow "firware-name" to be
> supplied even if it's not needed.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 10 ----------


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

