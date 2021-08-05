Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CD13E1750
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241330AbhHEOuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:38716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233269AbhHEOuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 10:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55F8C61159;
        Thu,  5 Aug 2021 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628175006;
        bh=nNx864jOpGsY8Fllnm7k8ZuF5fR9ejytnm2A9LuOrlo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n03cAyjcWAyGcHbVX+/FDh109nspNKfGUtWxzrlGuLe1H0rTkjtXLrV+Br8qDCjhy
         aNBE3QaIfIFTpCR5KgwigfAaH2EZGvjede5Ewwe8oZeu65+U4pb6Cj/J7Nb3kihY+0
         x1BQKgcOvj4C5YRM2BvrU8wRs/3LmoXq9/VIQxkq59J0xg5Op9XeV0vV3NXHmoiHgq
         BSScA7nw3dHDYJh8M6k+ahFKSCTfV042t8XJtZ0x1O95HW6iYan53zuJRzds7WtLH5
         hTUVCvyRtRnD2u+2sYxujN66VNvcxX1Mc59FWnLFr5a1uZmGF97hkiK84LcdjreQaw
         1o/WjlUJZTYeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4389E60A88;
        Thu,  5 Aug 2021 14:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: pegasus: fix uninit-value in
 get_interrupt_interval
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162817500627.11382.2475044595872235331.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 14:50:06 +0000
References: <20210804143005.439-1-paskripkin@gmail.com>
In-Reply-To: <20210804143005.439-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     petkan@nucleusys.com, davem@davemloft.net, kuba@kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+02c9f70f3afae308464a@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  4 Aug 2021 17:30:05 +0300 you wrote:
> Syzbot reported uninit value pegasus_probe(). The problem was in missing
> error handling.
> 
> get_interrupt_interval() internally calls read_eprom_word() which can
> fail in some cases. For example: failed to receive usb control message.
> These cases should be handled to prevent uninit value bug, since
> read_eprom_word() will not initialize passed stack variable in case of
> internal failure.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: pegasus: fix uninit-value in get_interrupt_interval
    https://git.kernel.org/netdev/net/c/af35fc37354c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


