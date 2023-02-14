Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE95696C1F
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 18:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbjBNR6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 12:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjBNR6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 12:58:24 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFD8298F7;
        Tue, 14 Feb 2023 09:58:23 -0800 (PST)
Received: from [192.168.1.90] (unknown [86.120.32.152])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: cristicc)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 7A0E866020A4;
        Tue, 14 Feb 2023 17:58:20 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1676397501;
        bh=Y4hHrvH1B5sqY1by0xSyqs58y8vsVlrsUYCjBXVOzgQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Rgmm1hRkkv36vX6S4kwZIjU9y/lgmTGeV1Ia4edMQzQc5k1JaZ8iGWswYiuLBwi9Q
         2uK87DtWhOESGqcYttatohf6TdFHjHCqmroabZKzcKSZZjXHXeIVL7gpG0KEEUN0kp
         RtFBlMdQYBo434oxLBE1oz9KusXyFiOHVzBJXqc9lVWBYGJrsh28lgG6PdFHhbzej+
         d8ILeq6tvjsKxNTqduLQD83xIa6iQQr/O3N3oobNAqdQJl9hrjQuSfCj2kDCnClnaH
         YRt2b1788WywrxWnTLmmsJ8ZIK+ImFPwx+8FUQwuNyvJMaM1FrR9iAB6rfnpusp7NT
         DFVnRoNAD2Mww==
Message-ID: <bed5244c-fcb5-1f95-9ff8-81c3a96ecff9@collabora.com>
Date:   Tue, 14 Feb 2023 19:58:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 02/12] dt-bindings: riscv: sifive-ccache: Add
 'uncached-offset' property
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
 <c895f199-2902-4c22-2453-829d946a8d11@linaro.org>
Content-Language: en-US
From:   Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
In-Reply-To: <c895f199-2902-4c22-2453-829d946a8d11@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/23 11:23, Krzysztof Kozlowski wrote:
> On 11/02/2023 04:18, Cristian Ciocaltea wrote:
>> Add the 'uncached-offset' property to be used for specifying the
>> uncached memory offset required for handling non-coherent DMA
>> transactions.
> 
> Only one offset can be non-coherent? If this is for DMA, why
> dma-noncoherent cannot be used?

As Conor already mentioned in [1], the handling of non-coherent DMA on 
RISC-V is currently being worked on, so I expect this patch will be dropped.

[1] https://lore.kernel.org/lkml/Y+d36nz0xdfXmDI1@spud/

Thanks for reviewing,
Cristian

> 
> Best regards,
> Krzysztof
> 
