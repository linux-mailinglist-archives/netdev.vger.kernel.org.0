Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1439217F
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 22:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhEZUbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 16:31:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232133AbhEZUbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 16:31:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C60D9613CA;
        Wed, 26 May 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622061010;
        bh=nN00/yFHXBNMQgtkZ3C3rRit1UOv3raHwCdgBXMZ0Jw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G76CEo+LTtXCUb5xd0oCmS3PXKxhaIRlr9RumF1O1j92qhZRi4OEW1ZR7RYhIsOcE
         nmDvdSJf/iOOMy3S9+SHHEKoK5XetGg5fvT3ykBrp9YsNSjv1uBVXIP5U8Fn4dewSU
         GUmsSAOmw+pfQkx/WQRy84FWL04illYpt+mlbTfuRmg7w3CFkjRyyPhWhGvcfbwNRz
         QfloFmQ5aNH89IH2s8SFAVs2MvLsRPKRucibxhg+RzLSKkbvi/VVfCCzfjnMZrYig7
         qrVNa2ZZH++vuncyfY0SHksKSXem1PZbxAJazvZ3W0afcjDjXpsNMHx+mViD+IVkxS
         sQruLNuQuyKxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B47D160BCF;
        Wed, 26 May 2021 20:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: Document phydev::dev_flags bits allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162206101073.6955.4244083455923658120.git-patchwork-notify@kernel.org>
Date:   Wed, 26 May 2021 20:30:10 +0000
References: <20210526184617.3105012-1-f.fainelli@gmail.com>
In-Reply-To: <20210526184617.3105012-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, olteanv@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 26 May 2021 11:46:17 -0700 you wrote:
> Document the phydev::dev_flags bit allocation to allow bits 15:0 to
> define PHY driver specific behavior, bits 23:16 to be reserved for now,
> and bits 31:24 to hold generic PHY driver flags.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  include/linux/phy.h | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [net] net: phy: Document phydev::dev_flags bits allocation
    https://git.kernel.org/netdev/net/c/62f3415db237

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


