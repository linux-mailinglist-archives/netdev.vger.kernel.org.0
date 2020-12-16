Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CE32DC7F0
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbgLPUur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:50:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729080AbgLPUur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 15:50:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608151807;
        bh=QZQASWBHGfp3xdiQo3mYhkxmcUOEAnMaQEJ31y87Lz0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PLAwVuBGr3yTqr09qLQJDJQT07E+r2NF3TErn2JUqvZ21rV5zWpmQ4eMOZ5MwE2sa
         ok/i3D0D+6DyBTk94tM0f/KngVYZuCBBrwtIozTBkqH2JEeq1+5ttto01Ee1iVrHQZ
         ksjJR+LqpF1b3I2BYyg/Pric197S5NIlrB1bpJtGL0OQpEh1mw9s3OO7X6pVKU9mIU
         VBCo5yh2y/ybv5ZUvyLw9FFMOfVY9hCoOK85TYTutYUZVqs5a3f52wXaHcNmQFdNW6
         tW+NAScF9NtIy+RCNZEA1cq1zv0OVjYg3d0RipScr7xK7inQb9NEHrCt/5d4C6Wdox
         GlnckA6XAGI1Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] lockless version of netdev_notify_peers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160815180705.15275.8603006444464735195.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 20:50:07 +0000
References: <20201214211930.80778-1-ljp@linux.ibm.com>
In-Reply-To: <20201214211930.80778-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 14 Dec 2020 15:19:27 -0600 you wrote:
> This series introduce the lockless version of netdev_notify_peers
> and then apply it to the relevant drivers.
> 
> In v1, a more appropriate name __netdev_notify_peers is used;
> netdev_notify_peers is converted to call the new helper.
> In v2, patch 3 calls the new helper where notify variable used
> to be set true.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net: core: introduce __netdev_notify_peers
    https://git.kernel.org/netdev/net/c/7061eb8cfa90
  - [net-next,v2,2/3] use __netdev_notify_peers in ibmvnic
    https://git.kernel.org/netdev/net/c/6be4666221ca
  - [net-next,v2,3/3] use __netdev_notify_peers in hyperv
    https://git.kernel.org/netdev/net/c/935d8a0a43e3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


