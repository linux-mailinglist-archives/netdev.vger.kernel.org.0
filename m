Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94D014A7EDC
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:10:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236541AbiBCFKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:10:11 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236536AbiBCFKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 00:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1615CB832B4
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD6D7C340EB;
        Thu,  3 Feb 2022 05:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643865008;
        bh=NxiGNZBkbaGfMEG3tdMANsqIsecHxBqvYKgTbB946R8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nvYUfuw/buj8q2jhF1fppkFvqB5eVMMFNxmPwT9fP/vHj11ceO73hCpGGw2Vvh5+0
         WQNNBBpXNQzi0S+HrO5yQJmXLFJWljCfWUTTouDPMudM6KsLDaT8DJnhbl4oY8Df5d
         p2jr3zvhfFRpcWDJMWntPW+xYfW4jEv2Gwo/Q3FyPQPJ0adnNVZElh98W2nZ/od4Bb
         iqR9W7CBOeYOpnha+gzTA6HNOewwg4qbIsVC6QscljxwrqUghgZksiJGfD+DSz3Bkt
         SYNe0njTGTns0EkBz+5xgLy0W2B/yH/TIPs/L7363fmEIDtvmypVJ7WL69Mwnuca1p
         LWRqre10Uyrzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8335E6BB3D;
        Thu,  3 Feb 2022 05:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net,
 neigh: Do not trigger immediate probes on NUD_FAILED from neigh_managed_work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164386500875.26576.7595670637817760927.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 05:10:08 +0000
References: <20220201193942.5055-1-daniel@iogearbox.net>
In-Reply-To: <20220201193942.5055-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        edumazet@google.com, dsahern@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org,
        syzbot+5239d0e1778a500d477a@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Feb 2022 20:39:42 +0100 you wrote:
> syzkaller was able to trigger a deadlock for NTF_MANAGED entries [0]:
> 
>   kworker/0:16/14617 is trying to acquire lock:
>   ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: ___neigh_create+0x9e1/0x2990 net/core/neighbour.c:652
>   [...]
>   but task is already holding lock:
>   ffffffff8d4dd370 (&tbl->lock){++-.}-{2:2}, at: neigh_managed_work+0x35/0x250 net/core/neighbour.c:1572
> 
> [...]

Here is the summary with links:
  - [net] net, neigh: Do not trigger immediate probes on NUD_FAILED from neigh_managed_work
    https://git.kernel.org/netdev/net/c/4a81f6da9cb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


