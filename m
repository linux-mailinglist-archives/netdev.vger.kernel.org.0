Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F6C3F3EC7
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 11:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233013AbhHVJAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 05:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231147AbhHVJAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Aug 2021 05:00:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A0C8561214;
        Sun, 22 Aug 2021 09:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629622806;
        bh=tqyKEBu6eyfrfiUAs4OFJ02EHPoIcX+EgcGHAtU8EzY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UbWhebOvDhbPKl/sJrr0iG2B2GA6GKgA16lT6ZfpuWiuR7ut/VPJf6Pm7B60ha9NA
         ASn/AYHp6Tqq8A88gQBIlEWXhfK8+mT8IUM2P2bi7gjixP6bKUa+lBbNOcVMNNqIzp
         owrhybVySIjUUHHxhy6MeYyiXWQ8ac3OsECGw8AbWNXR+Vz/3RLrukWJr6xanaJy1Y
         0ZLtdxXaEcGXybY/PJQMAX4NpH4g3Y/XChsACRn9V8FqplxYmZKQn4z2dM4AXXkOi7
         pXvrkHPhNXKovCMvmY/d6TRlBZPqC9OeW6XsmMP7eQ6JS2t9stBMZRgB0vPXGKyLrF
         QD8Ox5evBZYfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 950D760A4F;
        Sun, 22 Aug 2021 09:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] DSA documentation updates for v5.15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162962280660.32226.8322314623130550086.git-patchwork-notify@kernel.org>
Date:   Sun, 22 Aug 2021 09:00:06 +0000
References: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 22 Aug 2021 02:04:37 +0300 you wrote:
> There were some documentation-visible changes made to DSA in the
> net-next tree for v5.15. There may be more, but these are the ones I am
> aware of.
> 
> Vladimir Oltean (4):
>   docs: devlink: remove the references to sja1105
>   docs: net: dsa: sja1105: update list of limitations
>   docs: net: dsa: remove references to struct dsa_device_ops::filter
>   docs: net: dsa: document the new methods for bridge TX forwarding
>     offload
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] docs: devlink: remove the references to sja1105
    https://git.kernel.org/netdev/net-next/c/27dd613f10f2
  - [net-next,2/4] docs: net: dsa: sja1105: update list of limitations
    https://git.kernel.org/netdev/net-next/c/5702d94bd901
  - [net-next,3/4] docs: net: dsa: remove references to struct dsa_device_ops::filter
    https://git.kernel.org/netdev/net-next/c/37f299d98989
  - [net-next,4/4] docs: net: dsa: document the new methods for bridge TX forwarding offload
    https://git.kernel.org/netdev/net-next/c/95ca38194c5a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


