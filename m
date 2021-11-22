Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A9E4590B9
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239845AbhKVPDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239827AbhKVPDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 10:03:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BD1A060F4F;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637593209;
        bh=OUpLZtjY8kNT23P/QJBYo8Kmqis2Y0vaMryHUFSittw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NzXjWlTWS+D3k+5XsqdHlLXNL5XQT/BGnTrQthwG4noF4QCzXcRVCGiEM8kliWbQb
         +N0B9du4BurSdAqphhqQyxo+oHmk0/jzsc6zraNkcC+ludDcbgjYrYv2yoPQwVHzlt
         +QU6axWEEGQPJCSkdmlW3Re5r9PKevIYTAwSI86+87/aLg+JNbQ2AtaslPPZT1qAYU
         0X0qy5+YvxXeBZhX5PHX0leP5ugp7sykDQN5pHbQpnTAzRCa6+e2ACRBMbcg9xQDJM
         Y4WSQge5ORwIIRcaUWZ1dHgzJ1CrH21pVCdAHjKwfqctg/QYeMNaNddxjReNTbD4zF
         II6OeC1C1NaLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B7B6A609B9;
        Mon, 22 Nov 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] arp: Remove #ifdef CONFIG_PROC_FS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163759320974.11926.4532259507042097436.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 15:00:09 +0000
References: <20211122070236.14218-1-yajun.deng@linux.dev>
In-Reply-To: <20211122070236.14218-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 15:02:36 +0800 you wrote:
> proc_create_net() and remove_proc_entry() already contain the case
> whether to define CONFIG_PROC_FS, so remove #ifdef CONFIG_PROC_FS.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/ipv4/arp.c | 33 ++++++++-------------------------
>  1 file changed, 8 insertions(+), 25 deletions(-)

Here is the summary with links:
  - [net-next] arp: Remove #ifdef CONFIG_PROC_FS
    https://git.kernel.org/netdev/net-next/c/e968b1b3e9b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


