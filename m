Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4185F5FDA
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 06:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiJFEAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 00:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiJFEAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 00:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ABD658B69;
        Wed,  5 Oct 2022 21:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C89AD6183B;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 331FAC43144;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665028817;
        bh=0wjwyNDqg7u09oVQ2iDZTIyxewYvtoDk8yOqn/pDes8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Onrp9+mOhovB5R5j+e+idhXIv8eIMjDyEzWNql5/Mkmo589mJZuG2WQnxlfXE/Plq
         eFyNgCHz4Tt5qyZPilHn9SqMqL4ips7jB+h5/U1KHAIbA3ZQavxiyLee2zIH78XM7T
         Enk5k6U1Zrw2rlap7enWw8Vj2AFpbKXG7SoSxFdX2swx2/Glh7uGZn+MS+vWeevsJv
         xcvnW8oeQI8bqBxYLo4QjLC+qF+WKa2xbiyoVJhhDvBMfw7DF+x3+zfoi4qfHpQT+h
         d2drUp/p+94HXV4SGTqb2M3NCAU2kfVNJVfugDsEnrzPktXuPL/t8+olW4GqwgWA9p
         Tfgchisl+HXIQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1521BE524C5;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: pse-pd: PSE_REGULATOR should depend on REGULATOR
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166502881708.31263.5341246982723930529.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Oct 2022 04:00:17 +0000
References: <709caac8873ff2a8b72b92091429be7c1a939959.1664900558.git.geert+renesas@glider.be>
In-Reply-To: <709caac8873ff2a8b72b92091429be7c1a939959.1664900558.git.geert+renesas@glider.be>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, linux@rempel-privat.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Oct 2022 18:23:53 +0200 you wrote:
> The Regulator based PSE controller driver relies on regulator support to
> be enabled.  If regulator support is disabled, it will still compile
> fine, but won't operate correctly.
> 
> Hence add a dependency on REGULATOR, to prevent asking the user about
> this driver when configuring a kernel without regulator support.
> 
> [...]

Here is the summary with links:
  - net: pse-pd: PSE_REGULATOR should depend on REGULATOR
    https://git.kernel.org/netdev/net/c/304ee24bdb43

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


