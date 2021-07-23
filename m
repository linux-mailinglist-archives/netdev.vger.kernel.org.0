Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091893D3D6D
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 18:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbhGWPjf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:39:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:57934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229806AbhGWPjd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 11:39:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EF44860EB5;
        Fri, 23 Jul 2021 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627057205;
        bh=csGe7IytM8+iig+A6Mp9h4m8TjS3VvgsNP5tFCneniQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NdSibZv0wAUIqEe0z8oee8lL3aTpezqAjnB3MqosACpg+sCfMcAhUB9dxJm16JiP2
         7F/WH4ysMKBk2PBAyPPOrsWV350hezQAAvwzOREWrLITaVYRkisaTwT1QilOSMl4S0
         OBiby7z7Yioj8xp7VHHdGTJrBugJ3WzE7FnmbIOzIe5DLv2oYK0zR0hWN9S1z/FlJx
         TPx6wZQIK6P5GGj0Dyl4I6EjPlZSP+w4p9+bR0XGjnL+K6fi6/EaJMiI/ySWDl7bpY
         70Lkf6sDQ36lVxmXckxFmmbEhsLFvRjiPJAL2cfcCFFoWFHPhRHpxcd6wuNvTAsO7M
         81W7RIl6d+mvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E106C60972;
        Fri, 23 Jul 2021 16:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] wwan: core: Fix missing RTM_NEWLINK event for default link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705720491.6547.6032744672093345201.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:20:04 +0000
References: <1626978065-5239-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1626978065-5239-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, johannes@sipsolutions.net,
        netdev@vger.kernel.org, ryazanov.s.a@gmail.com,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Jul 2021 20:21:05 +0200 you wrote:
> A wwan link created via the wwan_create_default_link procedure is
> never notified to the user (RTM_NEWLINK), causing issues with user
> tools relying on such event to track network links (NetworkManager).
> 
> This is because the procedure misses a call to rtnl_configure_link(),
> which sets the link as initialized and notifies the new link (cf
> proper usage in __rtnl_newlink()).
> 
> [...]

Here is the summary with links:
  - wwan: core: Fix missing RTM_NEWLINK event for default link
    https://git.kernel.org/netdev/net/c/68d1f1d4af18

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


