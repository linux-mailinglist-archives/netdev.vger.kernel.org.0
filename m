Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFDBE2F2648
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbhALCat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:36972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbhALCat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 21:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D5A922D5B;
        Tue, 12 Jan 2021 02:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610418609;
        bh=zih+8cmGn04mIodAXE1fJa/r1UIa+jDDfKimAr2reR4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tj4x1QD9G2L6SaZOsDPWNqHC2RcKnL+Q08N1rfn6uDYNdyLSWXGf/tIIZ+PzxRd3q
         ySxwjWQJXsosAhTtgJLuRbR6cQXM5gRi+s0VG3vo3E065GWja/FbyH2yn/4mUw7UBs
         kxI5fv9kC7V6qLTT3eTS2b+fhnSp3ErkksIdZg6ih4JOeEJTHtJbZ8PBLJamJqJPM3
         GhsVbkPABhq3dQfBgJ8NsZmP1wXBwGYhCxejLlmUDLI/GZUcK81+5oMMgehI7PxzUj
         JlzXz0UoeABQ+atYd2CFFrtNL/SYakgobhRTkq8rPOXjzM1VtBuOgA2aabu1QFlYPm
         JB3rCvGjzMBWQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id F2EE36013D;
        Tue, 12 Jan 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] skb frag: kmap_atomic fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161041860899.19672.17362498590268966329.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Jan 2021 02:30:08 +0000
References: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210109221834.3459768-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat,  9 Jan 2021 17:18:31 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> skb frags may be backed by highmem and/or compound pages. Various
> code calls kmap_atomic to safely access highmem pages. But this
> needs additional care for compound pages. Fix a few issues:
> 
> patch 1 expect kmap mappings with CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP
> patch 2 fixes kmap_atomic + compound page support in skb_seq_read
> patch 3 fixes kmap_atomic + compound page support in esp
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] net: support kmap_local forced debugging in skb_frag_foreach
    https://git.kernel.org/netdev/net/c/29766bcffad0
  - [net,v2,2/3] net: compound page support in skb_seq_read
    https://git.kernel.org/netdev/net/c/97550f6fa592
  - [net,v2,3/3] esp: avoid unneeded kmap_atomic call
    https://git.kernel.org/netdev/net/c/9bd6b629c39e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


