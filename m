Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27F18300FE1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbhAVWVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728945AbhAVWUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 17:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C36123B06;
        Fri, 22 Jan 2021 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611354010;
        bh=hWx6nRV1ARYPk2gv222CAqE4BbnDgp36UxP9O6ASPj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cCV2zShoT26XrnoBDjrTnY55E0/JWHIi+dtBVFPmqR4fs+lVKb3DRfPeujMYc18uz
         WGuOKMIR1Ol2NHxZznO2At4SRY/rdzFE1TaKeC9xpGeWVQLtcjC3Fnj+Oh0Is01Yw+
         dtkv/rNczlVa2ZWwD0sas68cwAHgURzfo48XUeIF0kQxr6v9QSKyRVUpyAMkt1rBOX
         7CaH8fKqFEMnzVFBuZJWhFu6VDNGIgJbZ8k3aIq6J+w6f1ABGW0WDIVPKcGjoNEmId
         QHSy6BvBRkJqq/CB7l+e/0yQaLNq2w46TiviCJZxCYQfVMA0EmN37XCR+4is9yY80L
         bCtypfoJ+xt9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4DE1E652D8;
        Fri, 22 Jan 2021 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: put file handler if no storage found
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161135401031.12943.10675610849465609420.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jan 2021 22:20:10 +0000
References: <20210121020856.25507-1-bianpan2016@163.com>
In-Reply-To: <20210121020856.25507-1-bianpan2016@163.com>
To:     Pan Bian <bianpan2016@163.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 20 Jan 2021 18:08:56 -0800 you wrote:
> Put file f if inode_storage_ptr() returns NULL.
> 
> Fixes: 8ea636848aca ("bpf: Implement bpf_local_storage for inodes")
> Acked-by: KP Singh <kpsingh@kernel.org>
> Signed-off-by: Pan Bian <bianpan2016@163.com>
> ---
>  kernel/bpf/bpf_inode_storage.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Here is the summary with links:
  - bpf: put file handler if no storage found
    https://git.kernel.org/bpf/bpf/c/524db191d2f5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


