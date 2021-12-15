Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7144D475123
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 04:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbhLODAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 22:00:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhLODAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 22:00:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A33C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 19:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A758617BF
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 927B1C34601;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639537210;
        bh=7iLnAheTtYRptnMXphs6WRI7DwiGpmdAPXshS2S/ZGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V+Xu8UNo6SOE2YUqKY3fQzIt2aaOuIFAXgQX9eSIlVea2qjCYXysZbUYwWEuUU5FJ
         PONnXPy5+IvmcT7ZTsaL67xqSWf/Ij3oumIESeoSyibsu3okaWveXlLp8pglfkTPj7
         wd7PQ01SLZdE3qp2ZYJX7jFuc+5fHHrVQ91t8w+kD3RaMGztPcGtsX0Y3O8FOD6/uA
         0zy+XklG2NXtPo/TXjHKyg1EnzPMeMR6ETJPYoP65qX1rv8m/zQcwbAzC9UZk399xN
         oS5eeWZRAUC9qyfxPbjmZelOlbIiu/oGtOH08RdoKnqXqae00kMlGSGuv/eDaD9LXy
         seW3kHbaXGOnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 733EB60A2F;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mptcp: adjust to use netns refcount tracker
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163953721046.25069.1206199931840025288.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 03:00:10 +0000
References: <20211214043208.3543046-1-eric.dumazet@gmail.com>
In-Reply-To: <20211214043208.3543046-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com,
        mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        fw@strlen.de, pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Dec 2021 20:32:08 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> MPTCP can change sk_net_refcnt after sock_create_kern() call.
> 
> We need to change its corresponding get_net() to avoid
> a splat at release time, as in :
> 
> [...]

Here is the summary with links:
  - [net-next] mptcp: adjust to use netns refcount tracker
    https://git.kernel.org/netdev/net-next/c/1d2f3d3c6268

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


