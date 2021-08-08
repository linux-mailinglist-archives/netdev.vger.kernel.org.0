Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FD33E3C99
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 22:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhHHUAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 16:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:38876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229977AbhHHUAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 16:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D41CB60F25;
        Sun,  8 Aug 2021 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628452805;
        bh=avv7/tOkUh2iyOaTAPl1E2HFkHjRoBP5tCyefO0kTXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A841M6cVb8Vy1xnwChgRL+DYyS9lHxF/jz95wLvFeTHW+iWxneuX+soOYnMChQazf
         LdEYSQEx+KaXXScAX1UdA/MX5xzcNWzJlCWx0HKx4eEWEFPLk0yG8gg4ZJjPw9gIQL
         gq3ve+Xjhsf9wo0Eyx3zE0PvN2qRvgiH3NYRzUx6wwbrkeMe1L2vkH5EDbx2UQxXUA
         B2xN7m2IUgCGY/2Hpjl6g9E7jeGaKbxOLbQd+abBMRy8L/UxIlpOpVbrQ7cOgppJTe
         /cMUmQW5fF7Q+hFJp6mMjsUXrMbwc8aLoatnpDXrlzZNQ+XZk2fHDJegvomdAEd3nt
         OCWD/KmdVlfZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C148060726;
        Sun,  8 Aug 2021 20:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Fast ageing support for SJA1105 DSA driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162845280578.6085.1916652625687670762.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 20:00:05 +0000
References: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210808143527.4041242-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, dqfext@gmail.com, tobias@waldekranz.com,
        wintera@linux.ibm.com, jwi@linux.ibm.com, roopa@nvidia.com,
        nikolay@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun,  8 Aug 2021 17:35:22 +0300 you wrote:
> While adding support for flushing dynamically learned FDB entries in the
> sja1105 driver, I noticed a few things that could be improved in DSA.
> Most notably, drivers could omit a fast age when address learning is
> turned off, which might mean that ports leaving a bridge and becoming
> standalone could still have FDB entries pointing towards them. Secondly,
> when DSA fast ages a port after the 'learning' flag has been turned off,
> the software bridge still has the dynamically learned 'master' FDB
> entries installed, and those should be deleted too.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net: dsa: centralize fast ageing when address learning is turned off
    https://git.kernel.org/netdev/net-next/c/045c45d1f598
  - [net-next,2/5] net: dsa: don't fast age bridge ports with learning turned off
    https://git.kernel.org/netdev/net-next/c/4eab90d9737b
  - [net-next,3/5] net: dsa: flush the dynamic FDB of the software bridge when fast ageing a port
    https://git.kernel.org/netdev/net-next/c/9264e4ad2611
  - [net-next,4/5] net: dsa: sja1105: rely on DSA core tracking of port learning state
    https://git.kernel.org/netdev/net-next/c/5313a37b881e
  - [net-next,5/5] net: dsa: sja1105: add FDB fast ageing support
    https://git.kernel.org/netdev/net-next/c/5126ec72a094

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


