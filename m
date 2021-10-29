Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631EC43FB62
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhJ2Lcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:32:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231815AbhJ2Lck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:32:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A036A61166;
        Fri, 29 Oct 2021 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635507011;
        bh=U2Zb68iWFYNVlfwRQz2sSvS3/Q/B00b1jdDiVYiQ6+g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dMj6feIn1u8DlBd4XCvPloI6nS6NEzA4nz9LVr1uWm/aIQjInOucf1sRXDJQkI1Aj
         seq5p03+DX4ubo+FN9dzyic1qA8XvRz/wJ4mBg1uqadLkhkVd5apo3E53H44kN79Om
         VRoh7ts9huuUwt/F6fAMeXJY+BgWVbgKBonv/OGuVXVBijIHqdW+QvIhFDq8LgTbFe
         vddnVJAhOnTTKygxu5IEtAsD8pKARr1qJwLqMe9fmLAqGBLllzl7CU/ag2lMZP8E/C
         mPmB671QggxG3NfLZOQGx65qNtfltitl2yGg9xzMsF2Tt0gWAZH0JkgiFSIWbW1QJO
         JDQm4CBXyN2hA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 973A660A1B;
        Fri, 29 Oct 2021 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] net: lantiq_xrx200: Hardcode the burst length value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163550701161.27301.7742022957993105556.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 11:30:11 +0000
References: <20211026205902.335936-1-olek2@wp.pl>
In-Reply-To: <20211026205902.335936-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 22:59:01 +0200 you wrote:
> All SoCs with this IP core support 8 burst length. Hauke
> suggested to hardcode this value and simplify the driver.
> 
> Link: https://lkml.org/lkml/2021/9/14/1533
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/net/ethernet/lantiq_xrx200.c | 21 ++++-----------------
>  1 file changed, 4 insertions(+), 17 deletions(-)

Here is the summary with links:
  - [1/2] net: lantiq_xrx200: Hardcode the burst length value
    https://git.kernel.org/netdev/net-next/c/7e553c44f09a
  - [2/2] dt-bindings: net: lantiq-xrx200-net: Remove the burst length properties
    https://git.kernel.org/netdev/net-next/c/0b3f86397fee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


