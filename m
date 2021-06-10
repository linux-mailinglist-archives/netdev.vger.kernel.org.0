Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317733A361D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhFJVmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:53116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhFJVmA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:42:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E693661404;
        Thu, 10 Jun 2021 21:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623361203;
        bh=DqvyanUSUta0zhepbu/Qz9brzJzc/+zi2f7ya+LYOrQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MybPu+i0XVFFPHII+DrnYklomvzDoVX4d5DrIabKeuOMNgAz2zAr+JiFS7/vSEmL3
         pgo4rOzExn5D5bFMQaWE2yo7QXHnj2VMHEdr4VEHhsxzJ+0IA34kmBkFW642OTWRMT
         2LsxwMqAlQ9heAABSdvL8XoAgVp13XFZCeC7+0S8N4Nn1zC8mAQb7fALWvq4rwmtqL
         3Iwt1J+MMooOlnqmFhSlfChON/keo6dZUzPN56uaKJemW8hc5IiaiSuExAYI95X0nW
         998Pl7vkdW09Il02/2owPsBh/eILLJdTOQzQaorC6+h3UWFTAGgwWFF8A+vULdGIvU
         3qtJnY8BOC6Tw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D7E4860A0C;
        Thu, 10 Jun 2021 21:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] net: marvell: prestera: add LAG support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162336120387.23488.3813450632962016615.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:40:03 +0000
References: <20210610154311.23818-1-vadym.kochan@plvision.eu>
In-Reply-To: <20210610154311.23818-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, olteanv@gmail.com, tchornyi@marvell.com,
        linux-kernel@vger.kernel.org, mickeyr@marvell.com,
        vkochan@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 18:43:08 +0300 you wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> The following features are supported:
> 
>     - LAG basic operations
>         - create/delete LAG
>         - add/remove a member to LAG
>         - enable/disable member in LAG
>     - LAG Bridge support
>     - LAG VLAN support
>     - LAG FDB support
> 
> [...]

Here is the summary with links:
  - [v2,1/3] net: marvell: prestera: move netdev topology validation to prestera_main
    https://git.kernel.org/netdev/net-next/c/3d5048cc54bd
  - [v2,2/3] net: marvell: prestera: do not propagate netdev events to prestera_switchdev.c
    https://git.kernel.org/netdev/net-next/c/82bbaa05bf90
  - [v2,3/3] net: marvell: prestera: add LAG support
    https://git.kernel.org/netdev/net-next/c/255213ca6887

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


