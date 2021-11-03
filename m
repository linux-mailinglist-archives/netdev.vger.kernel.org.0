Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01EC3444318
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhKCOMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:12:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230472AbhKCOMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:12:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D23A6109F;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635948608;
        bh=hggFSzaPL9Vfoh5AYtUTIMLM4CamQwpa8PMm79pGCL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rYmiTyiPab6PocLKWOtTD2R3MPtc2+iK03YB9jT+XMXGgoHuSzUdkkkupJuJRdK79
         W7ex1c492aZFLoWzayzEOGnqhJ+2KQevNbgxxhQQGwZczqecSuOsEXEFlZKYPxhlQk
         NmCsxjVELNDFXEUaWAC7ugC8JmTewUqkZWS7chU5Q8CJEMx33skQWfvI0v5faFe/FR
         bqNUDGmq1Es56/Ku+9rW7TW26LX6m2Ang7IKGAmFrh8TiquZ04m2oPg7PIsUijAxzI
         SMJW1SEm/UeA14q8j3ln81+XJR6h7asb7SORwNX4iOaQUEVlcLcOrbqThoNj4lx6we
         dANtR4DpI+N3Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00EA060A2E;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net:ipv6:Remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163594860799.30241.11173441556750315161.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 14:10:07 +0000
References: <20211103064617.27021-1-zhang.mingyu@zte.com.cn>
In-Reply-To: <20211103064617.27021-1-zhang.mingyu@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhang.mingyu@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  3 Nov 2021 06:46:17 +0000 you wrote:
> From: Zhang Mingyu <zhang.mingyu@zte.com.cn>
> 
> Eliminate the following coccinelle check warning:
> net/ipv6/seg6.c:381:2-3
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Zhang Mingyu <zhang.mingyu@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net:ipv6:Remove unneeded semicolon
    https://git.kernel.org/netdev/net/c/acaea0d5a634

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


