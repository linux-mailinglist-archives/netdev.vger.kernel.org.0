Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5BA3093D8
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhA3J70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:59:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhA3J7D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 04:59:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5032164E1F;
        Sat, 30 Jan 2021 07:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611992406;
        bh=LZLvLOH1OqajmsgdyXWMzDhsmcrobdTECgChF56o8P8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jhjSQvKUeBnR+O6bD6/spxeQnE7wwO+TF8oqPsNjOjZ1lj1qMlzLyy7ZouGNHQk59
         RoLX58i7pdaD6MaVMDK4Z4KIfcl21heqTIIjSTLfPmYMqevnrrU/N2DihTDY0FtUBI
         9oRjr+vcRVoH3mOVRQF7Lf43nnxRIOsDLnMzpb2J3YxhAX3YUTvQ88SMASWfNsQAzN
         dyzF93h7Z6YvprsHKfZ3FYilJNopVvqk4qd0GycHJCEGGxSjanaP2cZtsQHxpbI5JQ
         ZNjBAQMkDGwLvZ/Ftgevf4olrDHU/j1Z/KRrHxAaax2ohALSed4Zx3rOeK/oAAgMPo
         g9+tCglbtlF8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 43CD36095D;
        Sat, 30 Jan 2021 07:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: shrink inet_connection_sock icsk_mtup enabled
 and probe_size
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161199240627.6969.14160359917809425150.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 07:40:06 +0000
References: <20210129185438.1813237-1-ncardwell.kernel@gmail.com>
In-Reply-To: <20210129185438.1813237-1-ncardwell.kernel@gmail.com>
To:     Neal Cardwell <ncardwell.kernel@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ncardwell@google.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 29 Jan 2021 13:54:38 -0500 you wrote:
> From: Neal Cardwell <ncardwell@google.com>
> 
> This commit shrinks inet_connection_sock by 4 bytes, by shrinking
> icsk_mtup.enabled from 32 bits to 1 bit, and shrinking
> icsk_mtup.probe_size from s32 to an unsuigned 31 bit field.
> 
> This is to save space to compensate for the recent introduction of a
> new u32 in inet_connection_sock, icsk_probes_tstamp, in the recent bug
> fix commit 9d9b1ee0b2d1 ("tcp: fix TCP_USER_TIMEOUT with zero window").
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: shrink inet_connection_sock icsk_mtup enabled and probe_size
    https://git.kernel.org/netdev/net-next/c/14e8e0f60088

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


