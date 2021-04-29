Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8531C36F2A9
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 00:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbhD2Wk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 18:40:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhD2Wk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 18:40:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5A66D61461;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619736010;
        bh=Dn1c6N3C6yj0h5pMhEUCa8/iLOxejeCA4k3EzmT7UL8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FHwGhlcXG6QMwy0L2EirSf/fIqKDEWevX0xOGGN0G9bcyZlbdU6YPgEizIof8BV4H
         oomF3HZAOV0OtRDdBS3FSGlZYVzhyRFHTTKkr9LVmmtajhWkUVZaJAXMBRw6PMtJ+b
         Fgr3S+MaPKydeSRtM6Q6OPWjEBK1+r+rxTb//BrTcslJiW5pG1dsiE9MTMuUfa9fON
         6ZSqy5Al2aqtd7Ef9Su07MTi48KToNfHc9+pgvJIkzHQf4ZCgmO21unJhs3ioOB+bs
         jmgeKCbDORv1fjl5I5CTG7E4GRN7PzeN9qGtd+P2UPHC/xuqbSW/RSlQpxjpBP61tp
         W8+Iv7xmU7ZZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4772760A72;
        Thu, 29 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net resend 0/2] fix stack OOB read while fragmenting IPv4
 packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161973601028.15907.1699024796278248158.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 22:40:10 +0000
References: <cover.1619615320.git.dcaratti@redhat.com>
In-Reply-To: <cover.1619615320.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 28 Apr 2021 15:23:00 +0200 you wrote:
> - patch 1/2 fixes openvswitch IPv4 fragmentation, that does a stack OOB
> read after commit d52e5a7e7ca4 ("ipv4: lock mtu in fnhe when received
> PMTU < net.ipv4.route.min_pmt")
> - patch 2/2 fixes the same issue in TC 'sch_frag' code
> 
> Davide Caratti (2):
>   openvswitch: fix stack OOB read while fragmenting IPv4 packets
>   net/sched: sch_frag: fix stack OOB read while fragmenting IPv4 packets
> 
> [...]

Here is the summary with links:
  - [net,resend,1/2] openvswitch: fix stack OOB read while fragmenting IPv4 packets
    https://git.kernel.org/netdev/net/c/7c0ea5930c1c
  - [net,resend,2/2] net/sched: sch_frag: fix stack OOB read while fragmenting IPv4 packets
    https://git.kernel.org/netdev/net/c/31fe34a0118e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


