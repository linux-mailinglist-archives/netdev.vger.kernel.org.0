Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D5C457DDE
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 13:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237400AbhKTMdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 07:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:37944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237458AbhKTMdN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Nov 2021 07:33:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 284D160EE0;
        Sat, 20 Nov 2021 12:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637411410;
        bh=xcpsoqFE+DYnr21fHDMPGKKyVnPB0fElOUojqbYlkWM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=krQNWlFEMOtgGOiUyE17wmflXXXi67060uxZOVS2ivAlj/kI9mYYXYH9yYQfSD2ob
         bRraZRWW+RENqceOtFD26WReZ+Lo/VsqNR1GizXqLTRMuqxezaEbSRgR9rsug4UC2O
         X3pcc+JW7cXto1db3dbhBczleQasuMS1VR7sFs2JnYUraFnFS79FYKSMIEpwYhS2IE
         dB0rJakJGHz0vj7/xMRj0ldz5wvkLSXwMM1gt5RscbC9Xog7VFaIWH+0Wv/fBkgFK+
         25CcXAJWhLbhrCf4WeG6gVFEODGmMLq5vgG2BUwzPQiwrvGhA/jaRUXc7JwShSEtOF
         KBVz0qGiXErKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 23D1060A0C;
        Sat, 20 Nov 2021 12:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/7] net: constify netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163741141014.21964.15405864461151312227.git-patchwork-notify@kernel.org>
Date:   Sat, 20 Nov 2021 12:30:10 +0000
References: <20211119142155.3779933-1-kuba@kernel.org>
In-Reply-To: <20211119142155.3779933-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 06:21:48 -0800 you wrote:
> Take care of a few stragglers and make netdev->dev_addr const.
> 
> netdev->dev_addr can be held on the address tree like any other
> address now.
> 
> Jakub Kicinski (7):
>   82596: use eth_hw_addr_set()
>   bnx2x: constify static inline stub for dev_addr
>   net: constify netdev->dev_addr
>   net: unexport dev_addr_init() & dev_addr_flush()
>   dev_addr: add a modification check
>   dev_addr_list: put the first addr on the tree
>   net: kunit: add a test for dev_addr_lists
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/7] 82596: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/0f98d7e47843
  - [net-next,v2,2/7] bnx2x: constify static inline stub for dev_addr
    https://git.kernel.org/netdev/net-next/c/c9646a18033e
  - [net-next,v2,3/7] net: constify netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/adeef3e32146
  - [net-next,v2,4/7] net: unexport dev_addr_init() & dev_addr_flush()
    https://git.kernel.org/netdev/net-next/c/5f0b69238427
  - [net-next,v2,5/7] dev_addr: add a modification check
    https://git.kernel.org/netdev/net-next/c/d07b26f5bbea
  - [net-next,v2,6/7] dev_addr_list: put the first addr on the tree
    https://git.kernel.org/netdev/net-next/c/a387ff8e5dda
  - [net-next,v2,7/7] net: kunit: add a test for dev_addr_lists
    https://git.kernel.org/netdev/net-next/c/2c193f2cb110

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


