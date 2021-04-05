Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC28B354742
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 22:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240323AbhDEUAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 16:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232726AbhDEUAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 16:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9B8B261041;
        Mon,  5 Apr 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617652809;
        bh=5ZH+jTqVwO2mzTpSHW0hmmnk47NXBHM6PwZt0uj3Osw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fhDWMEE1/a/p/EtmsUQvID9ZZi0M/NDckl3QxwjpNVMxgSPbXXhnP87hQ+BU27S1z
         BTC9ytUOzcQaxuRLfQlwHy9kaOQcu+rG12mEvYWQQ/hChNEYzQBXdSG2gn9etUictj
         PJgxDpMHlhiyz/g3YKxB9XKjcwQBzqqBDz2N3ylnzaRIHdULESqtpZhUJEDJfPffuP
         4EmwrQeFZIVwaqbSeHnzGna2tV8CrLrC765+jPiqiA9tKW+3WMZHP56SoU22n8v5iA
         ADObInvXelZLhfgHZE8mQox9Om7+QO8BC0dR7BiPKlGT1ylwfDZBD43UM+FMMwwDnY
         tBnPxdgRITUVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90FE160A19;
        Mon,  5 Apr 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] qede: Remove a erroneous ++ in 'qede_rx_build_jumbo()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161765280958.6353.3809782901793052721.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 20:00:09 +0000
References: <1c27abb938a430e58bd644729597015b3414d4aa.1617540100.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1c27abb938a430e58bd644729597015b3414d4aa.1617540100.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun,  4 Apr 2021 14:42:44 +0200 you wrote:
> This ++ is confusing. It looks duplicated with the one already performed in
> 'skb_fill_page_desc()'.
> 
> In fact, it is harmless. 'nr_frags' is written twice with the same value.
> Once, because of the nr_frags++, and once because of the 'nr_frags = i + 1'
> in 'skb_fill_page_desc()'.
> 
> [...]

Here is the summary with links:
  - [1/2] qede: Remove a erroneous ++ in 'qede_rx_build_jumbo()'
    https://git.kernel.org/netdev/net-next/c/1ec3d02f9cdf
  - [2/2] qede: Use 'skb_add_rx_frag()' instead of hand coding it
    https://git.kernel.org/netdev/net-next/c/7190e9d8e131

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


