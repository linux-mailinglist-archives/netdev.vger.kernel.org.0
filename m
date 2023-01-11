Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5216662EB
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:41:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbjAKSk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjAKSkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660CE1AD82;
        Wed, 11 Jan 2023 10:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1960DB81CA4;
        Wed, 11 Jan 2023 18:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 92F2BC433EF;
        Wed, 11 Jan 2023 18:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673462418;
        bh=ZEmryboLk5mj+5TUuTuCS6naNIRPhdyWhLOCWdpU+D0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iSyIQ2yyoC3B0GBCDQJdd/AjVnQhPtqHCRIbEkSrrHdUq7RF962QX/zB0ITIfYfSA
         3/D81YsFoplAuk07q+rs1ROy+hGaHCuTObSwnYmfwqifrJljRKGWDsoz836weNNaBo
         GLiDiGuqi20c1B+V3/gbU/jYToaZNaxVHsO2SJoqO/g+pt2hlJVfs4yRYd7BquKLHK
         W8sVu6wNviooo9e/w3eIH25eRm9LQVQdVsIfozC5UJQ6yZtvHf7HBHp7sWyPjsPLkg
         drRe9DoPTVOOD655oQch1MEgH31f/rE7CuAFGxVIDiUEFzzr0TtWcqwswEQUzSoFCV
         dpRICWt9nlOEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DDAFE4D025;
        Wed, 11 Jan 2023 18:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 00/11] dt-bindings: first batch of dt-schema conversions
 for Amlogic Meson bindings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167346241843.19883.15310921170918729898.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 18:40:18 +0000
References: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
In-Reply-To: <20221117-b4-amlogic-bindings-convert-v2-0-36ad050bb625@linaro.org>
To:     Neil Armstrong <neil.armstrong@linaro.org>
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        khilman@baylibre.com, jbrunet@baylibre.com,
        martin.blumenstingl@googlemail.com, srinivas.kandagatla@linaro.org,
        wim@linux-watchdog.org, linux@roeck-us.net, mchehab@kernel.org,
        a.zummo@towertech.it, alexandre.belloni@bootlin.com,
        daniel.lezcano@linaro.org, tglx@linutronix.de, vkoul@kernel.org,
        kishon@kernel.org, ulf.hansson@linaro.org, bhelgaas@google.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, linux-media@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-pci@vger.kernel.org,
        netdev@vger.kernel.org, krzysztof.kozlowski@linaro.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 09 Jan 2023 13:53:25 +0100 you wrote:
> Batch conversion of the following bindings:
> - meson_sm.txt
> - amlogic-efuse.txt
> - amlogic-meson-mx-efuse.txt
> - meson-wdt.txt
> - meson-ir.txt
> - rtc-meson.txt
> - amlogic,meson6-timer.txt
> - meson-gxl-usb2-phy.txt
> - amlogic,meson-gx.txt
> - amlogic,meson-pcie.txt
> - mdio-mux-meson-g12a.txt
> 
> [...]

Here is the summary with links:
  - [v2,01/11] dt-bindings: firmware: convert meson_sm.txt to dt-schema
    (no matching commit)
  - [v2,02/11] dt-bindings: nvmem: convert amlogic-efuse.txt to dt-schema
    (no matching commit)
  - [v2,03/11] dt-bindings: nvmem: convert amlogic-meson-mx-efuse.txt to dt-schema
    (no matching commit)
  - [v2,04/11] dt-bindings: watchdog: convert meson-wdt.txt to dt-schema
    (no matching commit)
  - [v2,05/11] dt-bindings: media: convert meson-ir.txt to dt-schema
    (no matching commit)
  - [v2,06/11] dt-bindings: power: amlogic,meson-gx-pwrc: mark bindings as deprecated
    (no matching commit)
  - [v2,07/11] dt-bindings: timer: convert timer/amlogic,meson6-timer.txt to dt-schema
    (no matching commit)
  - [v2,08/11] dt-bindings: phy: convert meson-gxl-usb2-phy.txt to dt-schema
    (no matching commit)
  - [v2,09/11] dt-bindings: mmc: convert amlogic,meson-gx.txt to dt-schema
    (no matching commit)
  - [v2,10/11] dt-bindings: PCI: convert amlogic,meson-pcie.txt to dt-schema
    (no matching commit)
  - [v2,11/11] dt-bindings: net: convert mdio-mux-meson-g12a.txt to dt-schema
    https://git.kernel.org/netdev/net-next/c/82fc0f87cd2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


