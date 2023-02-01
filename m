Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C74D68606E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 08:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbjBAHS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 02:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjBAHS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 02:18:27 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2759A40BDB
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 23:18:26 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m14so15878345wrg.13
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 23:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iW6TmbMd1gF07kY30EHKKSaAsBit2kIYwls/u2QTCf4=;
        b=j3nk+KTjiQcXiaKpw0pS/P9AFoUUfBNZujRQVvK4n2gaSInX/Kq+gO7bSyRymDA5d7
         +SKy82W4wCrsXxv0/94ntcvpp8v/UbhAmbuiSa6K2BbxbnFZyExtFWockWLDsl36sVhL
         o8iwJfLzqcsu0RRadIS0OWOX/PQshd2FQsvEFf9QYB4UVoVoTwpp1yEgn6fziJ04uo3W
         NuU2PDl78L4TvMoZqeNAuqnn4Im+/+mboSpTMLrR7/xaW5Nf6hHVR7pjn2bQkiEt6PXG
         EdevtW0J6TkqZkpR2yqVfk5HmumVBokZ4IX9N59OvmPIos27lBUaiBx8OWshshksNOtl
         XrWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iW6TmbMd1gF07kY30EHKKSaAsBit2kIYwls/u2QTCf4=;
        b=NIqaLWDLS6mrKUizGiW/Yr3P84KQOGD4iXVAO1V/hmyLrbAtg2ec9PxrWB7DUXpLuS
         nzbVEd6zuwW+VkKK4670AxfURHuGOtZhRUNEE2xaebO5p1KeEWc7r7yqOHDljsbENDBw
         LMJ7pUJbJNVe1XrO8FjLYAVZXKtWaeTpRL9c9ObOead7u7Mu0efWhXG28V8OJYZF+xqP
         bTN/qfXCoXsEqEuO5BQbVXhndZGoFS5fzKwTIzsJsSTVT3zqB4hs528xzraDtZnP4DjE
         1ImUaZnrG0MOP54eSgSWgIW6B2Pg3cvC4ViKWHPYmeuhnlznQK97j4lFfVNuo0zyrwOt
         vydQ==
X-Gm-Message-State: AO0yUKWZJHzv/hZ2phVnW2aMcCLeHsogufW+lFyOrys5ySWwvMsHttJD
        ZjMp2/7vOVe8TaSQwS3wWG6Erw==
X-Google-Smtp-Source: AK7set8aXkWyw3ME7Gycfqg3GIvG2Nld+V7yA715pFMljnnf5z5iftP/liNYXRk1ZeDczwawfygFYQ==
X-Received: by 2002:adf:d0cc:0:b0:2bf:e01c:b9d0 with SMTP id z12-20020adfd0cc000000b002bfe01cb9d0mr1429041wrh.13.1675235904619;
        Tue, 31 Jan 2023 23:18:24 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id h12-20020a056000000c00b002bdd96d88b4sm16917401wrx.75.2023.01.31.23.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 23:18:24 -0800 (PST)
Message-ID: <634ad948-c95d-541f-ccb6-c1f185faad9c@linaro.org>
Date:   Wed, 1 Feb 2023 08:18:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Content-Language: en-US
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
References: <c515aae3-88e4-948c-a856-7b45dd2caed9@linaro.org>
 <20230201031349.56405-1-steev@kali.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230201031349.56405-1-steev@kali.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/02/2023 04:13, Steev Klimaszewski wrote:
>> On 31/01/2023 05:38, Steev Klimaszewski wrote:
>>> Signed-off-by: Steev Klimaszewski <steev@kali.org>
>>> ---
>>>  .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 68 +++++++++++++++++++
>>>  1 file changed, 68 insertions(+)
>>>
>>> diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
>>> index f936b020a71d..951438ac5946 100644
>>> --- a/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
>>> +++ b/arch/arm64/boot/dts/qcom/sc8280xp-lenovo-thinkpad-x13s.dts
>>> @@ -24,6 +24,8 @@ / {
>>>  	aliases {
>>>  		i2c4 = &i2c4;
>>>  		i2c21 = &i2c21;
>>> +		serial0 = &uart17;
>>> +		serial1 = &uart2;
>>>  	};
>>>  
>>>  	wcd938x: audio-codec {
>>> @@ -712,6 +714,32 @@ &qup0 {
>>>  	status = "okay";
>>>  };
>>>  
>>> +&uart2 {
>>> +	status = "okay";
>>> +
>>> +	pinctrl-names = "default";
>>> +	pinctrl-0 = <&uart2_state>;
>>> +
>>> +	bluetooth {
>>> +		compatible = "qcom,wcn6855-bt";
>>> +
>>> +/*
> 
>> Why dead code should be in the kernel?
> 
> As mentioned in the cover letter, this is a bit closer to an RFC than ready to
> go in, and I do apologize that it wasn't clear enough.  I do not have access to
> the schematics, and based on my reading of the schema for bluetooth, these
> entries are supposed to be required, however, like the wcn6750, I have dummy
> data entered into the qca_soc_data_wcn6855 struct.  I know that these should be
> there, I just do not have access to the correct information to put, if that
> makes sense?

Keeping them commented out, does not solve the "these should be there".
Drop or add them.


Best regards,
Krzysztof

