Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061CE45A26F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237165AbhKWMX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:23:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:48878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237079AbhKWMXU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:23:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F960610A5;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670012;
        bh=L8e0Q/0kRa5uydk/5RFhR4UGE3MINe9N/PLYGsUNsEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CKaq3YSwNnecNH3hnSEmUbuSR9mXnevZ7BYapDmxCiRHrkxk8gZFMNivcONoZdSSW
         +o06Og1wpjb9+BCnOX0K+YFtsZU8XMUVXhoS93qD2ubV23U/kYAiUfnKqJQqQJGaSq
         MPBBxbWr3W8C5EiqKyq98PDawpPEw0p/Z6Dn0XcYvm/yvZjDw0DgFBri76W1fR5Tyb
         d54gbMQxz4NkknPE4HhG/tUt6tavpkbuqiMAFEocApD6XPCNhKqp4sf1riv97sg2vC
         zg+yUXwm0r78LkS59NG2jk/1GghGLmB4ZymV8P3OsALcfJUluZJeoXGtLWL2MYLk+P
         GgLlW7YDgmqlg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2688260A6C;
        Tue, 23 Nov 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tsnep: Fix set MAC address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767001215.10565.5464135620987871114.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:20:12 +0000
References: <20211122203225.6733-1-gerhard@engleder-embedded.com>
In-Reply-To: <20211122203225.6733-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 21:32:25 +0100 you wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> Commit 4dfb9982644b ("tsn:  Fix build.") fixed compilation with const
> dev_addr. In tsnep_netdev_set_mac_address() the call of ether_addr_copy()
> was replaced with dev_set_mac_address(), which calls
> ndo_set_mac_address(). This results in an endless recursive loop because
> ndo_set_mac_address is set to tsnep_netdev_set_mac_address.
> 
> [...]

Here is the summary with links:
  - [net-next] tsnep: Fix set MAC address
    https://git.kernel.org/netdev/net-next/c/75e47206512b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


