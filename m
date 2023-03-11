Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790CA6B57CA
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 03:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCKCUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 21:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbjCKCUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 21:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43611F1691
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 18:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7194B8245A
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 02:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B9F0C433EF;
        Sat, 11 Mar 2023 02:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678501218;
        bh=oJOUU818+FX/I12kSFAZPm0JyH+HPCUGssfe32TxN9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HvQF42UVF8PjLSjG+9As6iKH0aoJzjwa39K8icPRQFj3uuFw+Y0HCACpkcdw/7rnu
         uHdX3xjhTdgTJht+Eb0tT787prUvG+9hhNF/2aLczeuUkLkq5Ua3Tvj1As+JGKdfCi
         0l0H2NjqfpPlwSFdHzAgYyF0r28fmwWhLtDZfUAEPKPiGNvaLfnrc7/alLaHcFkFfZ
         k3ECJF144y2mlm1NW38gHT1ARyqlim3H68Cis7l3dJN2D7u9b4+8BMtH5QQ/jrWc7X
         EpHuP2ALkyBLBnWdWx5YvVo30TwUwtTFlvFNcMfazj0jZJVqGVNsl8cu4/K0xmXgqX
         HIQCCNmFxB+PQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6910EE21EEA;
        Sat, 11 Mar 2023 02:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Rework SFP A2 access conditionals
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167850121842.30210.4620240900776214071.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 02:20:18 +0000
References: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
In-Reply-To: <ZAoBnqGBnIZzLwpV@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 9 Mar 2023 15:56:14 +0000 you wrote:
> Hi,
> 
> This series reworks the SFP A2 (diagnostics and control) access so we
> don't end up testing a variable number of conditions in several places.
> 
> This also resolves a minor issue where we may have a module indicating
> that it is not SFF8472 compliant, doesn't implement A2, but fails to
> set the enhanced option byte to zero, leading to accesses to the A2
> page that fail.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: sfp: add A2h presence flag
    https://git.kernel.org/netdev/net-next/c/f94b9bed12e8
  - [net-next,2/2] net: sfp: only use soft polling if we have A2h access
    https://git.kernel.org/netdev/net-next/c/5daed426f012

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


