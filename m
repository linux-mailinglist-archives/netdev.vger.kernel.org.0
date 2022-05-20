Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0063252E9C5
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348095AbiETKTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 06:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241099AbiETKTQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 06:19:16 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A489410657E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 03:19:15 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id a23so9118238ljd.9
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 03:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=qC4Olf3TBGA3MotPYbQLIM34p+fB/nDlozQzZDrBQBk=;
        b=TRs4rMcCAVRW9/+gyu2GMjvXZyCPcqFpOTYZ7FzW5y6x5LKb+wP8FpcAt0/ZMVUCih
         ZDif5/ECPUi9qdeS5wmkjHR/hxJFlOmRzDvyttaeChD2/TElvKqvRxVUNACRbBWvFunr
         OxKMY2BJapKXlCAozP+UhfirIr8tSfSSttaBF5fyhZRyyktW0bhAiepbW0x8SIH7ZDuU
         tJp8EyFs8cupA5bFJdcRDF88ZqyT44XkPaqapkL7hkQ+SghTNeb4OxK7K4gWohd47fuA
         4uELozEYuW7ssvi338yBHgQIiM/JY/2btQfzXBM1tLWOH8C0UjWxlZDV4eXFQH84smeH
         d31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qC4Olf3TBGA3MotPYbQLIM34p+fB/nDlozQzZDrBQBk=;
        b=QUxuQ5AqTsN0+ZMFv2s2AQ6Iv+YCuYEQLF7lpyqlze570RmOY87cvdJBnrdnv6t1Qm
         Pr2rvEzu4GOi+R7Ovlcg5pZEEKr2qjHwmHUIo1gSqPEjUIfeaekKRVC3mhQf/0O9EVBK
         mE0BusdRuUh9jk/NtLj/V1j993pvBbqCDt1PovW8Iv85F9bUnLfjvWQKizraPzvMfASN
         BTj2s44OjMGBOvfZkwKMjJXaAZ5IiWYIN6biKSlXyEHZhgPTz0zIfFTGUd77+U5ie4UG
         k9kYiMmLqkkomcJ0yKIUZ96J8ZMIJwQQtiYGsrOOCTZj0nBnRrKxUNYg0Iv6A29pduLH
         Q0wQ==
X-Gm-Message-State: AOAM530Z8GkO66AzUaPDkqeoAXhL8DQhRFEcnfiRqNPyyfrmmge6CZg/
        P6Apa2Gj+akR5TZNMfUaEvCllw==
X-Google-Smtp-Source: ABdhPJz5R0gOM+LR5VrdWtX2EWAzFoI4W3cbw6McoMSSQnAw/WK6yf40qF0stxViEQS8Atvn2d+6/A==
X-Received: by 2002:a2e:884b:0:b0:253:d431:45f0 with SMTP id z11-20020a2e884b000000b00253d43145f0mr4587867ljj.70.1653041954080;
        Fri, 20 May 2022 03:19:14 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id b4-20020a056512024400b00477a6c86f17sm610621lfo.8.2022.05.20.03.19.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 03:19:13 -0700 (PDT)
Message-ID: <56a6dc27-35ef-68a9-e990-7d989450ba89@linaro.org>
Date:   Fri, 20 May 2022 12:19:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v2 4/5] dt-bindings: net: Add documentation for optional
 regulators
Content-Language: en-US
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Mark Brown <broonie@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        calvin.johnson@oss.nxp.com, davem@davemloft.net,
        edumazet@google.com, hkallweit1@gmail.com,
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
 <0518eef1-75a6-fbfe-96d8-bb1fc4e5178a@linaro.org> <YodOO6PfsjelCa1x@Red>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <YodOO6PfsjelCa1x@Red>
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

On 20/05/2022 10:15, LABBE Corentin wrote:
> 
> I agree that supplies and supply-names are better.
> But in another answer Rob is against it, so if I understand well, we are stuck to use individual xxx-supply.
> I will try to create a new regulator_get_bulk_all() which scan all properties matching xxx-supply

Yep.


Best regards,
Krzysztof
