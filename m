Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA91A42401C
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238749AbhJFOcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhJFOb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 10:31:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A99AC610A3;
        Wed,  6 Oct 2021 14:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633530607;
        bh=4pYwma9lTkngKeJYzw/+Yu1H3cwK5ZwsCxpHurRv0iI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dnp1XYvRaJZH0Qp/+LVUW3onM4IYNovk6XeJErj8VNzYAPZkGkKL7nJ7bT1r9Pk/K
         MlVNm+NQAtRpXx9cMCVm/wUtXtQr8YJ7SsMe7GgbfpZjHz5exNAaPbbRwtQtDG3Bwc
         ceJGPit3wvqWh6vdkxrqWVDRBVhGnmnTesx5NPVgcbSUQq53fhxSZEHfFU/7LsZxIg
         NG0CiIV5bCsv7vWbBf213/NXfY9IezlY8zcmag8gRzq5/nYIA9ZHyGhRFnDhQe9bVe
         atPb/na+f42zeR5oLExHQqv9U9GqiN2X6f0Jih1QfcdCRRTqnDEKzsXkx+xKxukxgh
         Z1vDqgWqkElMQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9B82260971;
        Wed,  6 Oct 2021 14:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dt-bindings: net: dsa: marvell: fix compatible in example
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163353060763.19239.10775956960953115345.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Oct 2021 14:30:07 +0000
References: <20211006063104.351685-1-marcel@ziswiler.com>
In-Reply-To: <20211006063104.351685-1-marcel@ziswiler.com>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, frowand.list@gmail.com, kuba@kernel.org,
        robh+dt@kernel.org, vivien.didelot@gmail.com, olteanv@gmail.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  6 Oct 2021 08:31:04 +0200 you wrote:
> While the MV88E6390 switch chip exists, one is supposed to use a
> compatible of "marvell,mv88e6190" for it. Fix this in the given example.
> 
> Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [v2] dt-bindings: net: dsa: marvell: fix compatible in example
    https://git.kernel.org/netdev/net/c/a50a0595230d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


