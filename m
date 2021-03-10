Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1B13332D0
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 02:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhCJBiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 20:38:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:60562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhCJBht (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 20:37:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AE5F965100;
        Wed, 10 Mar 2021 01:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615340268;
        bh=XK+C/F1pao33GMuRywnjQqkfkq4PVLXGJS5NAV1JM5s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SpRoR5hyOf46DIEQFNCMli4z5D7R9AOuVCYiWA6sezT6HVrgXkeGcOVAojPhIMXWl
         pn4NxHPiYUMJFWnib1/eOmE6i/xWZXKOXcBP5Ugzr87ugzuN8XaP7YdNUkYYaK0STf
         B3RrnyJ0t7JbDAmlABCWBEdTNS/zBW4Uy1afFvmfc9nb+8if2gLCx2PT+xCFL9FvSV
         a9+MOpAHPqUQgqe25if+SwbDF2Cux4K/90kIO1NW4Np4XOm5GKrzzBnpPOd3GBHswm
         y1Af/mtNSTWtJbeRWibj54Ky6WCZ//ysWJUpKR+qy4kjmZCOUv3S5+cd/s9CGlRsLE
         6zSQHG9HJlhQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D6D860952;
        Wed, 10 Mar 2021 01:37:48 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests/bpf: set gopt opt_class to 0 if get tunnel opt
 failed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161534026864.31790.14467574294253275820.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 01:37:48 +0000
References: <20210309032214.2112438-1-liuhangbin@gmail.com>
In-Reply-To: <20210309032214.2112438-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, daniel@iogearbox.net,
        yihung.wei@gmail.com, davem@davemloft.net, bpf@vger.kernel.org,
        u9012063@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  9 Mar 2021 11:22:14 +0800 you wrote:
> When fixing the bpf test_tunnel.sh genve failure. I only fixed
> the IPv4 part but forgot the IPv6 issue. Similar with the IPv4
> fixes 557c223b643a ("selftests/bpf: No need to drop the packet when
> there is no geneve opt"), when there is no tunnel option and
> bpf_skb_get_tunnel_opt() returns error, there is no need to drop the
> packets and break all geneve rx traffic. Just set opt_class to 0 and
> keep returning TC_ACT_OK at the end.
> 
> [...]

Here is the summary with links:
  - [net] selftests/bpf: set gopt opt_class to 0 if get tunnel opt failed
    https://git.kernel.org/netdev/net-next/c/557c223b643a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


