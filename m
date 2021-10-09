Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1120427A49
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244802AbhJIMwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 08:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232889AbhJIMwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 08:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C006B60F9C;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633783807;
        bh=haXnO14IGsa93sWz6h2+QuE+P9xt4Bqwpq3fk4091Qs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HmGd23No41gcgY4VzgmY6o+vjj1jg5VVOeMoU/5i8MDOYX0VLtWWrCvlQ2jxE+cjV
         av1Sz53bzDGWaqKDe0fJzelYZfzlQ1vhncwXI2hPxK6xnqnDjbz39ypmgtBBHrv3B8
         rXT+JHUGKTngbORMzy5URJ27VLsK8+Q+N2ljCdhmSg+pxP/iLAiCm7YhKTDqHf427+
         2S8vN2P8MmM/hwccHKdL8GdQExKJ8PKuePs6BZrwt6FiN/CkJJ4n1Fj4HotCnUdvpE
         Gk0SzhO/s97NdS+AvHLGgT2DdCTIFVjAqNGU2AHDktDTshQf7nhunxLGLUnk7KpJo2
         x0DINoQqXMmeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0E8A60985;
        Sat,  9 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: mISDN: Fix sleeping function called from invalid
 context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163378380771.3217.9605456764166004221.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 12:50:07 +0000
References: <1633779229-20840-1-git-send-email-zheyuma97@gmail.com>
In-Reply-To: <1633779229-20840-1-git-send-email-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     isdn@linux-pingi.de, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  9 Oct 2021 11:33:49 +0000 you wrote:
> The driver can call card->isac.release() function from an atomic
> context.
> 
> Fix this by calling this function after releasing the lock.
> 
> The following log reveals it:
> 
> [...]

Here is the summary with links:
  - isdn: mISDN: Fix sleeping function called from invalid context
    https://git.kernel.org/netdev/net/c/6510e80a0b81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


