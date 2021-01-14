Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EC92F6AFD
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 20:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729807AbhANTat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 14:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbhANTat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 14:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7E5CA23B53;
        Thu, 14 Jan 2021 19:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610652608;
        bh=TH1mxZsDlCVBPT4edqUOe3FAaIwuq4ub+TLd2Yb5RyE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pajiX7nPFuXMXjqfQvTodQRVcbYaCuW132eqIAEhHY4vk97C4nJ4pRb+uJK9WN3lq
         Uv0F3qV/x0l0U5ccuqImMp0WIp5MGMLTI71AFm+PPtKSqFejeMVuLMVABsUm/xjCll
         dlzZ+mwcvh2X8/JJF1RfnJ9xWPyafNC4CwgMSjbsSqXKMebIy4vpRYXJmSoWCjpeY6
         wsvSVbh/Q7yET1NABwYWmHSEZE2Alj96CrDm9gQwyz4/1QIvUGiBjNJYQ76mZEJ0MW
         QoZ8cyp5Ca8GiRmdyP9IPsnwoRCSCz40RMfXyHfbvsygY0MYyO8+IbdURgI2KOCME0
         SMguutVGpWmqQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 6F601605AB;
        Thu, 14 Jan 2021 19:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mptcp: fix locking in mptcp_disconnect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161065260845.1502.10098958825377599450.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 19:30:08 +0000
References: <f818e82b58a556feeb71dcccc8bf1c87aafc6175.1610638176.git.pabeni@redhat.com>
In-Reply-To: <f818e82b58a556feeb71dcccc8bf1c87aafc6175.1610638176.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org, davem@davemloft.net,
        kuba@kernel.org, eric.dumazet@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 14 Jan 2021 16:37:37 +0100 you wrote:
> tcp_disconnect() expects the caller acquires the sock lock,
> but mptcp_disconnect() is not doing that. Add the missing
> required lock.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: 76e2a55d1625 ("mptcp: better msk-level shutdown.")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] mptcp: fix locking in mptcp_disconnect()
    https://git.kernel.org/netdev/net/c/13a9499e8333

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


