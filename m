Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1423F1833
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 13:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238827AbhHSLas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:30:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:56992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231210AbhHSLam (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 07:30:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 697086112D;
        Thu, 19 Aug 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629372606;
        bh=17wKMzpTJm8LQMdNHLC576XPex8i1YtyzTW/DkD/Ufw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T12ZcHsByQ5mkU6H7qY2/Lrnl92BKXOCT65WLYRGjCp3yZuuXD5p5hXG6bJFVBupS
         kRF/+Q7Vb4RP1Nhui7qR8InC4Li1HNZ+mmFp8KnjiCk5qPN1kHM0/jWptQcJtAQ4+5
         uqMQWsGMNOxDzg/ulDUv8xpxbVnyO3zHS7V6FRAPpm7tgW59HAPygW5W3BqO91ijo8
         Qx5fcrWPq0t4QpNqn/B88Ex6yi1ollVAHNRVh1r4p0sNtl6OLRtgSAyV4DkZFTevNS
         wh2lVfd1MCQoA5Yzlm8vCA8gfwmto5b16ay96i6mLVsS+F9KMrNP2Ii6w5JKcoTPO8
         IrkNDZOGrlEuA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D43360997;
        Thu, 19 Aug 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162937260637.19400.6695723799989015439.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 11:30:06 +0000
References: <20210818234237.242266-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20210818234237.242266-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        geliangtang@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 18 Aug 2021 16:42:35 -0700 you wrote:
> Here are two bug fixes for the net tree:
> 
> Patch 1 fixes a memory leak that could be encountered when clearing the
> list of advertised MPTCP addresses.
> 
> Patch 2 fixes a protocol issue early in an MPTCP connection, to ensure
> both peers correctly understand that the full MPTCP connection handshake
> has completed even when the server side quickly sends an ADD_ADDR
> option.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: fix memory leak on address flush
    https://git.kernel.org/netdev/net/c/a0eea5f10eeb
  - [net,2/2] mptcp: full fully established support after ADD_ADDR
    https://git.kernel.org/netdev/net/c/67b12f792d5e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


