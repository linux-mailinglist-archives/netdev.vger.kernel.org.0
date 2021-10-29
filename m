Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79E043FC56
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhJ2Mch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:32:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhJ2Mcg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:32:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1D74D61167;
        Fri, 29 Oct 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635510608;
        bh=m6qQY9WBE2ArPV4EqNl/MJXTEtCQw1qSPiI+14kq61g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FSqll8PybjRVlTyuKjgQQDXIzrq+PNlYOZWojwe/m6pBKnBVa/ScGatMO/mPbLhUe
         pYOPgYfCCZCZi5R2zlikZs6KVDKNWeQOGnNYn0lzXBlcypbJI1/nGZrY8eUyhGqVwZ
         Tgf1ngvFy7e+QIbQiksMHe/kiYP5gEaUJG6RxX4YLuZvIaZ3EuxqZ55c7OnWH+fYKi
         0dhIGtdBDSR1FLW/mfFEzve0SHnN3Nrw6fHh2+IYEMCINz8G/x+1DJYjWYvALqrX1s
         6j12dLQx9bDtdjTiuEbza8Cg5ulEy1ivukbffeDYBNUNkp0R6FFlrtZZUDrqersXYy
         0NJPrzOKKhJoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 08D4A60A5A;
        Fri, 29 Oct 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] arch, misc: use eth_hw_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551060803.23077.12213863082759629082.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:30:08 +0000
References: <20211029024707.316066-1-kuba@kernel.org>
In-Reply-To: <20211029024707.316066-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 19:47:04 -0700 you wrote:
> Convert remaining misc drivers to use helpers to write
> to netdev->dev_addr.
> 
> This is the last set :) :)
> 
> Jakub Kicinski (3):
>   net: sgi-xp: use eth_hw_addr_set()
>   net: um: use eth_hw_addr_set()
>   net: xtensa: use eth_hw_addr_set()
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: sgi-xp: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/40d5cb400530
  - [net-next,2/3] net: um: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/ac617341343c
  - [net-next,3/3] net: xtensa: use eth_hw_addr_set()
    https://git.kernel.org/netdev/net-next/c/7e1dd824e531

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


