Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D809472E8F
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbhLMOKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:10:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbhLMOKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E6D6B8101D;
        Mon, 13 Dec 2021 14:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5554AC34603;
        Mon, 13 Dec 2021 14:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639404609;
        bh=UNa3dpq/wtvhk7C6k2oxX+9bls4v7c/11I8U0EAfJMU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lLxGr9jXVPfu1vkSU/sDvI8Yb6Wi0bas78zYCJSEoJnxqybTOFiJFsduElNxmIQRr
         3J6gn3Jd61KFVQSqgBcRCQNZL/bALNeX3meClr1e4tB+Za/fcV6lJ5Cu8RwAetz+ir
         FyO/n4i4jQx5wnTNBbHOCiOWT3XT6a1Ngiaeew0hePkfZgJm8RpNgpO4RYSlmqWewO
         lvzT1WkreHLdYW57Xo3Vr9q0YSGLAjBVI8AF86JIoiAcEwp3vA+DQaxz33BmhAvqEA
         GtRLxw5zn3TMkdrfqk7aDAOR1FUpx9U3NP4D4ShNtQvdMw6E7C4EdprkIM4RdRiHOT
         1/YbJWwQG50Ug==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F9BE609F5;
        Mon, 13 Dec 2021 14:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: cpai: no need to initialise statics to 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940460925.1592.960086415569174532.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:10:09 +0000
References: <20211212071204.293677-1-wangborong@cdjrlc.com>
In-Reply-To: <20211212071204.293677-1-wangborong@cdjrlc.com>
To:     Jason Wang <wangborong@cdjrlc.com>
Cc:     isdn@linux-pingi.de, arnd@arndb.de, davem@davemloft.net,
        butterflyhuangxx@gmail.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 12 Dec 2021 15:12:04 +0800 you wrote:
> Static variables do not need to be initialised to 0, because compiler
> will initialise all uninitialised statics to 0. Thus, remove the
> unneeded initializations.
> 
> Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
> ---
>  drivers/isdn/capi/kcapi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - isdn: cpai: no need to initialise statics to 0
    https://git.kernel.org/netdev/net-next/c/2cd24a2e8d8c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


