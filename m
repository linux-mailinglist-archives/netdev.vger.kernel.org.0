Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03703A1E70
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhFIVB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229536AbhFIVB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:01:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4445C613EA;
        Wed,  9 Jun 2021 21:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623272403;
        bh=QMk0TKjCMSiEUzdC+7QqtuO8VTviXQgiyJnAC8fJJW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t+R7qjk3u9aD7wPDuokHEKyX6Zs0BLi6NYuAN41rFcaSMAIDNXcnFj+JmynOa5JLX
         6jNtPKkiXgyx0jwyCqKdyA9HZaFfdG9wn4gbIt/kzFLUHMZpxjfucJ755JGhXaYZW7
         ZxtPhnP6GAjWKK4JBxXwhRuub5N8tduWO+bY9ho1tBK3P4pe2QvlNSVps3bTZ7/OXO
         38ag02vJIudqW3BP0hNzYA92IlVV4YCw3mUbUQRhecJv9e5jfdl7uHFypaVXCTaXUO
         r/iuLVp6riO0OGXb0KteGIANHxjN4puXGC0ny5qQ4nmzN0hbEaduNiXoMhQpAdj4K7
         V4v8TovSaZO6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37FEA60A0C;
        Wed,  9 Jun 2021 21:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethtool: clear heap allocations for ethtool function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327240322.12172.2837709394568742903.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:00:03 +0000
References: <20210609023425.GA2024@raspberrypi>
In-Reply-To: <20210609023425.GA2024@raspberrypi>
To:     Austin Kim <austindh.kim@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        andrew@lunn.ch, bjorn@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, austin.kim@lge.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 9 Jun 2021 03:34:25 +0100 you wrote:
> Several ethtool functions leave heap uncleared (potentially) by
> drivers. This will leave the unused portion of heap unchanged and
> might copy the full contents back to userspace.
> 
> Signed-off-by: Austin Kim <austindh.kim@gmail.com>
> ---
>  net/ethtool/ioctl.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Here is the summary with links:
  - net: ethtool: clear heap allocations for ethtool function
    https://git.kernel.org/netdev/net/c/80ec82e3d2c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


