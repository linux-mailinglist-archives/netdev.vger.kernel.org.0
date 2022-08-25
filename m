Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D6B5A19ED
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiHYUB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243542AbiHYUA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1AF7E329
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4677EB82B0D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7EEAC4347C;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661457618;
        bh=ZN58hScXjEgQuMrX53Xpk1eh79Nbi5T+gKc0YlRFbM4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UQfDCA6xFVZxzrW3HxqjWKW1mxkpf6RBQccqe3h6QkfXuwTLFBmmKiccKOCXhKVvg
         hQk43LpHzi4BbELl5xS9fco0ObDL3raEElk3SFn06ciYohUOqmq+iLqFeNO5yvkW5F
         21k2di2P3b+R1p7B8rfTFXojt5BEdd+0sORGM2n2od9lH8iUOAirKbR1GnGj5dz+0T
         31xGquKcunOGI2HIh2N7EKst4JA1md9Sgzvuy7kT+EChmhjeAFa9Q7a2FAXv2EFTmk
         rw0QOdSNzBLfWgUIpXQAnBuUDn/tiaiiwQ6/XqV8iW3maKsBp8/lt73NLT0EAUevD3
         keF2HmOXZ7w3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CD7C5E2A03D;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ionic: bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166145761783.4210.7147842139868392694.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 20:00:17 +0000
References: <20220824165051.6185-1-snelson@pensando.io>
In-Reply-To: <20220824165051.6185-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io, mohamed@pensando.io
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 09:50:48 -0700 you wrote:
> These are a couple of maintenance bug fixes for the Pensando ionic
> networking driver.
> 
> Mohamed takes care of a "plays well with others" issue where the
> VF spec is a bit vague on VF mac addresses, but certain customers
> have come to expect behavior based on other vendor drivers.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ionic: clear broken state on generation change
    https://git.kernel.org/netdev/net/c/9cb9dadb8f45
  - [net,2/3] ionic: fix up issues with handling EAGAIN on FW cmds
    https://git.kernel.org/netdev/net/c/0fc4dd452d6c
  - [net,3/3] ionic: VF initial random MAC address if no assigned mac
    https://git.kernel.org/netdev/net/c/19058be7c48c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


