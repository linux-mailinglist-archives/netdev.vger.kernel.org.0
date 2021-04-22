Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B37936885A
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 23:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239666AbhDVVAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 17:00:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:43144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239359AbhDVVAo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 17:00:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A47C613B0;
        Thu, 22 Apr 2021 21:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619125209;
        bh=s7NU8qdrPOgfriAbRCCiePDYddDfGDumpWIxpufv4NY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DEuMgmzo8xjOpfSipahyYuWSBBtJez87dKjvOUIO+9JOcPAoJeUZct69OWmXO0BrL
         ukJVN2+R1qnAFo6aiIbMocy7EDcBsuC/r8dOAv+fi55HhCh/0KDNNMZRpGBV9JQLxD
         vPx5WqYLIAwo5tRZF1iHCVuWH2UYmYimQQSwFh8jz9TFaVki4G6rbsOrlddBW4kUfh
         UnNJaG3bkoOFim4vl6Qk+hEqqEVGBHzkD2cgUHgtqQsPsqw5fWsbhIPaIadUqdy3eP
         ERm/RhldSyi4rWKaTeueaPydOmd3Kwn7nDkk/9zL0qd3Sz202/KNi2XWdkEuTXD09q
         ZKDzog2+KjMRQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 109A760A52;
        Thu, 22 Apr 2021 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [v2] vxge: avoid -Wemtpy-body warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161912520906.6254.10590522923522319652.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Apr 2021 21:00:09 +0000
References: <20210422153543.3378150-1-arnd@kernel.org>
In-Reply-To: <20210422153543.3378150-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     jdmason@kudzu.us, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Apr 2021 17:35:33 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are a few warnings about empty debug macros in this driver:
> 
> drivers/net/ethernet/neterion/vxge/vxge-main.c: In function 'vxge_probe':
> drivers/net/ethernet/neterion/vxge/vxge-main.c:4480:76: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  4480 |                                 "Failed in enabling SRIOV mode: %d\n", ret);
> 
> [...]

Here is the summary with links:
  - [v2] vxge: avoid -Wemtpy-body warnings
    https://git.kernel.org/netdev/net-next/c/3197a98c7081

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


