Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A77B6355FD7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344929AbhDGAAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:00:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344841AbhDGAAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E409F6139C;
        Wed,  7 Apr 2021 00:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617753608;
        bh=30XueeJ/t99x24FUiWsE965joCRrw3Xyk46LuwB5YPE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bZZqSgQjsNIC6HQQ4n8KzQE1hKiigWxC/gkuHPfOOPdN608RKx11PCNiBNmGQxtvf
         /ZHBK8kNQvrwyXMlmJIR6uyqY+UNuGYhDxloMrY19n9P2XmUOz/UUXwuXOTnkpOb4+
         3KfTHP4h0h7UYQiu93+60ydzGF1+0qpF26oL754SFhTETRwEuOofmo6cRBx20LyCAj
         4qaDTkkQsPO3Shl3STN6F5vvz/CGsQe9WqrzorPcO4svCx9/cjG9ICjpceXCfLFRs1
         Vnmmro6I6MquOoi8MxtDRVuQzl+UI9NC5GO833JoBpdNLkzK6tjjO2hpiqD1xBUqpS
         b+qqlh0ixqMCg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D257160A50;
        Wed,  7 Apr 2021 00:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: tun: set tun->dev->addr_len during TUNSETLINK
 processing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775360885.28852.875738230576067621.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 00:00:08 +0000
References: <20210406174554.915-1-phil@philpotter.co.uk>
In-Reply-To: <20210406174554.915-1-phil@philpotter.co.uk>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, eric.dumazet@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Apr 2021 18:45:54 +0100 you wrote:
> When changing type with TUNSETLINK ioctl command, set tun->dev->addr_len
> to match the appropriate type, using new tun_get_addr_len utility function
> which returns appropriate address length for given type. Fixes a
> KMSAN-found uninit-value bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51
> 
> Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
> Diagnosed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> [...]

Here is the summary with links:
  - [v3] net: tun: set tun->dev->addr_len during TUNSETLINK processing
    https://git.kernel.org/netdev/net/c/cca8ea3b05c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


