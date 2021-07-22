Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A393D1F95
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 10:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhGVHTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:19:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230507AbhGVHT3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:19:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DEE2C6121E;
        Thu, 22 Jul 2021 08:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626940804;
        bh=yGwGy4au6+OtEft/DnHyi8DAMWezw97m7rxa7Q1W2Es=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hJD2hsDtkFFyxqKeVeLDcjSzkQ2J5ml/bB7pEYp3+hHSQ2XNupVeY6dlA6Jrk8bxY
         XUnmR55hmYR2SR5udy4hpXK2zYgHZYrJfaCv5fzH1b95JJZg8ksQNthlUVw/xejZky
         BbssGSp+MNsF7B7ICjThKGJFS0zEXeF7xwTNmOPy7bEG574ThebkHF1FGNL7KuelsR
         xW2qnmF4PfqOy3s39aAzpwXVfMh/x5ysmw2KbNtbQbY/PuE0vDXKvyKQzAYQ7Wuj7l
         fcqR9EKyAvhvhkEy5thcCkc4LYqoKeRTbi2IrQluY+jyNADSd6zNmFn/3B+nMPEZjV
         4Nh3KFRwq1Zxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CEFAB60A0B;
        Thu, 22 Jul 2021 08:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: usb: asix: ax88772: do not poll for PHY
 before registering it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162694080483.21125.4350285961898663245.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 08:00:04 +0000
References: <20210722072338.16083-1-o.rempel@pengutronix.de>
In-Reply-To: <20210722072338.16083-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 09:23:38 +0200 you wrote:
> asix_get_phyid() is used for two reasons here. To print debug message
> with the PHY ID and to wait until the PHY is powered up.
> 
> After migrating to the phylib, we can read PHYID from sysfs. If polling
> for the PHY is really needed, then we will need to handle it in the
> phylib as well.
> 
> [...]

Here is the summary with links:
  - [net-next,v1,1/1] net: usb: asix: ax88772: do not poll for PHY before registering it
    https://git.kernel.org/netdev/net-next/c/fdc362bff913

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


