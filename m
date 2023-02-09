Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69DA16903B0
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 10:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjBIJaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 04:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBIJaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 04:30:00 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086A75EFA5
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 01:29:59 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id m14so1074936wrg.13
        for <netdev@vger.kernel.org>; Thu, 09 Feb 2023 01:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gCVLv0yCFVHZfvArLek6WTlYqONgG0fn0UVa0wLiFeo=;
        b=GtP1PpX5UFqxDd7fPSgM5FnQpTMBGKkFEbKq5qbBynITNJS4wr+JnNZWzmrK8m0s4w
         /DWtyViy1Erx2yglIEirlH6UWPX5Moyrlx/IomcAZ0yJqghT3OzBMzOzBYOlBxSf+pvp
         EBzCCR5s+uSzYRU73CVf9romeOkS1PZN4viE/W0fhpXw0vyfXhwbFrFY1x3zYcGxrJfp
         jieJwlK2SkWAShdzpDuOOFh3g/J/s8bqIxtc+FWTZc9QibfZPepvhZT+djq96EtQzXXJ
         cbMd9ZiesSzGMpAmR10rX4YxWK4PnmUCp5EWoIQxd8cocesTFFIDT1KMy02+tSd9TG3Y
         jWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gCVLv0yCFVHZfvArLek6WTlYqONgG0fn0UVa0wLiFeo=;
        b=0hgp1xwDCplXFJAgVwSW+k49TTgGg4Wdv6JLTcwiOfyrNGu9fJ/C3kUcvOAssDrcgq
         YusdI2h1FU4ZZfcU/l7lyf5CYmXkPsLzi34M2kclvyf8rbJS57xLRGaTr5fYhqG0u+0c
         Jd9bYE+AoTLMHh6BVCmiZNpigdWX5uxW2XnWfXseh6BRtvn+jW0WNqta133/zHaZxtPo
         zg0TFuy/LZc8Mnr8Jxzg8DSdcOLT43p+uVDWzQtZSH1fZGnGhrYL+AjvFxVVWsD53H8W
         ZMoqgMR32IxMj12QOZZ9w7EiMZAnzK5GYFosSvt9zBcJUgOaShHWgOkxDJFFGfj0VGhN
         Dk6Q==
X-Gm-Message-State: AO0yUKVFRIWJ6SEitwGM2Uitj/7dgmAlWa+C54miRlAHNQHS32I4OWCF
        FFyz/Kjam76pnKbwlZptSvhSGw==
X-Google-Smtp-Source: AK7set9AVtfTdH8bY245wbUqhbQU9zpYNOboLM+wXyB1lN7SZsadOztEe86bQgjrZoBDxmIebpdyAQ==
X-Received: by 2002:adf:ecc1:0:b0:2c5:3d7d:8662 with SMTP id s1-20020adfecc1000000b002c53d7d8662mr616932wro.58.1675934997655;
        Thu, 09 Feb 2023 01:29:57 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id i3-20020adffc03000000b002c53d69a8easm337100wrr.92.2023.02.09.01.29.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Feb 2023 01:29:57 -0800 (PST)
Message-ID: <8cf0cfac-2998-39aa-e5e1-7b674d13d2cb@linaro.org>
Date:   Thu, 9 Feb 2023 10:29:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 04/11] dt-bindings: irqchip: sti: remove stih415/stih416
 and stid127
Content-Language: en-US
To:     Alain Volmat <avolmat@me.com>, Jonathan Corbet <corbet@lwn.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, linux-pm@vger.kernel.org,
        linux-clk@vger.kernel.org
References: <20230209091659.1409-1-avolmat@me.com>
 <20230209091659.1409-5-avolmat@me.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230209091659.1409-5-avolmat@me.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/02/2023 10:16, Alain Volmat wrote:
> Remove bindings for the stih415/stih416/stid127 since they are
> not supported within the kernel anymore.
> 


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

