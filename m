Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 419BD30E7AD
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 00:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233915AbhBCXlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 18:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233830AbhBCXks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 18:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id EC29664F6A;
        Wed,  3 Feb 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612395608;
        bh=q9BxotSLBBSN8u2Vr9VcUeYX7bXPSF7tTXaw7RBTLS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IuBHEyptqLsCyt1jR6LYEDFASPrbvnNcPL6EA0komEblBWgokNoHNOZn9+ER76eAx
         roky4DXNtDHJYXd8bE4xFNomHoHtZAqCV+wrllbXg1Dr9U/UU66HgaYTwkSI18Ygyk
         gqwdi74zogtRLaRGWIjoYSYU2TLMbowAyT8o7vDjvPfuf/Unh1xZEnqQMgtrB0+xoV
         BjKjIe9OmRyEvFaulTIA/muOCqBM32sqRY1uZwgKOvrc2tyqDzY1FvAprg38rXO61W
         SqMZUOHarLxFZvVvJeVldmKRaZl1i5S6ykKR03rnkanPdLYWZgXxDS/StiBmH00jU+
         ThiWbc6GWyObg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0D83609E3;
        Wed,  3 Feb 2021 23:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: cdc_ncm: use new API for bh tasklet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161239560791.28685.2748394162925651238.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 23:40:07 +0000
References: <20210130234637.26505-1-kernel@esmil.dk>
In-Reply-To: <20210130234637.26505-1-kernel@esmil.dk>
To:     Emil Renner Berthing <kernel@esmil.dk>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 31 Jan 2021 00:46:37 +0100 you wrote:
> This converts the driver to use the new tasklet API introduced in
> commit 12cc923f1ccc ("tasklet: Introduce new initialization API")
> 
> It is unfortunate that we need to add a pointer to the driver context to
> get back to the usbnet device, but the space will be reclaimed once
> there are no more users of the old API left and we can remove the data
> value and flag from the tasklet struct.
> 
> [...]

Here is the summary with links:
  - net: usb: cdc_ncm: use new API for bh tasklet
    https://git.kernel.org/netdev/net-next/c/4f4e54366eae

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


