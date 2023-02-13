Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3445C694115
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjBMJ15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjBMJ1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:27:33 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268F61717C
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:25:36 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id o18so11423670wrj.3
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 01:25:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xSldNry3NWzuJ0zp8Ypcr2h0zI4yvHSm7LEOUZUqMKw=;
        b=OQ5yMzSQ7q+ZY08Q8rg+9cPVvhvYSSpp/vgo+xhT/XLgxQ/r+zI7EO5vb9rcYSCQSt
         mbwcinxALpM0bjyKNRslIzyCJ/W5VfVvQePr6ntDxS2Czpnc4xSvuNK9evWMsL6kgOG5
         7XNEk1Sax2GzoIzMCkBFUhHPPFJzmx6HozvsrAnDkRYfTF6EbjNFKjXCtUwpJgWpyfSA
         0AALWPB3KjKEnbaJ6qHbUeDasMdAKurhOD0sebSQpuEru2s4c1AEk1NpF3Si+vrZpTYh
         x5XIeTK4Gopo5SoJnGBLlxFVsw9oDMeTgid+4sYvjUT1YE2LPQh3iohtL7skakEG52eX
         m1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xSldNry3NWzuJ0zp8Ypcr2h0zI4yvHSm7LEOUZUqMKw=;
        b=zvUvDjJmgozlzrnmbK07AIT+HzQN+nivAhFv1AiRrRAy5sXkSoPY2rTRZQLa9+ehzn
         3xpNuJNxoWD2Rtl/zDUs7hpPFXSXmyHxQcn94+SaJlYyrG0KBR6XkpsJqF1Bzkh1RIHY
         FpO9KEXfFkfVeYHu0X4D66N7m0+3JtIWVpOa4ebwnpQ4TOoksRn0abSi9vF5Vk7fjnD8
         M+PRJWEQFsg762k6Wq0R/lt/LOJc0fBTub4S3nvCo5PsUZ6TiBX5hkM9iv4j/Usj+HNK
         f6IQFJefT3RVZQprnR/sQxc6CDyHaADtTiCWl6b0wE0bOW8uzXHiDNpcJE1qzVsfUCiT
         x80A==
X-Gm-Message-State: AO0yUKVPG/R20dbWB39uViQ1lAOcu6pv712LX/XKcV37Od8P35IjrAH5
        vPoVgV9y6KJOzfJBL/mzZxR/yA==
X-Google-Smtp-Source: AK7set9ZqU8XLcewYFcYk+YS1UR5EMjdCdUAe+0yn67Ao2gAARnvEvunO2pnpdKZ5aph1W8194djhw==
X-Received: by 2002:a05:6000:147:b0:2c5:3cd2:b8e with SMTP id r7-20020a056000014700b002c53cd20b8emr10262827wrx.1.1676280329198;
        Mon, 13 Feb 2023 01:25:29 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id g9-20020a5d5409000000b002c558228b6dsm2670211wrv.12.2023.02.13.01.25.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 01:25:28 -0800 (PST)
Message-ID: <5e7cf78c-9402-1b27-6a19-8326fe5c8e18@linaro.org>
Date:   Mon, 13 Feb 2023 10:25:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 07/12] dt-bindings: net: Add StarFive JH7100 SoC
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
 <20230211031821.976408-8-cristian.ciocaltea@collabora.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230211031821.976408-8-cristian.ciocaltea@collabora.com>
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
> Add DT bindings documentation for the Synopsys DesignWare MAC found on
> the StarFive JH7100 SoC.
> 
> Adjust 'reset' and 'reset-names' properties to allow using 'ahb' instead
> of the 'stmmaceth' reset signal, as required by JH7100.
> 
> Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
> ---
>  .../devicetree/bindings/net/snps,dwmac.yaml   |  15 ++-
>  .../bindings/net/starfive,jh7100-dwmac.yaml   | 106 ++++++++++++++++++


FYI, there is conflicting work:

https://lore.kernel.org/all/20230118061701.30047-5-yanhong.wang@starfivetech.com/

It's almost the same, thus this should be dropped.

Best regards,
Krzysztof

