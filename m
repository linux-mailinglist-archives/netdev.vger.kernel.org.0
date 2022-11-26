Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEB8639616
	for <lists+netdev@lfdr.de>; Sat, 26 Nov 2022 14:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbiKZNZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 08:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKZNZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 08:25:15 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAE4E0EB
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 05:25:15 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id z4so8051530ljq.6
        for <netdev@vger.kernel.org>; Sat, 26 Nov 2022 05:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Na6FyrdsS1wwt6jy4jKZXGg53Il9zjDGwsbPs6Y7vs8=;
        b=ojwqnhX4HWIRw/01nosPbAo+kI1IeXq4oX6pTqV7VqEAjHwiSgIMn8vz/cI9OG/fvZ
         lwRlXt2Ob7aRq1D+/MBJQlUvc4cdmFsC+8i8jq2hfEqaFNwyITvTyja+ZySaXx9WiPbL
         AhxTVSiyyTcurXiBz5+0uBt7dQP2fvzP+amc9BH1XQhwhtDeXAwKn7v4GVWaKeRG5FTr
         oQoSF9ZqxnDo9qt2+F1geCe7WYPySfPEui0AKJe39HxvhG82a6QOUpxX1koK/CYvMMrt
         Dx6zVKKQ94b/YCeYD/fQxWKOP128ad71EABMwSJxRnV/iRgWeHcxDGDX9EKfRqgK7Ofn
         UnEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Na6FyrdsS1wwt6jy4jKZXGg53Il9zjDGwsbPs6Y7vs8=;
        b=s1xVR01m4JG2f/PQ/lLUXB6mNr/ljXg+tCLkUgePZsuEGppC0zYpc4hBkmaDJhYrLz
         +f6MLkFCansHNzY5dBAew33J8q9KUVyU96Z6FZp5lOgNg9VsmLeZOUmDs9uepMRb7SKP
         Jw+bcvPMFPOpbLaUGJa5/4/iWglbXbI28sVMXb2xKF3Ee21X+HDcWqNuZX8PHqRjlclu
         jcvNTQqmD4FDHltF05ERcUQ41d7LBRWbtTV7h5SU3p3Gonl+PjhhPARxv/+686AEVoXV
         FtAA5SzqxoB0wg3Ic3y7EPVPYQanmu1vo4ZLfk+Bv+tREi10r7cnUSqDAUcSejlQkHHt
         J0xw==
X-Gm-Message-State: ANoB5pmLuFq11yxyjiJy5vU0CYFEohM0lfNJWN59DoF6MprXpmRPObYn
        qDLw4TuCpBbfFFlkc/xE+fblSQ==
X-Google-Smtp-Source: AA0mqf4Hn5l8emZqaUsEMB85V+2yCjIoYVk6ezOS+6dfnBzhS/2LGcz8sUEWDiUDm0/4MtMTl8wmbA==
X-Received: by 2002:a2e:aa14:0:b0:277:63f7:492c with SMTP id bf20-20020a2eaa14000000b0027763f7492cmr8428769ljb.259.1669469113410;
        Sat, 26 Nov 2022 05:25:13 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id t6-20020a199106000000b004b4b5d59cbcsm922230lfd.265.2022.11.26.05.25.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Nov 2022 05:25:12 -0800 (PST)
Message-ID: <d84ff258-d3e1-45e0-4473-7cd0707ae17f@linaro.org>
Date:   Sat, 26 Nov 2022 14:25:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/3] dt-bindings: net: sun7i-gmac: Fix snps,dwmac.yaml
 inheritance
Content-Language: en-US
To:     Samuel Holland <samuel@sholland.org>, Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     LABBE Corentin <clabbe.montjoie@gmail.com>,
        Maxime Ripard <mripard@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@lists.linux.dev, netdev@vger.kernel.org
References: <20221125202008.64595-1-samuel@sholland.org>
 <20221125202008.64595-2-samuel@sholland.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221125202008.64595-2-samuel@sholland.org>
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

On 25/11/2022 21:20, Samuel Holland wrote:
> The sun7i-gmac binding extends snps,dwmac.yaml, and should accept all
> properties defined there, including "mdio", "resets", and "reset-names".
> However, validation currently fails for these properties because the
> local binding sets "unevaluatedProperties: false", and snps,dwmac.yaml
> is only included inside an allOf block. Fix this by referencing
> snps,dwmac.yaml at the top level.
> 

I don't understand where is the problem and how does your patch solve
it. The old syntax is correct and your change does nothing, no fixing,
no impact. It actually looks like noop with big explanation :(

> Signed-off-by: Samuel Holland <samuel@sholland.org>
> ---


Best regards,
Krzysztof

