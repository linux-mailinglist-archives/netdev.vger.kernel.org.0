Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1141142C810
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 19:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbhJMRxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 13:53:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238590AbhJMRwM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 13:52:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 00B2261154;
        Wed, 13 Oct 2021 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634147409;
        bh=KMg/G5KY4iA0CkYnMcI344hHLkKOdcxSYLgy6WpSOwY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jpDvHhN8qiclf4B++HSouGrq2OHIddQN4oXl2o8J9IGl0BbEUtQ65XipEgBoLhfAd
         0Xkuqc00AiacIhAASEv1KWNyKvH0W73sf/ecCX12JVotvfjMInCN3FExOrgkIuexCT
         PKpn8HT/kGrdop2P5LlRXYKvtU4vGKgJIlwjDTnaetIeacc8mL3kxosIg1mkuU0aBT
         YPF0DgX/SXeDvpS5/f0uu4yi1RK/K2RcOBecdtnlV6uIjGTZ5jE5wntt3UwdhCbAUs
         fRHbWdIBrFre8Uy+jOSfqRCzWcdi0HclrFjG8v4jmqJi3wYhW26l2FOaE5RYFe5I3/
         MD4l7IA/f/CMg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E551F60A39;
        Wed, 13 Oct 2021 17:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: use dev_addr_set() in hamradio and ip
 tunnels
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163414740893.22760.13974230226898609573.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Oct 2021 17:50:08 +0000
References: <20211012160634.4152690-1-kuba@kernel.org>
In-Reply-To: <20211012160634.4152690-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Oct 2021 09:06:31 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> Jakub Kicinski (3):
>   netdevice: demote the type of some dev_addr_set() helpers
>   hamradio: use dev_addr_set() for setting device address
>   ip: use dev_addr_set() in tunnels
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] netdevice: demote the type of some dev_addr_set() helpers
    https://git.kernel.org/netdev/net-next/c/40af35fdf79c
  - [net-next,2/3] hamradio: use dev_addr_set() for setting device address
    https://git.kernel.org/netdev/net-next/c/20c3d9e45ba6
  - [net-next,3/3] ip: use dev_addr_set() in tunnels
    https://git.kernel.org/netdev/net-next/c/5a1b7e1a5325

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


