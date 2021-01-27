Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7733065C0
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 22:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhA0VK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 16:10:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232246AbhA0VKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 16:10:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 32AC264DA1;
        Wed, 27 Jan 2021 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611781811;
        bh=xrBCpNJ6eb21yn73p5PBd0yA7KoTwV3NFDO2djz7Us0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IPKJQGfg9njE1l9msKhzGoC6DY/rifyalV23sZFGh6ikvr14E0nuEbiaY/BYh90Ck
         dJEc5eD6/2wvgxnza9B98ad2mMNQ6jl+Kb4bof9Ww1mJ9Bh8DFRFm3xcaXlDWigQn4
         f5zd3iaq6V0EfdKbpAL5F6rEOLn+metXhVg+YBDH3FGb324i9XLhN18xKi7tz9vnCn
         7F4ZtS0FbT1v4rsz/tg2BEyFI4HWEQjynbybzGFKwUFRNcqj0MlhMU/bUldAOxkVNY
         OFQgo4FNyvhiKqvwETCp3tqWuPPp5eZGROgyOL01uJ4ZrhGejPBihSFTmEk3IKlZ7X
         y6d5600J/kd+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2081D613AE;
        Wed, 27 Jan 2021 21:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161178181112.29925.10969160502449693741.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 21:10:11 +0000
References: <20210125214430.24079-1-pchaudhary@linkedin.com>
In-Reply-To: <20210125214430.24079-1-pchaudhary@linkedin.com>
To:     Praveen Chaudhary <praveen5582@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@gmail.com, zxu@linkedin.com,
        dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 13:44:30 -0800 you wrote:
> For IPv4, default route is learned via DHCPv4 and user is allowed to change
> metric using config etc/network/interfaces. But for IPv6, default route can
> be learned via RA, for which, currently a fixed metric value 1024 is used.
> 
> Ideally, user should be able to configure metric on default route for IPv6
> similar to IPv4. This fix adds sysctl for the same.
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/1] Allow user to set metric on default route learned via Router Advertisement.
    https://git.kernel.org/netdev/net-next/c/6b2e04bc240f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


