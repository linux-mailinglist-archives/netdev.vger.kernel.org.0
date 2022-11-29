Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6A9263BC22
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiK2Ivt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiK2Ivp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:51:45 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE4424BCD
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:51:44 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id s8so21420815lfc.8
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qOArE8my8J/ipU9oMYClbJVsW3lHXFxVNxDO1jO7EJM=;
        b=zQScKMkcDPLb0VbjVjZbxuia8pV+1yNLJkwoOz5+7uEaU+6msIwDGKIXO6YPKZol+E
         M9XqTRkg0g9A2cXSGGy/jIz9rC5o8vGonCgrSvqpL4B9T6jWMrMRpMU6DqROQ9aQvN9j
         dJBuHZfMLbDTc8RSnsufVA52LDzaq9PVCwo8++dceJAbqtj9++MgCIlGUq1df3KRyfvg
         DkPklmj3A5QvgkGxK2hd9xinWidw30yeQHfNindqR+gPkyi/8W37sTa9TemdN2BtSDZu
         LhY72igp/L0YRGzG9vo23ai9ah5MOsiGcntbrPMT3QCw4pnG1uwlqyeGTYbfwJ8lV2DM
         8Ktg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qOArE8my8J/ipU9oMYClbJVsW3lHXFxVNxDO1jO7EJM=;
        b=YcjoSivxq2uVTR09ZpxXnzaYgFxU53qV1K3c7ufGL7bTWPjGdIM58Dwyo5745txQ3L
         cPJJ809G8zsYHguVz8vuJIHpyadXFxd12SPehz7j+YRsbqwJQWziSGi16nTK0cxRjU1P
         +frbudYcWr2uesraS0wNP0DjdVXe4XAERJu1yh6iDnrJugYGmtxE7y9b0AsUMiFvi4Qm
         RNzVn+zdyoD0KmF26agkmLxJwiSypznp8I8whWBOmj7vDhjDFBejmwir7MLzcHH5UGxY
         PrMILC7OAaz04ByDBtapM2NU48mZ+MXvwxyb3wfrIY5isncsYLnOrV5zbHkYPoOt1sOw
         9ukQ==
X-Gm-Message-State: ANoB5pnEJHDZs2H+yXt9UH2nQfqreZT3K+4v97cKrnmWE1fb911Z6QGi
        U4CjWhV2flO/kMVhCtanqNsdzA==
X-Google-Smtp-Source: AA0mqf6nzwvf2RmaoCBMIPu+kzJXafNijvrUgD0Yz45ncIT5YtlHx/jG9cgKZI04TjMh48z5zZWvnw==
X-Received: by 2002:a05:6512:3049:b0:4a2:3f4b:839 with SMTP id b9-20020a056512304900b004a23f4b0839mr16695594lfb.483.1669711895956;
        Tue, 29 Nov 2022 00:51:35 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id l18-20020a194952000000b004aa427febe5sm2111342lfj.64.2022.11.29.00.51.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Nov 2022 00:51:35 -0800 (PST)
Message-ID: <979d220c-525c-ad57-89b8-b65bda55fe55@linaro.org>
Date:   Tue, 29 Nov 2022 09:51:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] dt-bindings: net: rockchip-dwmac: add rk3568 xpcs
 compatible
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Chukun Pan <amadeus@jmu.edu.cn>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Wu <david.wu@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20221129072714.22880-1-amadeus@jmu.edu.cn>
 <6f601615-deab-a1df-b951-dca8467039f8@linaro.org>
In-Reply-To: <6f601615-deab-a1df-b951-dca8467039f8@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/11/2022 09:49, Krzysztof Kozlowski wrote:
> On 29/11/2022 08:27, Chukun Pan wrote:
>> The gmac of RK3568 supports RGMII/SGMII/QSGMII interface.
>> This patch adds a compatible string for the required clock.
>>
>> Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
>> ---
>>  Documentation/devicetree/bindings/net/rockchip-dwmac.yaml | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
>> index 42fb72b6909d..36b1e82212e7 100644
>> --- a/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/rockchip-dwmac.yaml
>> @@ -68,6 +68,7 @@ properties:
>>          - mac_clk_rx
>>          - aclk_mac
>>          - pclk_mac
>> +        - pclk_xpcs
>>          - clk_mac_ref
>>          - clk_mac_refout
>>          - clk_mac_speed
>> @@ -90,6 +91,11 @@ properties:
>>        The phandle of the syscon node for the peripheral general register file.
>>      $ref: /schemas/types.yaml#/definitions/phandle
>>  
>> +  rockchip,xpcs:
>> +    description:
>> +      The phandle of the syscon node for the peripheral general register file.
> 
> You used the same description as above, so no, you cannot have two
> properties which are the same. syscons for GRF are called
> "rockchip,grf", aren't they?

Also:
1. Your commit msg does not explain it at all.
2. Your driver code uses this as some phy? Don't use syscon as
workaround for missing drivers.

Best regards,
Krzysztof

