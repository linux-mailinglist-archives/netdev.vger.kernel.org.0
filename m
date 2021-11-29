Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FF74615EE
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 14:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377657AbhK2NP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 08:15:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49502 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377848AbhK2NN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 08:13:28 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6598B81132
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 13:10:09 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 5D8116056B;
        Mon, 29 Nov 2021 13:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638191408;
        bh=NxS8yiOT/q1e5xRQkpQ0wgH/zJuSCtbuB8IWj0mOPas=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kYEnWIe0Q3Y3AGreBP5jTraf3y7vxmUwWdtJliYxO59msFQ0+tQWMdcEWcVl1VV8a
         8ZrwXbhkGtmLsLT6GPHPhVbiWaD7dXIQinXx2MjXIIjL8907Y/DQCbYptzCx5yKF0X
         RdWq4l8iRMkpxltvBlGj8I6uI6gORlc0ZC5YcvnGu9/vAgjSeb7IRjAfCygBKLa3Dc
         YgG+OlO8Qqw41kMPcCTQqFgQTkowEVozcaoKWn1HwgmJJ7ZHVa0c7aSYtXbw1pRNZk
         io1immgqo0Q9tZ/N8GQBG4AHq3IlBtABWtekY+FSfqYgLx7n2W2yqScKp5OyW5zNJe
         WVSfHrEreKejQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4AEA860A45;
        Mon, 29 Nov 2021 13:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp: test: fix skb free in test device tx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819140830.10588.1175346940697159972.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:10:08 +0000
References: <20211129021652.3220400-1-jk@codeconstruct.com.au>
In-Reply-To: <20211129021652.3220400-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matt@codeconstruct.com.au, dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 10:16:52 +0800 you wrote:
> In our test device, we're currently freeing skbs in the transmit path
> with kfree(), rather than kfree_skb(). This change uses the correct
> kfree_skb() instead.
> 
> Fixes: ded21b722995 ("mctp: Add test utils")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
> 
> [...]

Here is the summary with links:
  - [net] mctp: test: fix skb free in test device tx
    https://git.kernel.org/netdev/net/c/d85195654470

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


