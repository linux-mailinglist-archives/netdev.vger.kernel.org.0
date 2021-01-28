Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45BE308067
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231470AbhA1VVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:21:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:60222 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231430AbhA1VUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 86DEA64DF5;
        Thu, 28 Jan 2021 21:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611868811;
        bh=+gtzFtUMOT3g6M28E0GpBrJGHbNiV/x+iVkX3IbvTx0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YFOL+ipNozUU237xdLhnx+Iny1iZ2c98FFjFW2rfiUFJ2GIfEY9bGB2xkW9Q7lsW0
         wHJGAyxA3UYi0UunNtq2AxZxyUIDxhUekjwBn2ISvBOaF/GzYHv2eCiOkFaz4eU7EU
         0fkM2KXvaHBdMSesLmX7We3yi5XVKjVmf7HW5LeYUMR5Y9ipoVYdbK30UNdVsFk3xX
         u/G9yWropQWoqMGdsGksUz9v6C/kzjVixQaTiORysE82aNK0RqJTtHuy1MKaccVaoE
         KJZyJigMhBFADAoX3+3CT4QrY8LV2nvxtxbkbu4gasZx4zrPMmZVxypYgcaM5b+AL5
         u23V3CsD4KuJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8316260077;
        Thu, 28 Jan 2021 21:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix memory leak in rxrpc_lookup_local
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161186881153.25673.15830898023753339404.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 21:20:11 +0000
References: <161183091692.3506637.3206605651502458810.stgit@warthog.procyon.org.uk>
In-Reply-To: <161183091692.3506637.3206605651502458810.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, jeliantsurux@gmail.com,
        syzbot+305326672fed51b205f7@syzkaller.appspotmail.com,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 28 Jan 2021 10:48:36 +0000 you wrote:
> From: Takeshi Misawa <jeliantsurux@gmail.com>
> 
> Commit 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
> Then release ref in __rxrpc_put_peer and rxrpc_put_peer_locked.
> 
> 	struct rxrpc_peer *rxrpc_alloc_peer(struct rxrpc_local *local, gfp_t gfp)
> 	-               peer->local = local;
> 	+               peer->local = rxrpc_get_local(local);
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix memory leak in rxrpc_lookup_local
    https://git.kernel.org/netdev/net/c/b8323f7288ab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


