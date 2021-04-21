Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6F1366304
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234584AbhDUAUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:20:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233863AbhDUAUl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:20:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3066A6141D;
        Wed, 21 Apr 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618964409;
        bh=CBS+7ZTTGolbHR9peBBkXpNe+gNYcg+255rKd1TxBAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VDaHVke0NSXAeUFEA5zR+q5U4wLA5lYhQBXlMx0VlExoDY4CH6dK2E4UE58ljq+YZ
         +wISKngOkPluLE7bq1gp/KifHz1uKjpQGjH9/sj2p28T6aXTGCy17c9dR5J/A0It6j
         lfkKMSpbG5lhu5LI7zh3GgjKxglaW4qTOH0zqbKbaSSU68G7OCxu/I1Z8405Fk2s6h
         ASkknvzmJnrgpjL/DovdNFfO+NVFqE1BQnechoG7WF/Il9fnZom7+xLbGo2ikyh5J2
         hz6Re+mJ6hc8YwrGpYku8fxJEI+m9gQeMYE0dXBy1jcguhEtUCwd3D5BaN9x9lq31A
         IYQ5P9W+cU14g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 25CEE60A3C;
        Wed, 21 Apr 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: marvell: prestera: fix port event handling on init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896440915.12176.13162412548867183608.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:20:09 +0000
References: <20210420133151.28472-1-vadym.kochan@plvision.eu>
In-Reply-To: <20210420133151.28472-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        tchornyi@marvell.com, linux-kernel@vger.kernel.org,
        mickeyr@marvell.com, vkochan@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 20 Apr 2021 16:31:51 +0300 you wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> For some reason there might be a crash during ports creation if port
> events are handling at the same time  because fw may send initial
> port event with down state.
> 
> The crash points to cancel_delayed_work() which is called when port went
> is down.  Currently I did not find out the real cause of the issue, so
> fixed it by cancel port stats work only if previous port's state was up
> & runnig.
> 
> [...]

Here is the summary with links:
  - [net] net: marvell: prestera: fix port event handling on init
    https://git.kernel.org/netdev/net/c/333980481b99

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


