Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0194933A837
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 22:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhCNVaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 17:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231892AbhCNVaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Mar 2021 17:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5873964EBE;
        Sun, 14 Mar 2021 21:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615757408;
        bh=6H1W30iTvnHOxf0xBfw4KkiMVgn2+V69afgqpAjoi24=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZD7xLYQjuqlWFr7muC94G2tz8DIjK5lYXnrVo+zqRi8xnzMYHTZHf2lFQ6hl6/YBA
         fEE1KuLwuMcN83rR7W00YZymY3UDQBobGBgrn+I7YD2xIgFVyUvUqOS1qBjzNRfukm
         kOqtW6PTJX1WrptqSKH/eCFfaNYnUqa6WlcnF7YzSd9IT5tA59j1Op+r0jbWyJmMtK
         Jb9Et2U9NsKEe+tJLVIr8dWA8i15RM7EHqYlpAkA4GH60w+3MQ5PywKJGhHjCS8BR4
         yLUfxRPihQnkBuY0t1vTw+LCjvfYkUO+Xr1/ZEuBuvmrMVZ1G6ZRdC1VjHwLZKd6Be
         4akO/DKXlG2+g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53C3560A4C;
        Sun, 14 Mar 2021 21:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] pktgen: scripts improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161575740833.7685.12271899538939781479.git-patchwork-notify@kernel.org>
Date:   Sun, 14 Mar 2021 21:30:08 +0000
References: <20210311103253.14676-1-irusskikh@marvell.com>
In-Reply-To: <20210311103253.14676-1-irusskikh@marvell.com>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     netdev@vger.kernel.org, brouer@redhat.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 11:32:51 +0100 you wrote:
> Hello netdev community,
> 
> Please consider small improvements to pktgen scripts we use in our environment.
> 
> Adding delay parameter through command line,
> Adding new -a (append) parameter to make flex runs
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] samples: pktgen: allow to specify delay parameter via new opt
    https://git.kernel.org/netdev/net-next/c/ef700f2ea27e
  - [v3,net-next,2/2] samples: pktgen: new append mode
    https://git.kernel.org/netdev/net-next/c/c8fd4852022c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


