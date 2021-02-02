Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9D930B55E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhBBCkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231156AbhBBCkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C7C0764ED9;
        Tue,  2 Feb 2021 02:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612233606;
        bh=C9Rk8M1v+1F9LiLYhT4qN1OaOU4OLLwTsAevDdKIzlE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HS/mfsQhz1tRbPKYll6mM35TNwiLn9y7Vhtobfe0CLEczcfhxmHQ4/hvp7Zg1Crn6
         EymqUAUtYVwrcPwW4E151I0RrL4vbR3j9H18UKIbCzpePFXlp0vCrk3GKgfZupxlNu
         skVSMl7KwH7tPSWMChsMkF5jcgcmqXgl0neKoCa+dGXcHS7b/6KZWkzvsFnmUdS0hh
         sXPNL4xROaTjsjcBxUohIDXQ/JVE5E19iHKHcm1UWnu7AYJLdVNDXIOiQYon/X6yTO
         qcA3589oV/euj9JYyz++wgvJVuUdyejvLBeAL6qVn+NcEKurmoasFvt6FwiuBWSKVa
         36MDQt1z8gfMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C178E609D0;
        Tue,  2 Feb 2021 02:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: dsa: hellcreek: Report tables sizes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161223360678.28374.6348724450041467252.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 02:40:06 +0000
References: <20210130135934.22870-1-kurt@kmk-computers.de>
In-Reply-To: <20210130135934.22870-1-kurt@kmk-computers.de>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 30 Jan 2021 14:59:32 +0100 you wrote:
> Hi,
> 
> Florian, Andrew and Vladimir suggested at some point to use devlink for
> reporting tables, features and debugging counters instead of using debugfs and
> printk.
> 
> So, start by reporting the VLAN and FDB table sizes.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: hellcreek: Report VLAN table occupancy
    https://git.kernel.org/netdev/net-next/c/7f976d5cf16d
  - [net-next,2/2] net: dsa: hellcreek: Report FDB table occupancy
    https://git.kernel.org/netdev/net-next/c/8486e83fe1d8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


