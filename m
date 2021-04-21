Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1469367155
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244671AbhDURan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:49212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242278AbhDURam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EFEC66145B;
        Wed, 21 Apr 2021 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619026209;
        bh=J8xoYl+0RbPoz5BZ3TkAvRepbtb0Z1k09twUtzQx6BI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O39OhVzRiMhMW5Zi45/0ohBg9ssf911IjqOv9D77rgIAIDXfwaP5G063PRyk5Yf6X
         WaNCJpS388idbYrtuC9BJEXrBQBBbkzHBc8qqjrY/KtZibOG54kXHT9FPEg/wf6XHw
         szwuFmNEla30bIjpDiS3wX+6uixc8SEbEpzNVziFwzVY2ez6c59DRpv5Fbg1ABBSAw
         EzLgqa+DmaCscALZpoMKONegBqxGOB37SonYJePCKUoUCT0a1VNjfdp5vTabCPn7Af
         aO2RevnZnQrp/Qws3pseFfRAO66mZ1FVmnW6l89KahqlhRI+y8+AxE/huvAa5N1phx
         FhD71J1NUhiNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E35E760A52;
        Wed, 21 Apr 2021 17:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: devlink: initialize the devlink port attribute
 "lanes"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902620892.9844.3758040141120463484.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 17:30:08 +0000
References: <20210421092415.13094-1-simon.horman@netronome.com>
In-Reply-To: <20210421092415.13094-1-simon.horman@netronome.com>
To:     Simon Horman <simon.horman@netronome.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, yinjun.zhang@corigine.com,
        louis.peens@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 21 Apr 2021 11:24:15 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> The number of lanes of devlink port should be correctly initialized
> when registering the port, so that the input check when running
> "devlink port split <port> count <N>" can pass.
> 
> Fixes: a21cf0a8330b ("devlink: Add a new devlink port lanes attribute and pass to netlink")
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@netronome.com>
> 
> [...]

Here is the summary with links:
  - [net] nfp: devlink: initialize the devlink port attribute "lanes"
    https://git.kernel.org/netdev/net/c/90b669d65d99

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


