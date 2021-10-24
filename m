Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934164388E9
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhJXMw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 08:52:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230021AbhJXMw2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 08:52:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1A02860F46;
        Sun, 24 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635079808;
        bh=mOZuS3QGIBzES8Dx0Aql2CDfswqqCPHIMbhVG7GgPA4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i8u8qshYQz34d7RaO0XKEE+HMDySYhJypF5pW6W1dMHJAZRkEbjZaS6SLil7wJWUL
         INL0gL5fkCnLg6/MHj5dovf9TB5/HP/EfusxDyA5FeERnXpy2YJ7tC1WI8JT8Nw5KF
         V00QSe800qV9Kr3nYJEt1/eN35Ze2OfVvjwTqAR4QfhB64lJGnR53qdPlI8b+PB107
         tWq6UXzZqty3tGvv8l4l6n+2FM55q+I7yiK7J0wnSrkym4mzA61SNSm6q3l7ne1isy
         wezwLa4n1m49bjgoGEzliYcKXYJrFiuKXprEPtcSh4H5hpyHCRqLN/RPX6qKgm0nm3
         oPGaC6yuqjz0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09E5660A21;
        Sun, 24 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Support for 16nm EPHY in GENET
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163507980803.1741.9331261518618602516.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Oct 2021 12:50:08 +0000
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
In-Reply-To: <20211022161703.3360330-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 09:17:00 -0700 you wrote:
> Hi David, Jakub,
> 
> Recent Broadcom STB devices using GENET are taped out in a 16nm process
> and utilize an internal 10/100 EPHY which requires a small set of
> changes to the GENET driver for power up/down. The first patch adds an
> EPHY driver entry for 7712, the second patch updates the DT binding and
> the last patch modifies GENET accordingly.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: phy: bcm7xxx: Add EPHY entry for 7712
    https://git.kernel.org/netdev/net-next/c/218f23e8a96f
  - [net-next,2/3] dt-bindings: net: bcmgenet: Document 7712 binding
    https://git.kernel.org/netdev/net-next/c/f4b054d9bb2b
  - [net-next,3/3] net: bcmgenet: Add support for 7712 16nm internal EPHY
    https://git.kernel.org/netdev/net-next/c/3cd92eae9104

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


