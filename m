Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2637043F541
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhJ2DMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:12:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231593AbhJ2DMg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 23:12:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1236E610A0;
        Fri, 29 Oct 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635477009;
        bh=+cvk0c0JQLg/CYK1hI/DRrR30KpuLAnRarb5dEiRmKI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iR3tdit7FDVyiRKcIFeoHCor8wJx4xLBwSQ+9PUf2d6VplWIViLudxqYr8P1PV4iF
         CqasfGhPc5XyrMZHHGmIH8txQ9CYlc8an9cY/XkzrByoqnglXFg1gYhPELCkF0dWf/
         kX56EnZP4vQI83SPEAF+ubxqOrWJCpUjvqULEBoFVV4onQO38TjWJSYyqq3IoWxys5
         LxhLY1URQeGEFKxywcZzPnsRybeFnWbOrVeLYzTsiPpRzoIDpWRhEZK0zXAbM4jeUH
         PdrzWw6tDHTZjbeqBVJBTLUq3htjGJcjM9zmAU7HiBmhwWbMvGA37j1TG3o28+HqF/
         OzHY+ECc1ks7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0419A60A1B;
        Fri, 29 Oct 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mlxsw: Offload root TBF as port shaper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163547700901.18853.9697116912833662953.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 03:10:09 +0000
References: <20211027152001.1320496-1-idosch@idosch.org>
In-Reply-To: <20211027152001.1320496-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Oct 2021 18:19:58 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Petr says:
> 
> Egress configuration in an mlxsw deployment would generally have an ETS
> qdisc at root, with a number of bands and a priority dispatch between them.
> Some of those bands could then have a RED and/or TBF qdiscs attached.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mlxsw: spectrum_qdisc: Offload root TBF as port shaper
    https://git.kernel.org/netdev/net-next/c/48e4d00b1b93
  - [net-next,2/3] selftests: mlxsw: Test offloadability of root TBF
    https://git.kernel.org/netdev/net-next/c/3d5290ea1dae
  - [net-next,3/3] selftests: mlxsw: Test port shaper
    https://git.kernel.org/netdev/net-next/c/2b11e24ebaef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


