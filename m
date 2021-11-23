Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B7145A1E5
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhKWLxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:40926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236532AbhKWLxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:53:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A681A61074;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637668209;
        bh=0g5B4OBeXDLrxVPAbo1woOf+al126n/q3HOGFsLH6O4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z1Lj3egO27mPjhnzl1IAhu8uSVpmP/7oCcOID3AyrgrhMt7xl9HvBSObx1RtHqQT3
         o5pUJTV7L6Aszo3yFcNiy7VJTQboXT4ZPnIaVFrryhpqkkkVUMEY+RTckGT83Lm3Er
         ZRXNaiESKk7EHu2pgoJx/jZkVdljK+x73Bkz0mwK/sVOAt7wrHobP9+zS7NRaQcG9B
         SuDuhpZ6CoDnMPUhRRjBWLSXJPvqThAcQjWJvtuT5DX48ttHDAtzMe74gOoGF9qm9U
         wULqNbfRuOFJPhCJsnIDmI3ASB+EqCua2VCzhchKuZZUMurehfLnOAqOiuySBU8uog
         ZZ5r2HUKlQd5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9491260A4E;
        Tue, 23 Nov 2021 11:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Fixes for closing process and minor cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163766820960.27860.13843166347749611387.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 11:50:09 +0000
References: <20211123082515.65956-1-tonylu@linux.alibaba.com>
In-Reply-To: <20211123082515.65956-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, kuba@kernel.org, davem@davemloft.net,
        guwen@linux.alibaba.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 16:25:14 +0800 you wrote:
> Patch 1 is a minor cleanup for local struct sock variables.
> 
> Patch 2 ensures the active closing side enters TIME_WAIT.
> 
> Tony Lu (2):
>   net/smc: Clean up local struct sock variables
>   net/smc: Ensure the active closing peer first closes clcsock
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: Clean up local struct sock variables
    https://git.kernel.org/netdev/net/c/45c3ff7a9ac1
  - [net,2/2] net/smc: Ensure the active closing peer first closes clcsock
    https://git.kernel.org/netdev/net/c/606a63c9783a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


