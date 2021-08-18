Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 808053F0078
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhHRJbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhHRJaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:30:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B9B1060F39;
        Wed, 18 Aug 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629279005;
        bh=JRSQuti0WjY5fFT9QVL5gb24S4O2TKFCx6ut1RxKOs8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UI9hQiGY6C+Avwn+Old+4dCrZAvM5eOnX21MI1RTSreW0W/GrZVdCAd8NtXJMlQnX
         OnRl2brsZUVUIGzzpjkW8oMYgVogvMZSrHZXy1uq+YH2+SgGW46g5aDvpng9aGi8/+
         VL3lUrodmzQx6W/cjVqF6rnpMPdptSr6XA2nxbWP0hxJ7RcO1LN7B90bpi7KXZGCQI
         kS+S9B8G2w3cmWYCThdKTmCNcTk6oGaqeB167EcrJOKsaAwTXSoTj4aejlJIwP0+Aa
         HWd+mna+drBhg0bbeXKzGC79gzPQ7j+ivbEEMjpTc++o54+IKODVas1AawRQK48R/b
         FDIGLW+5MMRxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD77360A2E;
        Wed, 18 Aug 2021 09:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162927900570.12358.17291141560471697368.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 09:30:05 +0000
References: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210817145245.3555077-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com, frowand.list@gmail.com, robh+dt@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 17 Aug 2021 17:52:45 +0300 you wrote:
> It seems that of_find_compatible_node has a weird calling convention in
> which it calls of_node_put() on the "from" node argument, instead of
> leaving that up to the caller. This comes from the fact that
> of_find_compatible_node with a non-NULL "from" argument it only supposed
> to be used as the iterator function of for_each_compatible_node(). OF
> iterator functions call of_node_get on the next OF node and of_node_put()
> on the previous one.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: sja1105: fix use-after-free after calling of_find_compatible_node, or worse
    https://git.kernel.org/netdev/net/c/ed5d2937a6a8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


