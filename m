Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E5440117C
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 22:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbhIEUVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 16:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235511AbhIEUVK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Sep 2021 16:21:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 33F7760F4A;
        Sun,  5 Sep 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630873206;
        bh=WKktLO+yQdXN330+BZH5Hil9Wfw0x/OASmimmQQ0upc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kUxYfUjrG7/MC0k/FOLIdRy5iSoMv2vgt1foyL2tMXuVjJdDd9/4hSQtyWL8ieQV2
         BmndLHxdO3IWFK5lwr1H/8arqDYTn4/DkDpJLhKHMw898EwJVbBkhj6iG/Ada/eDjw
         gg3bLmCEPDs3J/bfT/w6Z81YUlebIig7GUHi6yigZghop6Itn7AuB3dg1ebOJ32xyU
         4lVZWCKfLJKOM0SfyUhKfrkuQJDumO2VeB7sIsP46Db0dYMKQ3CiiRygw4OcjuuDX8
         plfyzJB4f+ONARvS1cZV0O4+vnsVx5RjWGeYzb06SbIpJ0rG/9cwVB7IRn7lcZSXov
         1NKx8F3QTAgXQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23DDE60A49;
        Sun,  5 Sep 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: create netdev->dev_addr assignment helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163087320614.11075.664771534016815348.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Sep 2021 20:20:06 +0000
References: <20210902181037.1958358-1-kuba@kernel.org>
In-Reply-To: <20210902181037.1958358-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gnaaman@drivenets.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 11:10:37 -0700 you wrote:
> Recent work on converting address list to a tree made it obvious
> we need an abstraction around writing netdev->dev_addr. Without
> such abstraction updating the main device address is invisible
> to the core.
> 
> Introduce a number of helpers which for now just wrap memcpy()
> but in the future can make necessary changes to the address
> tree.
> 
> [...]

Here is the summary with links:
  - [net] net: create netdev->dev_addr assignment helpers
    https://git.kernel.org/netdev/net/c/48eab831ae8b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


