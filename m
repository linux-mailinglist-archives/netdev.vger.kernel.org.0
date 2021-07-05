Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A553BC234
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 19:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhGERWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 13:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229740AbhGERWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 13:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D862E61978;
        Mon,  5 Jul 2021 17:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625505603;
        bh=anUSeEDIvNhf9sEVGt07LsmhXec2cVx0PtForCQgtNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zh6eoxSwjxcNS89OioXqP4dnlM+6ooNs0QZl8hdITIasqZqKwYPvafvI0YGQLXj7U
         nT5ZPqGPO8UeYMH+crSHQACCGJnGMz2oDq+AAgQNKYZkQSPWyi6ZQZNRmYo5oOhm2y
         c0zuARebL2n4g0dfNXU5WBMMTKzY40tjhTgn6c5dt1iu7GEvRzjnPeB3PNeato6g6l
         YqAnyTgF6l4B5xHKM5EhuBlP93UN91sn7y9xUQahpoo/eyDdf/o/BNA9m1FgqIEaaP
         T3MzHs3hP6xn/HsjE9tpfz4mKAXQt/NjY3XCpfkD/XukQqgR+49JyKGYE+/sbTZNO8
         9Wr1USExRXGfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C9ED460C09;
        Mon,  5 Jul 2021 17:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] ptp: fix format string mismatch in ptp_sysfs.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162550560382.14411.5424093181028751243.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Jul 2021 17:20:03 +0000
References: <20210705094617.15470-1-yangbo.lu@nxp.com>
In-Reply-To: <20210705094617.15470-1-yangbo.lu@nxp.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, davem@davemloft.net, rui.sousa@nxp.com,
        sebastien.laveze@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  5 Jul 2021 17:46:17 +0800 you wrote:
> Fix format string mismatch in ptp_sysfs.c. Use %u for unsigned int.
> 
> Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/ptp/ptp_sysfs.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net] ptp: fix format string mismatch in ptp_sysfs.c
    https://git.kernel.org/netdev/net/c/f6a175cfcc8d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


