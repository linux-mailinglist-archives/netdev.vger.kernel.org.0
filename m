Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D7D3195F0
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbhBKWku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:40:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:43556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhBKWkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 17:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DD9564E3C;
        Thu, 11 Feb 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613083207;
        bh=6fZUm7dtsBE5JhkPLkHSkrfYGKer34yDoxt5eZqqWA4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vQVo61KtWujyf5PLTD12JkVggZjGrySc+ZUJfu0G+h0InmRSBNPjwl864YYdB11j+
         pADUpvGm+nmH/gYQvFDtlZnwC8cBmmWdpnnmztvc3zn5Ar0Jnffxkd0ECNd3Hbeilp
         t2djHCiJcgjCCMvzcs4QPXZkO7R5vQs3a+WS8yoZX0GlDmfnatOWqzBLFBFjkRNwZo
         VnC4+Df/AFXEnwISRBICcFvvXTbQ8WY4QPIy3XNfzqFSNnX9d+tFmkc7UJVUhvXOYU
         ANmkTW3lnL9gHayZU4Fi9se8+B5sLEdKUMhWzIATq9I0MVqoJi7ZXBdBgMtzWpf/is
         NhXxHkLlySt+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F00CA600E8;
        Thu, 11 Feb 2021 22:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] ibmvnic: Set to CLOSED state even on error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161308320697.12386.11818151811346372453.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 22:40:06 +0000
References: <20210211014144.881861-1-sukadev@linux.ibm.com>
In-Reply-To: <20210211014144.881861-1-sukadev@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, drt@linux.ibm.com, ljp@linux.ibm.com,
        ricklind@linux.ibm.com, abdhalee@in.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 10 Feb 2021 17:41:43 -0800 you wrote:
> If set_link_state() fails for any reason, we still cleanup the adapter
> state and cannot recover from a partial close anyway. So set the adapter
> to CLOSED state. That way if a new soft/hard reset is processed, the
> adapter will remain in the CLOSED state until the next ibmvnic_open().
> 
> Fixes: 01d9bd792d16 ("ibmvnic: Reorganize device close")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> 
> [...]

Here is the summary with links:
  - [1/1] ibmvnic: Set to CLOSED state even on error
    https://git.kernel.org/netdev/net/c/d4083d3c00f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


