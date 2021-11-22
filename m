Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 137A9458F66
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhKVNdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232874AbhKVNdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 08:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2045F60462;
        Mon, 22 Nov 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637587810;
        bh=m2n+G/v1dl2FiZ0PEw+5YvQ+Ig1iJGN/ENmM8UZk8eM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gMTFKeYKjAeka2R7HoDkYC3Sn5QHGv58BrNcHFirwFhKv9NdgS+Baabqv3wBjA2bG
         llIbKxYk36I8OqidOuE10Ga5nbV9uQDj1KLcfeXuCd8uBEakuaN/3MU+b5GYeFIvNr
         +SlW+sKNVBT8yLMwRKGMPGQSq6t3j6AjteE2ZosuWPeeetH6TM5p00rytNWIFG52wX
         bVX02xCOk30dAud1Z7CeN+J71N573sC0rBT9+O2ht97JL0RuZ4Ojtd8WlKdZu/5gRn
         qIYmUQ9dL/rqVK9AWXdGhhHeebKersnXJLlbrrpDeW58rK1ajnHoxT8KAYPZhFhqg0
         dxxXOU8HHMX4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 15DDC60A94;
        Mon, 22 Nov 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeon: constify netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758781008.2556.11761013165378587898.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 13:30:10 +0000
References: <20211120153119.132468-1-kuba@kernel.org>
In-Reply-To: <20211120153119.132468-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dingsenjie@yulong.com,
        michael@walle.cc, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 20 Nov 2021 07:31:19 -0800 you wrote:
> Argument of a helper is missing a const.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: adeef3e32146 ("net: constify netdev->dev_addr")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/cavium/octeon/octeon_mgmt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] octeon: constify netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/a9c2cf9e9333

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


