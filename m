Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994546940D7
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBMJXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:23:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjBMJXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:23:07 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEAA5BAC
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:23:04 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id bu23so11381374wrb.8
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nceynFwfOSQ9gK3dwBYGl+Y9+g5oSlogmBdnLLAMDvE=;
        b=qF9OgKwoIo3IN1BRJSx1gzKZ8I4VRcThWO2fHPpvwU/3bFl/NndvGECxwJCyvo05tD
         S6hmSGetGMkTK1MSG4AkXFW+t1rV7Adxnv+oGwp5L7s//YXWBqku8JzYmTVUWZ4+XG18
         IcZp4C637ehPWZONZ0dTO256y5ayeOOcNR41VtTYZsRizzcPOiYKg1tanzLmBiYnpEw/
         TjzrW5HsIu1uqQ1Eq1w9deYclwP+PH2A8juwEUrwXSLWEF8ngX07zdhgK9wUHHo3Opra
         l5jcyE/Bp886nNY/JyOQjsypQB9pLUme36IO70cvMByt/5R6yoTD7zx0ev38D5a8LKf+
         bCEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nceynFwfOSQ9gK3dwBYGl+Y9+g5oSlogmBdnLLAMDvE=;
        b=OnDFDLiXDruBFPORJqWdi00Ip/RjsHp10oJmsOhxa0ePM6k3OoNnv81hKF9pn2SKj7
         G44daFpB98y7ZOC8Fs3a/7d84jlpC1f4ziiIIBXAM94RulHmF1Q8aemLvx9NJ2Ar69ts
         1F5Kx+VPR3V9+oevJXQU2fLpt2l2awOM8tyAOySVNCFB78XE7f/Wpcwbty1VbmlPs2Wo
         LoXC8hfYVly22o2l1MlddFuV63JQrulphGSTY/vXhITExB4EF8YAE1ZLSl3IsVy7TTqN
         UlY3L2gx/z3Reak1VwFst/jOnWVUWX2581N9eimZn2XdY9GNkDKenggOHT4XG9Em/er3
         l8cQ==
X-Gm-Message-State: AO0yUKXX7ZIqPNUx/jn4kPuQtS2B3NRpLamebT8fF+jCa0gqc4pDmzHF
        t1laVMuh1gS5o953AAUCVpH9cQ==
X-Google-Smtp-Source: AK7set/WMjt6si446XYviUem9Dvz4X7zmBCVn/zBEupkIDEh5g+cbzG/LyjEhdhl1+XKTXHF20iTbw==
X-Received: by 2002:a05:6000:1f8a:b0:2c5:5297:24ae with SMTP id bw10-20020a0560001f8a00b002c5529724aemr4519362wrb.2.1676280183186;
        Mon, 13 Feb 2023 01:23:03 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id o7-20020a056000010700b002c559def236sm1438290wrx.57.2023.02.13.01.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:23:02 -0800 (PST)
Message-ID: <c895f199-2902-4c22-2453-829d946a8d11@linaro.org>
Date:   Mon, 13 Feb 2023 10:23:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 02/12] dt-bindings: riscv: sifive-ccache: Add
 'uncached-offset' property
Content-Language: en-US
To:     Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Lee Jones <lee@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Conor Dooley <conor@kernel.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sagar Kadam <sagar.kadam@sifive.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@collabora.com
References: <20230211031821.976408-1-cristian.ciocaltea@collabora.com>
 <20230211031821.976408-3-cristian.ciocaltea@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230211031821.976408-3-cristian.ciocaltea@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/02/2023 04:18, Cristian Ciocaltea wrote:
> Add the 'uncached-offset' property to be used for specifying the
> uncached memory offset required for handling non-coherent DMA
> transactions.

Only one offset can be non-coherent? If this is for DMA, why
dma-noncoherent cannot be used?

Best regards,
Krzysztof

