Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB37A43B360
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 15:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236278AbhJZNwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 09:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236273AbhJZNwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 09:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C24EE61002;
        Tue, 26 Oct 2021 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635256206;
        bh=e2eq+OvgX7av0CHumTLIbp3yo/firkDnnaRKg2NNHAY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oWREKgZA4a+FsvnRax7ajgDugmRAv4c3Xhy7nKsm6ld5LlTy49DxL/7PgcE6AP5bn
         vQuNU72Ue8aQNSnLEYDqsw76cmavZr9ctLYEof91PMOIyYb0+gMBt4MfHPV/fVMUZt
         B6Pts1mdKCAjtyOHQbpHTwxsahbNP1Wufy7spM1IsRftynAze0HlzzfwIpBByUVYHY
         FfOoXG7z4pr2uyapRjnGlw+w9yaUiwh38KRcKPAekHlcaHw0bYJY38CVfyfX9S5WGe
         qYK3cPUnDIrnhtzsEf6GTyGuYW8S+W7YQ6SlFr9POi3N6m1FUvmGfwb7Rq0yrYF6e0
         LkQ2ac1OeKQaw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B4C1D60726;
        Tue, 26 Oct 2021 13:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: batman-adv: fix error handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525620673.3700.4010737178045204457.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 13:50:06 +0000
References: <20211024131356.10699-1-paskripkin@gmail.com>
In-Reply-To: <20211024131356.10699-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org, davem@davemloft.net, kuba@kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+28b0702ada0bf7381f58@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Oct 2021 16:13:56 +0300 you wrote:
> Syzbot reported ODEBUG warning in batadv_nc_mesh_free(). The problem was
> in wrong error handling in batadv_mesh_init().
> 
> Before this patch batadv_mesh_init() was calling batadv_mesh_free() in case
> of any batadv_*_init() calls failure. This approach may work well, when
> there is some kind of indicator, which can tell which parts of batadv are
> initialized; but there isn't any.
> 
> [...]

Here is the summary with links:
  - net: batman-adv: fix error handling
    https://git.kernel.org/netdev/net/c/6f68cd634856

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


