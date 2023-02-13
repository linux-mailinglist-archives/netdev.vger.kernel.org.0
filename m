Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8FE6940BE
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbjBMJUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBMJUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:20:09 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E45EC4F
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:20:08 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id m14so11358356wrg.13
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bNLG0F4sytAFJuPLCGJpmTMcMTuRJI0BMdm+O22mIWk=;
        b=h65cQMGeWFtfyp2uBNLZIv4aNJ8crvS/MegClRzuhEPjPg+BDdR7aqGJ9/8XON1Bbu
         2XZckirgzIKPNipgdUySyNJHJrZukrIayPooX+QCE92pl9aI7oQ7xxgpdLjhBnpDDAPx
         ZhZyBa5ldmmym80vqoKngS1doGl41+7ZaRSDZNOjybDPD4DsJsWs3Z+64em6pAzfT/Iu
         xCCuMtGP0ejC69sEtvzbxgq3YINw3hLGcc2NKAVJf7649m1FuUeyHhG+EzSEIGZu4wDd
         rWYQWhSxHz6TCKYelQvbL1+SZVCWz5+AjihuLGHlsfu4ryj01UUEvu3Emw3dWnybevup
         XjdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bNLG0F4sytAFJuPLCGJpmTMcMTuRJI0BMdm+O22mIWk=;
        b=xAWZdq4uwd+NUdEAHCW4tnnIhVGPlf0ZzzaNw8xatCqA6dQ02bag84twzRXCsn7Qvv
         XK269mL8s7hPwVl6LoJaw9E0eVpHrej0156KDE8rjy0vZWtE8sFc/dFXR7PuqAxiOkFN
         IQE6CHGibBcWrGvoc9/JAYmMgIM+VBN2Pf5+bKMknqAgFYvVeGwbcoTqOz3yGbKw37jU
         fxHD53eBobPdFdsVkCDMCr2ar25cUnqf5iT8f6xsI/pzVEX6xi162IQ7T0FKHjxQsXoW
         6qPlQBhYCvlkcDvG4kIUkGOqVMtF14JRr0JcRY8qRwriP+KxEhIwtJoF75EnmyvlbSAX
         JM8Q==
X-Gm-Message-State: AO0yUKX8Uf7Yow+a0aRGS4+/x1XN5AsEAKsj50cFlHCiBP1bH6o5eACv
        Ap8Ga3Zy84QkhD+l/ojQTrmGgA==
X-Google-Smtp-Source: AK7set9P9Rf/AgDFodMfFUkknlWiakKXK72hhfRuVm1tf2m8kXJEnbrxw1VZm/dlh2YKzny9lQPCuw==
X-Received: by 2002:a5d:4682:0:b0:2c5:588f:c5c4 with SMTP id u2-20020a5d4682000000b002c5588fc5c4mr2650463wrq.37.1676280006817;
        Mon, 13 Feb 2023 01:20:06 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id m18-20020a5d6252000000b002c3dc4131f5sm10133668wrv.18.2023.02.13.01.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:20:06 -0800 (PST)
Message-ID: <17e7a0f4-38b2-cfc7-3058-1fea7bb28b81@linaro.org>
Date:   Mon, 13 Feb 2023 10:20:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 01/12] dt-bindings: riscv: sifive-ccache: Add compatible
 for StarFive JH7100 SoC
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
 <20230211031821.976408-2-cristian.ciocaltea@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230211031821.976408-2-cristian.ciocaltea@collabora.com>
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
> Document the compatible for the SiFive Composable Cache Controller found
> on the StarFive JH7100 SoC.
> 
> This also requires extending the 'reg' property to handle distinct
> ranges, as specified via 'reg-names'.


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

