Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E4F584B2E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiG2Fai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbiG2Fa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:30:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9C519C22;
        Thu, 28 Jul 2022 22:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29E4761E9B;
        Fri, 29 Jul 2022 05:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1AC28C4314C;
        Fri, 29 Jul 2022 05:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659072620;
        bh=3y4iCzvWHSGEPHGXdD/2/vW0USQnjAW6Y8oAhqC27sA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FNRtTfovGowpOU2x9WPLh9rWkDHalOY2BY9IXgnOTqCPAEYz10D9IQGQ51b9QCFKG
         echeI6p8+ocxCjAgwY4f9BuCVzXYwBVDtbZuJiw0Eu3aDJTAh46k40jdC83U36uesz
         ukoPironiGLRjmdKM/cQde/wfI91bVLTjICf1yVUqt/yqqiJ2ZPrpGbi8qZ4vAOEwL
         zj08RZU+L+GR50GKoIzl5tkowX29JWtww2k1S2F/Rg2Aw4l8IytFAlV9981Oc276Jr
         S520Tf9zdZbliOvRd5WzSml1PM91gcA79Tt4IgNIpDpwkfKtg2bydw4Znf8TaovNtH
         dRU1pT0xH2oZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3045C43140;
        Fri, 29 Jul 2022 05:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] dt-bindings: nfc: use spi-peripheral-props.yaml
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165907261999.17632.4241150043277609522.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 05:30:19 +0000
References: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220727164130.385411-1-krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org, mgreer@animalcreek.com,
        kvalo@kernel.org, jerome.pouiller@silabs.com,
        adham.abozaeid@microchip.com, ajay.kathat@microchip.com,
        tony@atomide.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Jul 2022 18:41:29 +0200 you wrote:
> Instead of listing directly properties typical for SPI peripherals,
> reference the spi-peripheral-props.yaml schema.  This allows using all
> properties typical for SPI-connected devices, even these which device
> bindings author did not tried yet.
> 
> Remove the spi-* properties which now come via spi-peripheral-props.yaml
> schema, except for the cases when device schema adds some constraints
> like maximum frequency.
> 
> [...]

Here is the summary with links:
  - [1/2] dt-bindings: nfc: use spi-peripheral-props.yaml
    https://git.kernel.org/netdev/net-next/c/ba323f6bee1d
  - [2/2] dt-bindings: wireless: use spi-peripheral-props.yaml
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


