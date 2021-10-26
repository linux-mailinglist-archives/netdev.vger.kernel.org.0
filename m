Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B94F43B37F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234809AbhJZOCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:02:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:38144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233610AbhJZOCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:02:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B689360C41;
        Tue, 26 Oct 2021 14:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635256807;
        bh=5eCrDYan07vhpP+0wQldexIDEWxqmH/iM3ek9AjHNXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pZ/gvoym5Bg8UmgBU5/iiSDI19q6TxXFjEhqs9qnymy/fs3DAoEdLlDqE0xNsFrNO
         6VqhssIfOPZ9FB6ZzXlysJEceMFT3R85JQ1eG7LEFEbuxZNRCxGHps/1pl8wDBGl1Z
         a2p7j6sbMpN4Mdcm27PghJN6ZkRn0FH8PIU6x//8pGOhLRVg4YbewxSGHgUbIndFsg
         f9EQ1axxiCEptX12vPCKWtOBvHdn4gbfIudwMFHYbJVpQtYmTn4glYpLFtY+wcPIoj
         uz53fKH10ao8cRjRNLo5IzK39A7BQYMJFkYRxtl4q0gyb0ivIkojRGH9el9wxe2zWh
         1HY2Tj/Ul2dzg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AABB4608FE;
        Tue, 26 Oct 2021 14:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: hsr: Add support for redbox supervision
 frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525680769.8133.16749600248538589809.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:00:07 +0000
References: <20211025185618.3020774-1-andreas.oetken@siemens-energy.com>
In-Reply-To: <20211025185618.3020774-1-andreas.oetken@siemens-energy.com>
To:     Andreas Oetken <ennoerlangen@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, m-karicheri2@ti.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andreas.oetken@siemens-energy.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 20:56:18 +0200 you wrote:
> added support for the redbox supervision frames
> as defined in the IEC-62439-3:2018.
> 
> Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
> ---
>  net/hsr/hsr_device.c   |  8 +++---
>  net/hsr/hsr_forward.c  | 54 ++++++++++++++++++++++++++++++++-----
>  net/hsr/hsr_framereg.c | 61 ++++++++++++++++++++++++++++++++++--------
>  net/hsr/hsr_main.h     | 16 +++++++----
>  4 files changed, 113 insertions(+), 26 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: hsr: Add support for redbox supervision frames
    https://git.kernel.org/netdev/net-next/c/eafaa88b3eb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


