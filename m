Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F14390C91
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 01:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhEYXBv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 19:01:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232019AbhEYXBl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 19:01:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4A5FB61423;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621983611;
        bh=0y2WCCkbUjr91BUTFLYHbgQe2bGnSAdlwjnYLubQQeY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iMJ39ATWcItIiS6wt4GLjokM6rzFkMDfAbf1yMsCCZWpzlzkUJfDlDUJV4QWg0Cwb
         t13qJAgat83CFfbD4ilTBJg2e2kyT2GqhlA4any4MvxlTE0UH1FrGP0ReRgYrUFMGN
         Q7EP0B9UPhzDkxgW33hibj+lr1EYV8tyTOjtbEOyyhafgd4qHnxzdOBbHzWwz2jdpu
         Qny7DjjLxbD5pkEi0sESRfWnJpOH8DFZZ2oFj+1GFKS2l9Ioq8+P2K3BZFE4xj2zMW
         IeML0vnHZXwfdeL0y1Gp9WrDsvvIlBimVimLITRyKR/owAvTVVcaVPy0Oxsqrk1X1+
         /Ok8yMM0o3T7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3DEBE60CD0;
        Tue, 25 May 2021 23:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvpp2: add buffer header handling in RX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162198361124.32227.3046986312931067349.git-patchwork-notify@kernel.org>
Date:   Tue, 25 May 2021 23:00:11 +0000
References: <1621958681-7890-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1621958681-7890-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 25 May 2021 19:04:41 +0300 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> If Link Partner sends frames larger than RX buffer size, MAC mark it
> as oversize but still would pass it to the Packet Processor.
> In this scenario, Packet Processor scatter frame between multiple buffers,
> but only a single buffer would be returned to the Buffer Manager pool and
> it would not refill the poll.
> 
> [...]

Here is the summary with links:
  - [net] net: mvpp2: add buffer header handling in RX
    https://git.kernel.org/netdev/net/c/17f9c1b63cdd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


