Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C5D514083
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 04:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354144AbiD2CNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 22:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354039AbiD2CNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 22:13:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EFE5DE73;
        Thu, 28 Apr 2022 19:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F08CBB83286;
        Fri, 29 Apr 2022 02:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99607C385AC;
        Fri, 29 Apr 2022 02:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651198212;
        bh=AJ5Jat7HKF1Zf8NM9PJvy7FebfZSygpCy9NpD6KGHRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fVp+f5Ean4CS1mQk5XM86ZvWsEEZCSf/jidKzhc6u+4JYc4oY3kaFjBCkg0d3NRWx
         ZHUr3u4e6KKXtAg7/Zif57lo2ljXaC1dlWKCzz5+2nALzvraB4BYfkoPwlgfbPlLkF
         hdfcML7Eq2wNA0umS/VQCQMRn1AVWhBbXgyX0GYmMvLtzSQpsSguCeTKIdRCMpUmFk
         FCdgOpi4On29IHg55FesOAlwCOnigZlJeFSMWwLIfwKe1lrogNaJs74BF1k2Is+dKN
         mKOIzJOMAbYOS+YgBfPnYN8s+c4O2MkUPi3vv5uNdKZ72VOm6rgD7krTwK7s2dx5nx
         rZEglq9B9iG9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BA87F03848;
        Fri, 29 Apr 2022 02:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: mv88e6xxx: Single chip mode detection for
 MV88E6*41
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165119821250.31798.7503202014246007781.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Apr 2022 02:10:12 +0000
References: <20220427130928.540007-1-nathan@nathanrossi.com>
In-Reply-To: <20220427130928.540007-1-nathan@nathanrossi.com>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Apr 2022 13:09:28 +0000 you wrote:
> The mv88e6xxx driver expects switches that are configured in single chip
> addressing mode to have the MDIO address configured as 0. This is due to
> the switch ADDR pins representing the single chip addressing mode as 0.
> However depending on the device (e.g. MV88E6*41) the switch does not
> respond on address 0 or any other address below 16 (the first port
> address) in single chip addressing mode. This allows for other devices
> to be on the same shared MDIO bus despite the switch being in single
> chip addressing mode.
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: mv88e6xxx: Single chip mode detection for MV88E6*41
    https://git.kernel.org/netdev/net-next/c/5da66099d6e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


