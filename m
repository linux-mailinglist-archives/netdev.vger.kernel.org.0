Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E70A2E17DC
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbgLWDus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 22:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727209AbgLWDus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 22:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C7F5B22473;
        Wed, 23 Dec 2020 03:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608695407;
        bh=ds1ORr7i1CqskDuDX1Hrvb7l+j48/LqF/NxlGviVwXA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AW/qTdejhY1MHZtZ7qhFfDJgUBCqim7g3idmc9G3oZokcJBt90XTdF+4xB9l2z4a7
         ZiDoZpYK5pWKDC9Z7HZq/Imp3l32xOELawOiIqJXFd744VFrnWh/Wm5jvmYZQ18oov
         45qPkthkFnvVgyNwjesp7Qs8OzplVjOh3YtjIaqn6yGJP3zAEm2MIIA3eXuVyUV0Tj
         OCpXdezX1ft4Nnn33lquw6Q+ix9q9ZKNCyGnOFMd/xyaFH/NEq/V8sVU/YoZ1ginfs
         JbYCv39ueoJ3VJfeJO86rsTQFXIIF4BvQ28mFXAcuf9M+Oyy1tv3NX0w/OGQUNeTrx
         +M8sZZVLL+QgA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id B9283600EF;
        Wed, 23 Dec 2020 03:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] qede: fix offload for IPIP tunnel packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160869540775.24460.248179041518337563.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Dec 2020 03:50:07 +0000
References: <20201221145530.7771-1-manishc@marvell.com>
In-Reply-To: <20201221145530.7771-1-manishc@marvell.com>
To:     Manish Chopra <manishc@marvell.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, aelior@marvell.com,
        irusskikh@marvell.com, skalluru@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 21 Dec 2020 06:55:30 -0800 you wrote:
> IPIP tunnels packets are unknown to device,
> hence these packets are incorrectly parsed and
> caused the packet corruption, so disable offlods
> for such packets at run time.
> 
> Signed-off-by: Manish Chopra <manishc@marvell.com>
> Signed-off-by: Sudarsana Kalluru <skalluru@marvell.com>
> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,1/1] qede: fix offload for IPIP tunnel packets
    https://git.kernel.org/netdev/net/c/5d5647dad259

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


