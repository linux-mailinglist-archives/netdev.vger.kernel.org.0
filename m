Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2808A53DA26
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 06:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbiFEEuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 00:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233427AbiFEEuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 00:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964E02B255;
        Sat,  4 Jun 2022 21:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4DF2FB80B1B;
        Sun,  5 Jun 2022 04:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA623C3411D;
        Sun,  5 Jun 2022 04:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654404612;
        bh=RX2wEaBw82qW8ojxQw9653S7XMkj3wRobXYqpSRQXHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Egz0oID1xgX3HW6VgujboCzNGYko9LjV06+5OEQl7pDIhGxPeoXK1fR0ILGnN3m4P
         v7HA1i7YdI+kxT2FifkSxNhApGx7OAavtLgd5EboylGcj83eXhcS/kwdfFqhl0LKM+
         4gD1vX0mGNYAlKgzT7J4TQ/Q14pBjG5tzjBMn3ak3g6IDSrCI8jUC0cBarEeb6UBGJ
         Q4uDsUztxufbv8GX47JN2N6YVj6hFvOyXZh27MWMY7GeobnsB5nGpOb/aWKb1xVuVP
         80ukjIls+QU18BePxPxd0tUIbqzSEjDk+vcMHW2LzEwK0mhK7SNIjVfg9W2XIK3XUp
         LuWEmWZIC1mrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFFEFF03875;
        Sun,  5 Jun 2022 04:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT
 binding
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165440461278.31102.12185070226615381233.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Jun 2022 04:50:12 +0000
References: <20220524055642.1574769-1-a.fatoum@pengutronix.de>
In-Reply-To: <20220524055642.1574769-1-a.fatoum@pengutronix.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     kernel@pengutronix.de, krzysztof.kozlowski@linaro.org,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Tue, 24 May 2022 07:56:40 +0200 you wrote:
> The BCM4349B1, aka CYW/BCM89359, is a WiFi+BT chip and its Bluetooth
> portion can be controlled over serial.
> Extend the binding with its DT compatible.
> 
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] dt-bindings: bluetooth: broadcom: Add BCM4349B1 DT binding
    https://git.kernel.org/bluetooth/bluetooth-next/c/534fdae369a8
  - [v2,2/2] Bluetooth: hci_bcm: Add BCM4349B1 variant
    https://git.kernel.org/bluetooth/bluetooth-next/c/a589ee43644c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


