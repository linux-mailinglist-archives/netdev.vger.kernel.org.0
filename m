Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52772EEAD8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 02:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729673AbhAHBUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 20:20:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727634AbhAHBUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 20:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B4C0E235F9;
        Fri,  8 Jan 2021 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610068808;
        bh=JIRvwPViGnzWe9lhZvnmBG4zI6vD1CWT8xlVYVEW268=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kXoEFhg63+Ij7EGQoB9S9hwqGc6MRj2hDjuKJeAZhZQ0dd/YzR4ztcAlncPonV0Vi
         ReWjqzrud+Nd59RcCNHlymbgmoTXo2EfMVIBho1q3aKETPxlDlNxb+XR/qziAFIu7n
         k1A+LsTj2hFwbey92LJ3TDGqcAiQFB1wWbf7OWSQ5EhB8adhXBTNk3r85yC0yBKSgL
         bQLX/pKsQ4lf1spbuUAw1RHDohSZqp0zI2USWLQ13vBIrp0bzFInD5qHC3YHPlU54X
         Mpjsgdarbl8HG8azA6LbzkVODWZiqE0tiXx5o0WS2swhhY1q49+K4oAhwncb74G/n1
         gDGi8wIA/2PWA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id A753C600DA;
        Fri,  8 Jan 2021 01:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/7] Bug fixes for chtls driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161006880867.18845.2212552395551334208.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jan 2021 01:20:08 +0000
References: <20210106042912.23512-1-ayush.sawal@chelsio.com>
In-Reply-To: <20210106042912.23512-1-ayush.sawal@chelsio.com>
To:     Ayush Sawal <ayush.sawal@chelsio.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        secdev@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  6 Jan 2021 09:59:05 +0530 you wrote:
> patch 1: Fix hardware tid leak.
> patch 2: Remove invalid set_tcb call.
> patch 3: Fix panic when route to peer not configured.
> patch 4: Avoid unnecessary freeing of oreq pointer.
> patch 5: Replace skb_dequeue with skb_peek.
> patch 6: Added a check to avoid NULL pointer dereference patch.
> patch 7: Fix chtls resources release sequence.
> 
> [...]

Here is the summary with links:
  - [net,1/7] chtls: Fix hardware tid leak
    https://git.kernel.org/netdev/net/c/717df0f4cdc9
  - [net,2/7] chtls: Remove invalid set_tcb call
    https://git.kernel.org/netdev/net/c/827d329105bf
  - [net,3/7] chtls: Fix panic when route to peer not configured
    https://git.kernel.org/netdev/net/c/5a5fac9966bb
  - [net,4/7] chtls: Avoid unnecessary freeing of oreq pointer
    https://git.kernel.org/netdev/net/c/f8d15d29d6e6
  - [net,5/7] chtls: Replace skb_dequeue with skb_peek
    https://git.kernel.org/netdev/net/c/a84b2c0d5fa2
  - [net,6/7] chtls: Added a check to avoid NULL pointer dereference
    https://git.kernel.org/netdev/net/c/eade1e0a4fb3
  - [net,7/7] chtls: Fix chtls resources release sequence
    https://git.kernel.org/netdev/net/c/15ef6b0e30b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


