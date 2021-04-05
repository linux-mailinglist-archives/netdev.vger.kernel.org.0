Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B24B3546E0
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 21:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbhDETAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 15:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234063AbhDETAP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 15:00:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DEAF16128A;
        Mon,  5 Apr 2021 19:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617649208;
        bh=OeEzPTq+1eWjCXb/NofZTNTh0T36O0z2OIw1nH+R8Q0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c0XImX0IgP3ld8PDj5mFcm3HMB2v7PeT4nBq/y6/s9n5a4bMXfdhNJIhCQxXDLEQU
         uj+2bnlCkkl/IXkMWZGmRwPz8DA1y5x2CeWLbPZg1zSXhNsngUZQXMkVnwnJAPyLBW
         ZGHp2yFo8fdDTkfZ2764Ua4KVDYFKPm800gpwkGYjNEbieVrbt5W4fmXptAPRndQqw
         y+9GL5PRa4ZRa3vRjuYhy/B4AzdbthYhRQV47W1kCqvxxkGPVaP/1VGv9jevo0IDGH
         GjEAWTLqH1jBaNWLqj3Rs3FQziKqlSWbNsKEviU43RTUj5LyeTSL2kz6jpuT8hTkme
         53OeNdLC8jGdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C931560A19;
        Mon,  5 Apr 2021 19:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ibmvnic: Use 'skb_frag_address()' instead of hand coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161764920881.15280.15774493910120301088.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 19:00:08 +0000
References: <1638085135ee32d5699983981b6a54a11c49ff23.1617526369.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1638085135ee32d5699983981b6a54a11c49ff23.1617526369.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     mpe@ellerman.id.au, benh@kernel.crashing.org, paulus@samba.org,
        drt@linux.ibm.com, ljp@linux.ibm.com, sukadev@linux.ibm.com,
        tlfalcon@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  4 Apr 2021 10:54:37 +0200 you wrote:
> 'page_address(skb_frag_page()) + skb_frag_off()' can be replaced by an
> equivalent 'skb_frag_address()' which is less verbose.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Here is the summary with links:
  - ibmvnic: Use 'skb_frag_address()' instead of hand coding it
    https://git.kernel.org/netdev/net-next/c/c3105f848577

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


