Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896C0439981
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhJYPCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:02:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233735AbhJYPC3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:02:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 51CE760C4A;
        Mon, 25 Oct 2021 15:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635174007;
        bh=jltO1ZRca/MzUhHVewxXsE2f/GgLRHI8yZ28Q0AD/qc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Aq30FBVMNa1tXKz3s3AhM7WGPdPy2gmIW6ODxdKXaDgUmxR6RKcFUdlEzUkutD9uK
         0Wc8p+uB665up7mhw5diCMj9jF7trURTDH+GLh9uVUIYWR3mq5lnMQe/IyBpr6BkP8
         MfaEwlK5O420fWVDRbMfdQmc7gKbQtsTYHxdDEETqYzrHz3Y+GTBPxOOkcY+yIiL6a
         ZUh0RhpWJlZnsCbNyrl+wlyPGUtWCHcJWNqtTBs03NZOel2cBbhYb6mUJyLgI2NCEr
         zUjXD/5kXQxojPYjx7t+CwWGusNz68A3W0d8ucvXReoRGUldiGo57FtNh3j055Y1F1
         cJwNnOMXnUoDQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 44B0260A90;
        Mon, 25 Oct 2021 15:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: Prevent infinite while loop in skb_tx_hash()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517400727.18146.17098840029288266871.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 15:00:07 +0000
References: <1635152728-28535-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1635152728-28535-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 05:05:28 -0400 you wrote:
> Drivers call netdev_set_num_tc() and then netdev_set_tc_queue()
> to set the queue count and offset for each TC.  So the queue count
> and offset for the TCs may be zero for a short period after dev->num_tc
> has been set.  If a TX packet is being transmitted at this time in the
> code path netdev_pick_tx() -> skb_tx_hash(), skb_tx_hash() may see
> nonzero dev->num_tc but zero qcount for the TC.  The while loop that
> keeps looping while hash >= qcount will not end.
> 
> [...]

Here is the summary with links:
  - [net] net: Prevent infinite while loop in skb_tx_hash()
    https://git.kernel.org/netdev/net/c/0c57eeecc559

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


