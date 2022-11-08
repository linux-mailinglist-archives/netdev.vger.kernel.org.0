Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CADD6207E8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 05:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232644AbiKHEAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 23:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiKHEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 23:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3425C63B5
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 20:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC0F461452
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BD0FC43140;
        Tue,  8 Nov 2022 04:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667880019;
        bh=DIfi2WmjHEJ3a4q5TRCKKj/OT8A05zPmaJhz/eO0Y+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tQ98lSygFm8dgwS3/uV6eRArEtMp+s52ZjRTEBsa78b+esaryOfNGMEYW547EaOv6
         VMNILnr2Q831VqSwPy/kehroHzbei0YlwXKwQ9W6PMAEr/9U3rCknk/Xp11Qzaa8LS
         qBclBuwKzaOzZkXGWqKuWvGJC+x6QkpVER37/BW05EJj93uVwXi7ZA5RzNNdNV+FSV
         XF5PkPj3lsIWcAP3Xpy58HfZH0RVWsCvRS1JSOlETgM2lOEtpgMec4xSq1WCH/xMf8
         cZjr7q/nag4Wa9ZYwTkgmCBIajifPIi5Wdk8/lhJnEsdq37JmJriItQVFyxwSigxlg
         Z9dy7tqbwuFYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0870CC4166D;
        Tue,  8 Nov 2022 04:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] Intel Wired LAN Driver Updates
 2022-11-04 (ixgbe, ixgbevf, igb)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166788001902.28960.4724643167535301112.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 04:00:19 +0000
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri,  4 Nov 2022 13:54:08 -0700 you wrote:
> This series contains updates to ixgbe, ixgbevf, and igb drivers.
> 
> Daniel Willenson adjusts descriptor buffer limits to be based on what
> hardware supports instead of using a generic, least common value for
> ixgbe.
> 
> Ani removes local variable for ixgbe, instead returning conditional result
> directly.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ixgbe: change MAX_RXD/MAX_TXD based on adapter type
    https://git.kernel.org/netdev/net-next/c/864f88884c42
  - [net-next,2/6] ixgbe: Remove local variable
    https://git.kernel.org/netdev/net-next/c/6a6f9e3e03ae
  - [net-next,3/6] ixgbe: Remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/f49fafa504d5
  - [net-next,4/6] ixgbevf: Add error messages on vlan error
    https://git.kernel.org/netdev/net-next/c/eac0b6804b74
  - [net-next,5/6] igb: Do not free q_vector unless new one was allocated
    https://git.kernel.org/netdev/net-next/c/0668716506ca
  - [net-next,6/6] igb: Proactively round up to kmalloc bucket size
    https://git.kernel.org/netdev/net-next/c/e9d696cb44e3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


