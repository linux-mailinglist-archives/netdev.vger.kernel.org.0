Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F322BB4DB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 20:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgKTTKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 14:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgKTTKG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 14:10:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605899405;
        bh=27g9oYw3eKNej5IQPp+L42n08bxl6KFHG/cak9Dl0sw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=z8toAVCt23V4bZv9sm2FVVLmDVWS1+34DWJf6CzAeOz0OCcoEpx84n07GmrNmiIFe
         cWJPE20pGrTyG7YJBlS1zPJQU8BGR+2LcvFjf2vQdLbzA9xBIWB8PjKeEt19LVvC0Z
         Knv6r6ebHrJqhaO1FFMqTbPeD26+tkLnBBiTMmyc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: fix the panic caused by non smac rewrite
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160589940540.22082.17295076562285694549.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Nov 2020 19:10:05 +0000
References: <20201118143213.13319-1-rajur@chelsio.com>
In-Reply-To: <20201118143213.13319-1-rajur@chelsio.com>
To:     Raju Rangoju <rajur@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 18 Nov 2020 20:02:13 +0530 you wrote:
> SMT entry is allocated only when loopback Source MAC
> rewriting is requested. Accessing SMT entry for non
> smac rewrite cases results in kernel panic.
> 
> Fix the panic caused by non smac rewrite
> 
> Fixes: 937d84205884 ("cxgb4: set up filter action after rewrites")
> Signed-off-by: Raju Rangoju <rajur@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: fix the panic caused by non smac rewrite
    https://git.kernel.org/netdev/net/c/bff453921ae1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


