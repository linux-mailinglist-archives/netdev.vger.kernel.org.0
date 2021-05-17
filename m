Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDBE386C06
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245043AbhEQVLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235796AbhEQVL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 17:11:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 030E061363;
        Mon, 17 May 2021 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621285811;
        bh=ZfKZpvA/rEXYK0/12kcLIGwPdiBBvHs/p+b9UQEF+vE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XdfaoKrUZ7K1Dt103XVzEd+MiOdS3gkJVu3UmzPr1GbisCRiK5pLP4vgtWNcQ2GXi
         32JxcWAWTZep8SM2Pk71faEI2OwDpGjjOWtG/cnNc5sZxpeQm3K1+KIezxeM37IsyP
         llG1G5wdfIBLMmpY6MLh4mRj7NoQ6s+CjDuiVvTPtdrNvG0MY4lwFtyDAiM2UrcnZH
         AIFjgf1S/Tci4iINh3wh7WEEQGIKxM3Yjly4e9g+q1PqL9EOuOHJE0rmL5kBq1c+zZ
         4DMaitRv7U+/0ymy9krr3tZTNGU1FWYWLMN1gttTH8RCvgvgATYWYHNLNA1XPAyM+6
         yfhYNllpRIyrQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F17AE60963;
        Mon, 17 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: use KBUILD_MODNAME instead of own module name
 definition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162128581098.6429.7368724791106417934.git-patchwork-notify@kernel.org>
Date:   Mon, 17 May 2021 21:10:10 +0000
References: <6f77db90-f26e-a590-bb10-a0ee80c32294@gmail.com>
In-Reply-To: <6f77db90-f26e-a590-bb10-a0ee80c32294@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 15 May 2021 13:53:21 +0200 you wrote:
> Remove own module name definition and use KBUILD_MODNAME instead.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] r8169: use KBUILD_MODNAME instead of own module name definition
    https://git.kernel.org/netdev/net-next/c/7cb7541a8cc0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


