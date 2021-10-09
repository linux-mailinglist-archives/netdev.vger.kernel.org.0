Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2472742794F
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 13:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244574AbhJILCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 07:02:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232752AbhJILCF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 07:02:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 848F760F9C;
        Sat,  9 Oct 2021 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633777208;
        bh=/nDC62uXRzGeibcJ/PTWXinhXvVXEwJkp5rrVLcEQkY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ngFocYpTStbEJPo27xr+UuEvR+J2fll03TwH6rOHdQIV1RBYbJhMYcTf2VP6tV96+
         Zao7LA4SPFsRrOoT3IMu/0p4S+Qvsd524oEzmBoV07fHXH309e1wSVhhL/9mGuWafQ
         raq8946ZBoRt6f8GPno/v7jkK9DDvGWNX8BUf7ytWfLHTQ7ss09wbsxuyz4ShqKU5V
         SE4AHDA7BIuTFsEWEyz4Lo7rR9QsYWIq3hK36zzqhHsk2uT3Kak2Sm6u3cyFRyJiHI
         ZLzNJiY7IxnMSlWlPbBn+UP/A0juMldT5IUzZo3Bqp0a+AAosbE8PKDVbECyNPcPAv
         RSxJJn4ghwlXA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7A98060985;
        Sat,  9 Oct 2021 11:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net: remove direct netdev->dev_addr writes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163377720849.21740.224949011888662927.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 11:00:08 +0000
References: <20211008175913.3754184-1-kuba@kernel.org>
In-Reply-To: <20211008175913.3754184-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Oct 2021 10:59:08 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> This series contains top 5 conversions in terms of LoC required
> to bring the driver into compliance.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ethernet: forcedeth: remove direct netdev->dev_addr writes
    https://git.kernel.org/netdev/net-next/c/2b37367065c7
  - [net-next,2/5] ethernet: tg3: remove direct netdev->dev_addr writes
    https://git.kernel.org/netdev/net-next/c/a04436b27a93
  - [net-next,3/5] ethernet: tulip: remove direct netdev->dev_addr writes
    https://git.kernel.org/netdev/net-next/c/ca8793175564
  - [net-next,4/5] ethernet: sun: remove direct netdev->dev_addr writes
    https://git.kernel.org/netdev/net-next/c/a7639279c93c
  - [net-next,5/5] ethernet: 8390: remove direct netdev->dev_addr writes
    https://git.kernel.org/netdev/net-next/c/8ce218b6e58a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


