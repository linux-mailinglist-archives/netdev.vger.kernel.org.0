Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C32B400AAD
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 13:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235615AbhIDKBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Sep 2021 06:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:45122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234482AbhIDKBH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Sep 2021 06:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A616961051;
        Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630749605;
        bh=Vb/QCF0mqLt1KZB9fm49Vrx8nGQS2qfY/oTRDy+NaxY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DM+t4bd70spWLmLxHVGYOQvDIHio/wJ8HwFLyAX2B/oM+gJMXGO0a6n29zgfRCtwk
         PGf3IhvgTI9iPfTinAg94hJ/1t1Z6gbG7wyabmk2x5Lz2PA7aknbOZnKTLp15ssAob
         g5jH06RKncTYOEfJiF2p4uPhyp5F+LPWR9lHPEfVteuo0Ji1TAk4MAt9Hduv4EOnqA
         137sfC0ETl79/XVNbo3Ul7XNwQGvZUT6RADnCtPUoNoEeUm06VsdTyBXLuDGnuPMQu
         Gw3GtBBCH39a2ncCjrQhSaphU8HBOcZxbA1jcgWYrtzKtLrKW4XepatmPOH82xvBiG
         CgPxiem1nqmwQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 971E960A49;
        Sat,  4 Sep 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] fq_codel: reject silly quantum parameters
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163074960561.20299.12317184407544196624.git-patchwork-notify@kernel.org>
Date:   Sat, 04 Sep 2021 10:00:05 +0000
References: <20210903220343.3961777-1-eric.dumazet@gmail.com>
In-Reply-To: <20210903220343.3961777-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  3 Sep 2021 15:03:43 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot found that forcing a big quantum attribute would crash hosts fast,
> essentially using this:
> 
> tc qd replace dev eth0 root fq_codel quantum 4294967295
> 
> [...]

Here is the summary with links:
  - [net] fq_codel: reject silly quantum parameters
    https://git.kernel.org/netdev/net/c/c7c5e6ff533f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


