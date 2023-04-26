Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF05E6EF209
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 12:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbjDZKa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 06:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240468AbjDZKax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 06:30:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1410859C1
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 03:30:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99908618AF
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 10:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8645C4339B;
        Wed, 26 Apr 2023 10:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682505020;
        bh=f9TKJc9CwFmz/+xsWhLfC2LLjJiSBuMvOCsDqssZ2M0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q9JWJhR8VfTI/VKqXYBthA+wOHlMLue4aY20cwKiph97cyJ6NejFtZh2M3mzgEyJc
         GP0/qbQaLA2ArXRuIb6sp83ppR/WyQABwLQr886GvHTrmIih+MdSh/6TnxWi+dSYz9
         KR8Ce5VCiay8Hknu5N+B4IRuv2dPvrrw+oTyT4CBZ8uWsYxuKl7DzaAgGqzO+hbGit
         Yt3uQg0MQG4ZSPZjTFb9mmtOYbOETMl7oYdAwBruUwzASSh2Jj026oLDP6sU8fs4Qh
         zKuL5bRQqXpX60mZg7ABk1OIadPHsS5/Fvz67PU0LVOcPWzcKHKBduYicSOiQqB8pa
         GpXHqHalIJL0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC409E5FFC6;
        Wed, 26 Apr 2023 10:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: hide the PHYLIB_LEDS knob
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168250501983.24955.15265736768951875727.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Apr 2023 10:30:19 +0000
References: <d82489be8ed911c383c3447e9abf469995ccf39a.1682496488.git.pabeni@redhat.com>
In-Reply-To: <d82489be8ed911c383c3447e9abf469995ccf39a.1682496488.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, linux@armlinux.org.uk, hkallweit1@gmail.com,
        andrew@lunn.ch, arnd@arndb.de
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 26 Apr 2023 10:15:31 +0200 you wrote:
> commit 4bb7aac70b5d ("net: phy: fix circular LEDS_CLASS dependencies")
> solved a build failure, but introduces a new config knob with a default
> 'y' value: PHYLIB_LEDS.
> 
> The latter is against the current new config policy. The exception
> was raised to allow the user to catch bad configurations without led
> support.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: hide the PHYLIB_LEDS knob
    https://git.kernel.org/netdev/net-next/c/9b78d919632b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


