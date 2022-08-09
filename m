Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18A458D369
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 07:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiHIF7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 01:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235430AbiHIF7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 01:59:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38AF1D316;
        Mon,  8 Aug 2022 22:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EE41B811B1;
        Tue,  9 Aug 2022 05:58:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBA4C433D6;
        Tue,  9 Aug 2022 05:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660024737;
        bh=ZY0ccwDYxX4Fn+uGQpnneqiemjXQnOh06W4BfAG69o0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Ssj5BFwlQCfSiQBLcv36M6FF0ASv180cXXk4N/qvKwQIDstq7o/9FrgodhcbgOKeN
         0ZrrojuCMC8FtkExsn/VwhhCtHW9fuk/kF/v59NDs+cymveJG7lL3Fx44Xdq9HBe7R
         CGKjWo59NLd2IRLAU3/QIVZEFzBKKXALFR3vwl9LIu6s493e3S97jbOpHzDg66ZcuS
         7bN8XBA4/YZM+n5SvjBMQbX7ybgEt72xC5ufQtur7Qs+xSM3SlMjqPUAgVUV6P6WXi
         hLSEwT70jNYu8Fer7HDEACtLs/TQ2xl1Nzu7G5/VWMyplBkNsKrVqVjEqE7JUHtVe3
         IaytDPGEN4Q9g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 2/2] dt-bindings: wireless: use spi-peripheral-props.yaml
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220727164130.385411-2-krzysztof.kozlowski@linaro.org>
References: <20220727164130.385411-2-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Greer <mgreer@animalcreek.com>,
        =?utf-8?b?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Tony Lindgren <tony@atomide.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166002472926.8958.10247328337582431642.kvalo@kernel.org>
Date:   Tue,  9 Aug 2022 05:58:53 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> Instead of listing directly properties typical for SPI peripherals,
> reference the spi-peripheral-props.yaml schema.  This allows using all
> properties typical for SPI-connected devices, even these which device
> bindings author did not tried yet.
> 
> Remove the spi-* properties which now come via spi-peripheral-props.yaml
> schema, except for the cases when device schema adds some constraints
> like maximum frequency.
> 
> While changing additionalProperties->unevaluatedProperties, put it in
> typical place, just before example DTS.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Acked-by: Rob Herring <robh@kernel.org>

Patch applied to wireless-next.git, thanks.

15273b7b8b4f dt-bindings: wireless: use spi-peripheral-props.yaml

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220727164130.385411-2-krzysztof.kozlowski@linaro.org/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

