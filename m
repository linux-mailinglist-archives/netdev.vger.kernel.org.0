Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C657BB46
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbiGTQUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbiGTQUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64255DE99;
        Wed, 20 Jul 2022 09:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0052161D7C;
        Wed, 20 Jul 2022 16:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54604C341D0;
        Wed, 20 Jul 2022 16:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658334017;
        bh=BYcsMcijnL0pP/PiWG5nGWH7n3G0OWC2Q7MrG+Nlvj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gGZxmosbDLlniOH0n0Z2mWELtNt2g2Yiu+vasUz2lXZoC6r/ND4Sbm53IyTN1fQiQ
         JFwzRSYKrt/j8Rfmxy79FGrFD5NSE+QXn6FENpSmvcoIjCDn6AsSXtfSCBibNnJwDJ
         HANbFFlCSR8f5wTlKRtoOS82U9Yfdf5Q+lWjhuIKej98CQX5dvq8YUcvisl8pPAOPE
         jz9fGU8Xy0q756JqdSWbMpSbKJXH3tcntD7DMl5HkTXaEtg42McVoBjOI5cQCgKY7N
         gK11foWL6nbBGyeJoFZf8Mm9bNznXk45XXdKN0ogumzNkygmvv4ZCZ0Wf/tkRAoBBe
         KvRisABq9/xzA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CF98E451BD;
        Wed, 20 Jul 2022 16:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/5] Bluetooth: hci_bcm: Improve FW load time on CYW55572
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165833401724.6265.284056488301192508.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 16:20:17 +0000
References: <cover.1656583541.git.hakan.jansson@infineon.com>
In-Reply-To: <cover.1656583541.git.hakan.jansson@infineon.com>
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linus.walleij@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        linux-bluetooth@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Thu, 30 Jun 2022 14:45:19 +0200 you wrote:
> These patches add an optional device specific data member to specify max
> baudrate of a device when in autobaud mode. This allows the host to set a
> first baudrate higher than "init speed" to improve FW load time.
> 
> The host baudrate will later be changed to "init speed" (as usual) once FW
> loading is complete and the device has been reset to begin normal
> operation.
> 
> [...]

Here is the summary with links:
  - [v2,1/5] dt-bindings: net: broadcom-bluetooth: Add CYW55572 DT binding
    https://git.kernel.org/bluetooth/bluetooth-next/c/c6480829cda7
  - [v2,2/5] dt-bindings: net: broadcom-bluetooth: Add conditional constraints
    https://git.kernel.org/bluetooth/bluetooth-next/c/f5d25901c5cc
  - [v2,3/5] Bluetooth: hci_bcm: Add DT compatible for CYW55572
    https://git.kernel.org/bluetooth/bluetooth-next/c/7386459d24b3
  - [v2,4/5] Bluetooth: hci_bcm: Prevent early baudrate setting in autobaud mode
    https://git.kernel.org/bluetooth/bluetooth-next/c/31e65c6d44a2
  - [v2,5/5] Bluetooth: hci_bcm: Increase host baudrate for CYW55572 in autobaud mode
    https://git.kernel.org/bluetooth/bluetooth-next/c/719a11a62d19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


