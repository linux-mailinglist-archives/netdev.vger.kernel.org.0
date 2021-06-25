Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DD33B4911
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 21:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhFYTCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 15:02:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229759AbhFYTCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 15:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4EE861960;
        Fri, 25 Jun 2021 19:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624647610;
        bh=4bx5P918C+2n24hESgkhLgfn1hqIqIb900POO/Jamws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NTkBUmZofPJcHO8TCaiZtkGWqUqyXlUq9+6HCuRXSc3eYq9v6ppgwfYWllXjesL97
         EQXJHqeBZK2tA3dggXj3IUulitwO1v6B05LRSJGV3FLiRvgLDeu6H1LzhcE+Yw3xpF
         fsGpy9Fer76uEonlIT818jQ8CHpTUixiuKadK98sL9IW7ArJpnsPUx5RO88WlCP3XN
         Fvp9IlpDsJ9T8mBvsX4PVua+Yt61Yl2DbNu32rWAXtur4URgA2343X/WIl4q23ut/n
         WEVkijFSBdBVzis78f64cQKKT2v6vnV229b33XjUYUveAo3q7X5stl0P4zQQuoulI8
         l5aU1SFsZJeMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A948C60A53;
        Fri, 25 Jun 2021 19:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-next-2021-06-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162464761068.5473.10028410822181008168.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Jun 2021 19:00:10 +0000
References: <20210625121705.57905C433F1@smtp.codeaurora.org>
In-Reply-To: <20210625121705.57905C433F1@smtp.codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Fri, 25 Jun 2021 12:17:05 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-next-2021-06-25
    https://git.kernel.org/netdev/net-next/c/4e3db44a242a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


