Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94E435B78F
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236176AbhDLAA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:37018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235722AbhDLAA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 20:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 184B961208;
        Mon, 12 Apr 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618185609;
        bh=Z3+HjFD2wVLdBOW80R1qBPV1cbJtkOakRiIyi1fbt1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EYod0xcGxaau6o/mw1fyIvElOoCNpfZar37p4S9/1yajfi5dFbOorcXEC0wAAZNDk
         Vwn16DTDqi+uNAUa6p7ksYuXHcRNut1BvLhuGxudNmXDWnzA68vbeekVs5Pg2Qh4jL
         rGdouYRrlpxEI+V6tI18AyOU18s3AU/NLkYGjbTFDwBNvmbr4LVgBtI3i1INxbe6XL
         I9dw6LJL42/u26MuzgqTMP+jZCSoH1hmtZC/5dZk3t/WCgHgTQ3i1cr+vulWSsG0S5
         ryNahZBaHecvzJ1OOV1md1brcU5hQYQh94llisEkWZyGOFxTaSl3HYuzif+ND8eQEk
         yzIF+FYRYRKkQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08BAB60A2C;
        Mon, 12 Apr 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: geneve: check skb is large enough for IPv4/IPv6 header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161818560903.30810.14261355608187507119.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 00:00:09 +0000
References: <20210411112824.1149-1-phil@philpotter.co.uk>
In-Reply-To: <20210411112824.1149-1-phil@philpotter.co.uk>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 11 Apr 2021 12:28:24 +0100 you wrote:
> Check within geneve_xmit_skb/geneve6_xmit_skb that sk_buff structure
> is large enough to include IPv4 or IPv6 header, and reject if not. The
> geneve_xmit_skb portion and overall idea was contributed by Eric Dumazet.
> Fixes a KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=abe95dc3e3e9667fc23b8d81f29ecad95c6f106f
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot+2e406a9ac75bb71d4b7a@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> [...]

Here is the summary with links:
  - net: geneve: check skb is large enough for IPv4/IPv6 header
    https://git.kernel.org/netdev/net/c/6628ddfec758

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


