Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5196F43CC78
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238900AbhJ0Omk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238967AbhJ0Omf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 10:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 97E9460F92;
        Wed, 27 Oct 2021 14:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635345609;
        bh=86PIk+LD5aV2lFQ+SUhA32+HnPsmV280RAyNJFqLh/c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XbYhNYd8mVLnPC+apNBExugujXD/qNzHtsJ+kVp7ZRsT4vY/L3BPknm88ZOc4ODbQ
         TVm7oFalTHdrMaYxAn4e4E+rVBvmZChDaHCO0wt9fbPjhVtmRwJQQhSBYWTjrKhUjG
         ZovHbY6oOkfIDVz/nj5OBwj6f9T7xqHAMWWgwMtNGJM378KtjIxNnZ6xm1pwL09jj7
         7g7dxLq6fxMULm45lR9gPmVU2BlJa9Y2HlOWVoio1ieqAWW1J+1vnoPArJGECMKAtk
         s0DPHxC5Jhbi0pXwk8R62o/zjPZv3A+2+wAscrXb7r0sAm/WGqVlA0G026LRCkzBn/
         /i7el9ADDl9Hw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 86F3160A6B;
        Wed, 27 Oct 2021 14:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Convert mvneta to phylink supported_interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163534560954.729.2049009139546722506.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 14:40:09 +0000
References: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
In-Reply-To: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 10:03:11 +0100 you wrote:
> Hi,
> 
> This patch series converts mvneta to use phylinks supported_interfaces
> bitmap to simplify the validate() implementation. The patches:
> 
> 1) Add the supported interface modes the supported_interfaces bitmap.
> 2) Removes the checks for the interface type being supported from
>    the validate callback
> 3) Removes the now unnecessary checks and call to
>    phylink_helper_basex_speed() to support switching between
>    1000base-X and 2500base-X for SFPs
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: mvneta: populate supported_interfaces member
    https://git.kernel.org/netdev/net-next/c/fdedb695e6a8
  - [net-next,2/3] net: mvneta: remove interface checks in mvneta_validate()
    https://git.kernel.org/netdev/net-next/c/d9ca72807ecb
  - [net-next,3/3] net: mvneta: drop use of phylink_helper_basex_speed()
    https://git.kernel.org/netdev/net-next/c/099cbfa286ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


