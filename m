Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106562F5930
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbhANDUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbhANDUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E71D52376E;
        Thu, 14 Jan 2021 03:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610594408;
        bh=zL57MA56JYxzyaZCRV6eoxzTZPiLRQd7ZWiXVo6q0Xw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A7TUNBs1vUXvZizv19gv6LUkQnJCPbF2qXEVNfa8AmE1swieaN89NCmTgzWRRuy+e
         poLAK7CV5NPr0Pa3la1lUTjjkIJpSarVQB6hSoaOg0zh63lDBAAH2Z+kBHmn6RReHN
         EJ14j7xa/KjP5Q0Ix1W3Qc2mkSXBFo/yMQRAJJ+okXhh7qSEVN6YykN7GVQAwoDkZy
         hGwVzyqvrdccnm5kUcjgmSxTlwnFNqv6uYtPWnAkuXPMc1uZp3lY5BA51QsW/ucNXP
         /EEUDKN71RzcjPe1JtDu1/r2JOxhQL7uRP6EIjI4Nkt6Y1xH6K7YA72cffKrKUvswn
         p0KeTHSqCHY0Q==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id E1BAD60593;
        Thu, 14 Jan 2021 03:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] octeontx2-pf: Add flow classification using IP next level
 protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059440891.32332.11503603600649559584.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:20:08 +0000
References: <20210111112537.3277-1-naveenm@marvell.com>
In-Reply-To: <20210111112537.3277-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 16:55:37 +0530 you wrote:
> This patch adds support to install flow rules using ipv4 proto or
> ipv6 next header field to distinguish between tcp/udp/sctp/esp/ah
> flows when user doesn't specify the other match creteria related to
> the flow such as tcp/udp/sctp source port and destination port, ah/esp
> spi value. This is achieved by matching the layer type extracted by
> NPC HW into the search key. Modified the driver to use Ethertype as
> match criteria when user doesn't specify source IP address and dest
> IP address. The esp/ah flow rule matching using security parameter
> index (spi) is not supported as of now since the field is not extracted
> into MCAM search key. Modified npc_check_field function to return bool.
> 
> [...]

Here is the summary with links:
  - octeontx2-pf: Add flow classification using IP next level protocol
    https://git.kernel.org/netdev/net-next/c/b7cf966126eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


