Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDD773AF80B
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhFUVwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:52:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231460AbhFUVwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 17:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C33961289;
        Mon, 21 Jun 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312204;
        bh=nSY1EDhSqPYXZn65k5TZP64JbbnKiLYup0swSnr5/xQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kEeYRGs74SmGqXDReWcvSrI1oxNhDAHC7Hj8JWVAT4n0JknECTY8JyBYcQS9LqtXE
         e4aw9eAjuBeiset6QAE1rH2AaP6iP9GupIkNDkywiT0Q8cd6MikMsVAvpd2yxZcEPd
         6LcVOd+lH/bJCaYOdT6jp+YKTPEdgMAxXxTtqL/KT4I0r5vYHt7JRTHcE9hC83GbXV
         B9Upv9zaVBRpHHNIV+9q1a35nvsRP1Pd2QlePD/iTLp2eTUi4E3yCKyD26ZpPVG+md
         Xoy2j/vPenTUvknXbSpr4JJap5TWVXoBSdPutD5IgXwHnAYqFiZf/bndRs6aa9Ls98
         bWxn/l/E+D9rw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6EABE60A6C;
        Mon, 21 Jun 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mana: Fix a memory leak in an error handling path in
 'mana_create_txq()'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431220444.17422.9240732393045987278.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 21:50:04 +0000
References: <578bcaa1a9d6916c86aaecf65f205492affb6fc8.1624196430.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <578bcaa1a9d6916c86aaecf65f205492affb6fc8.1624196430.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, shacharr@microsoft.com, gustavoars@kernel.org,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun, 20 Jun 2021 15:43:28 +0200 you wrote:
> If this test fails we must free some resources as in all the other error
> handling paths of this function.
> 
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: mana: Fix a memory leak in an error handling path in 'mana_create_txq()'
    https://git.kernel.org/netdev/net/c/b90788459cd6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


