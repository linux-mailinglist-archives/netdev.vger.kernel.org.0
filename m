Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD53044BA9A
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 04:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbhKJDW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 22:22:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230072AbhKJDWy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 22:22:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 68BB6611F0;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636514407;
        bh=VpR44dTrkcaXLE8qdOsmP1iB+85GnjPx/0KzfMS41cg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cMYRhMsPz2kguXtytQY8EKyVXSBZdcv+gaHTVxIUPxFVUaYzLyE3NYlW/5Um1ej4f
         sIMS5Zgs6hiDXegzoWqe9lNhk8wIey1QMZ3M7QdGv/emcN83Se93OPdhJJvJKU4hul
         AMojr0QMih1Q3HCuh2fmaRQX5Ospgd61bSpe1Qp0UdcjZAqTTJuEDPQPhwI2oxnpq/
         ZrBBiShOd1pXBdM7NciuYcdX82MR7lPf1l/qR9ii9SVAFT50MRB2TW4WEdvK2kwJqi
         fMqSwFPTRcLkRij2ZYNsRiHlC9FOQRDMkmJsK0TyPbpoSD9zcVa1bCWyPK0keXBwBM
         lLi9+h1w6bBTA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5805260C16;
        Wed, 10 Nov 2021 03:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mana: Fix spelling mistake "calledd" -> "called"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163651440735.9008.13490903689455825082.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Nov 2021 03:20:07 +0000
References: <20211108201817.43121-1-colin.i.king@gmail.com>
In-Reply-To: <20211108201817.43121-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@googlemail.com>
Cc:     kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, decui@microsoft.com, davem@davemloft.net,
        kuba@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  8 Nov 2021 20:18:17 +0000 you wrote:
> There is a spelling mistake in a dev_info message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/ethernet/microsoft/mana/gdma_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: mana: Fix spelling mistake "calledd" -> "called"
    https://git.kernel.org/netdev/net/c/8f1bc38bbb51

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


