Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804DC37037E
	for <lists+netdev@lfdr.de>; Sat,  1 May 2021 00:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232110AbhD3WbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 18:31:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231392AbhD3Wa7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 18:30:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1D2AB613FA;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619821811;
        bh=TGM31Ru/c+GB9ZUIhECbjAL0n7ZSpeN8miiDo2T92n8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qWJ57t3TVdiUS0uBO+sS0+nWIEnbyRdjBJhoA0Y4/4wiXdaZ4g2XTttL3ebF1jm9i
         Z37VJYbmIFO2DnrPU9Huvg/qRoyFCdzY5AGzuKdyzyAZ85dBwuUCuXRsBTsapaAWAf
         5e5jEK6oCvfaSuqOjwRFOsLkgWMZewmRythQcm4fUCbr2x7eHMVeCX+MdStUTBtBD+
         I+HDuYmFsyejrMbAKQSm/GS1+VVi717XMwOciIp3vxlG1VAFNbowDQ7Y4abnKfnEC8
         RF3fdt6e8/jMCvK1FZ518J6FbKN6dKrUfrkX6wWLSoudbleM0F5nz36sgUNP4WA6yl
         wdaPVd7TjbClA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BC9B60BE1;
        Fri, 30 Apr 2021 22:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atheros: nic-devel@qualcomm.com is dead
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161982181104.1234.2370001708203672273.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Apr 2021 22:30:11 +0000
References: <20210430141142.28d49433b7a0.Ibcb12b70ce4d7d1c3a7a3b69200e1eea5f59e842@changeid>
In-Reply-To: <20210430141142.28d49433b7a0.Ibcb12b70ce4d7d1c3a7a3b69200e1eea5f59e842@changeid>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, chris.snook@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 30 Apr 2021 14:11:42 +0200 you wrote:
> Remove it from the MODULE_AUTHOR statements referencing it.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/ethernet/atheros/alx/main.c         | 2 +-
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: atheros: nic-devel@qualcomm.com is dead
    https://git.kernel.org/netdev/net/c/a57d3d48366b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


