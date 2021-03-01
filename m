Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F424329390
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 22:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244256AbhCAV0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 16:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:41266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237196AbhCAVVJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 16:21:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 659EC600CC;
        Mon,  1 Mar 2021 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614633607;
        bh=R802yzk77LcuEq868nLAfZXeewiEIXjseqQ4aUbpyEo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EUjMe+mFf+oC4srgEEW9lXYZdNtEI4c0RJgXX2xz7x9jToxhg7MNXqFRzKnGCpAwb
         TFR/Smx/z9dQ/L4JQVsOXl/O4hygnE2cmkJ3UvO6sh1hcKcv0wMygAlS2T/Zi62bWh
         jEa4t904x42YYB6/AQ0c76Q6NPbhguL78QUKMTCfGmdSwG98W/jedSUeCp2LYNxhWk
         bQwAWfuA08cU5ubLwsLshoa9nCcqhl3SG+xEwDQ9VZmt6TJ5fUatPpfLTDmXd6dcyp
         yknRevElAFlrXncb/17Ae6syyfGZDu4xrbaW8M1ZtyLh+ltsR1GCtKPTAFwMngR9Fq
         Vr7EKx+5/pvzA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B9E960C25;
        Mon,  1 Mar 2021 21:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] atm: eni: dont release is never initialized
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161463360737.8865.18082066320461407132.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 21:20:07 +0000
References: <20210227211506.314125-1-ztong0001@gmail.com>
In-Reply-To: <20210227211506.314125-1-ztong0001@gmail.com>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 27 Feb 2021 16:15:06 -0500 you wrote:
> label err_eni_release is reachable when eni_start() fail.
> In eni_start() it calls dev->phy->start() in the last step, if start()
> fail we don't need to call phy->stop(), if start() is never called, we
> neither need to call phy->stop(), otherwise null-ptr-deref will happen.
> 
> In order to fix this issue, don't call phy->stop() in label err_eni_release
> 
> [...]

Here is the summary with links:
  - atm: eni: dont release is never initialized
    https://git.kernel.org/netdev/net/c/4deb550bc3b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


