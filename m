Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06CD5519280
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 02:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244432AbiEDADs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 20:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiEDADr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 20:03:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4962F0;
        Tue,  3 May 2022 17:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76DF461825;
        Wed,  4 May 2022 00:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1DFDC385AF;
        Wed,  4 May 2022 00:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651622412;
        bh=i6oF5145q/80b0LS0IVZXjYBiMYx+MSVDUM1hnMdXJA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hynORkqL9RCwNjNTiq98Ho99G0QeABHgHGQSxe/fhO0LSviCjJ8uBszlXix6GF3Sk
         ekqUtopaoKBJ5UpkbmJEXDoEW6bRdiIana/twNnCjNI6LNFMUaZnKKjsbjFyle1j5A
         mRG9sFSaStvfnoxOF6flMXC70l1Kj9x8yPLUC9HBaLjF3iY1TdSscnZmwudlAIEOjT
         UJ/rzP4mipKO0KmBqcs8jU7AcsQPmhxKRpFMGkXqC0fYXUY9BcrAEpVhLhm9ccGdNJ
         7hAHmi2bx71LXqE9MWM9g6FIQ2xIv7glKeIFKxlEv9NbQNpn2vrexe4E/UgUxqhQmT
         3dLlNBIwrFBzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B74BCE8DD77;
        Wed,  4 May 2022 00:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: sfp: Add tx-fault workaround for Huawei MA5671A SFP
 ONT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165162241274.8175.17349630571640586770.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 00:00:12 +0000
References: <20220502223315.1973376-1-mnhagan88@gmail.com>
In-Reply-To: <20220502223315.1973376-1-mnhagan88@gmail.com>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 May 2022 23:33:15 +0100 you wrote:
> As noted elsewhere, various GPON SFP modules exhibit non-standard
> TX-fault behaviour. In the tested case, the Huawei MA5671A, when used
> in combination with a Marvell mv88e6085 switch, was found to
> persistently assert TX-fault, resulting in the module being disabled.
> 
> This patch adds a quirk to ignore the SFP_F_TX_FAULT state, allowing the
> module to function.
> 
> [...]

Here is the summary with links:
  - [v2] net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT
    https://git.kernel.org/netdev/net/c/2069624dac19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


