Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69D2852E6AF
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346705AbiETH5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346713AbiETH5d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:57:33 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E4C14B676
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:57:30 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p22so12937826lfo.10
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LDOJGy883Whj2KPtZJS2ToqHv52wGZqpYAqQT+XUcgE=;
        b=isUGeH7YJ9hSFqU+LajDXfZhlKfVb7CX45XzIRyUTr6nxi+RtAGNgqGbnlsEQhvwYj
         DtZarkhGFwdzhP4U7a50sc89MgvxBhO8zNUt5YEZLuwaQ0rbV7tuhw9C3OHVafO+ZDPE
         ibZL6Q24dpZhKvcW2XmyFRDEbJHcahhp/Xga8jIN54sHD4+Vk7luFlD2au3HrMJQz8Z2
         7s5UjC357gY4A1NloCW8kQDC3228Q254aC/poWeNagQEYcyaCCOIcDzHwut3LSow/2Cc
         AEp2zS8qrGbxkv0vEqfQriAoUknEGaCL+Xvtqsje2IVe+y2wtuZ4TmLz4ETDf4swtJ5j
         o0xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LDOJGy883Whj2KPtZJS2ToqHv52wGZqpYAqQT+XUcgE=;
        b=Qp6HGDK23SUOKv46KtEw4yjXuXPKXdYy14AuR60PFQO21xYexQmVaMZ/kKewfIhwjY
         Jn9SKL7f7Aue7FHMRZnlwdEc7VXBvJfVRqKf5G1d1NnKgaQWF489OZEP8kR4nek251H2
         /mLdHaokUXv6BGH5cWFK2q7w8ga1edBZ/qLS6CFVkMWCOrV7uTAJDx5ppf4HgSc2GRSo
         UVbKC0AKVdhT/Jg218COG1t0pgxEy7IxBUsHvivx1h2UcK9pO/kgfm0NbMNySQQY7oJM
         goaeXSMDDzvSlfR5v8790g9AUvf20NWj5ipqyT3VEJs5tmY8hN6gIjaF4MYEi/hLcmil
         iFJw==
X-Gm-Message-State: AOAM533xMfVbvheYZDoKUYNYR9JYR5Kji5XysEN2RHt8d0I1Q9ONOoK8
        S7+128usRjuAl+yVutFuMv4Glg==
X-Google-Smtp-Source: ABdhPJxwdWspWTlCev1Y+CnP3ttUl/Y734MOSgWU+vOZrJzIFaH1ePOp5e8j6NN5qbVKN4ceOqCbGQ==
X-Received: by 2002:a05:6512:1319:b0:44a:c200:61e5 with SMTP id x25-20020a056512131900b0044ac20061e5mr6159427lfu.550.1653033448712;
        Fri, 20 May 2022 00:57:28 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id j5-20020ac25505000000b004778c285166sm559287lfk.216.2022.05.20.00.57.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 00:57:28 -0700 (PDT)
Message-ID: <0518eef1-75a6-fbfe-96d8-bb1fc4e5178a@linaro.org>
Date:   Fri, 20 May 2022 09:57:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 4/5] dt-bindings: net: Add documentation for optional
 regulators
Content-Language: en-US
To:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Corentin Labbe <clabbe@baylibre.com>, calvin.johnson@oss.nxp.com,
        davem@davemloft.net, edumazet@google.com, hkallweit1@gmail.com,
        jernej.skrabec@gmail.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, lgirdwood@gmail.com, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org, samuel@sholland.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
References: <20220518200939.689308-1-clabbe@baylibre.com>
 <20220518200939.689308-5-clabbe@baylibre.com>
 <95f3f0a4-17e6-ec5f-6f2f-23a5a4993a44@linaro.org>
 <YoYqmAB3P7fNOSVG@sirena.org.uk>
 <c74b0524-60c6-c3af-e35f-13521ba2b02e@linaro.org> <YoYw2lKbgCiDXP0A@lunn.ch>
 <YoZm9eabWy/FNKu1@sirena.org.uk>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YoZm9eabWy/FNKu1@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/05/2022 17:49, Mark Brown wrote:
> On Thu, May 19, 2022 at 01:58:18PM +0200, Andrew Lunn wrote:
>> On Thu, May 19, 2022 at 01:33:21PM +0200, Krzysztof Kozlowski wrote:
>>> On 19/05/2022 13:31, Mark Brown wrote:
>>>> On Thu, May 19, 2022 at 11:55:28AM +0200, Krzysztof Kozlowski wrote:
>>>>> On 18/05/2022 22:09, Corentin Labbe wrote:
> 
>>>>>> +  regulators:
>>>>>> +    description:
>>>>>> +       List of phandle to regulators needed for the PHY
> 
>>>>> I don't understand that... is your PHY defining the regulators or using
>>>>> supplies? If it needs a regulator (as a supply), you need to document
>>>>> supplies, using existing bindings.
> 
>>>> They're trying to have a generic driver which works with any random PHY
>>>> so the binding has no idea what supplies it might need.
> 
>>> OK, that makes sense, but then question is why not using existing
>>> naming, so "supplies" and "supply-names"?
> 
>> I'm not saying it is not possible, but in general, the names are not
>> interesting. All that is needed is that they are all on, or
>> potentially all off to save power on shutdown. We don't care how many
>> there are, or what order they are enabled.
> 
> I think Krzysztof is referring to the name of the property rather than
> the contents of the -names property there.

Yes, exactly. Existing pattern for single regulator supply is
"xxx-supply", so why this uses a bit different pattern instead of
something more consistent ("supplies" and "supply-names")?

Best regards,
Krzysztof
