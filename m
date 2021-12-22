Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3B347CAA7
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 02:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240450AbhLVBKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 20:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbhLVBKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 20:10:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6280C061574;
        Tue, 21 Dec 2021 17:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D2EB617F5;
        Wed, 22 Dec 2021 01:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACFA0C36AEA;
        Wed, 22 Dec 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640135409;
        bh=CecTfUmf8TIQrryKxJvEoixHMdRyA+0xeBp57+KFaYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Emed/IlBLNFScBYLwNzFiyIu0LObTk+xdkrgkGob6e4XkVZgDFql8q7cz4FX8FoAw
         fFaJ5OORrvxkPxPz/nBGDcDqqk2Hbs083NsDNttrcwWWvI2CFo5PTBlRy0yzzIMmGL
         no4HeAxlv+Jsk364IYMEp/u3DIb0Tfv4shELhxFfgVG+zoKo0RgQMI4X1ris80fR2z
         T2vPPycv3piUeD/FoF7p5CvH2nIDgcW02/wdhWN/vCXn4vWkeSJ6Mhw9w36+bF151h
         0FKc0PCKIQLNh/PttwfNiXT+f7BHpgZIDUqGoTs/tSpsAwl4eVGIer5MpPqnWbSaXm
         /k6OPZGaFpKcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A0B6609CC;
        Wed, 22 Dec 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: phy: micrel: Adding interrupt support for
 Link up/Link down in LAN8814 Quad phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164013540956.23759.13036546211941665945.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 01:10:09 +0000
References: <20211221112217.9502-1-Divya.Koppera@microchip.com>
In-Reply-To: <20211221112217.9502-1-Divya.Koppera@microchip.com>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Dec 2021 16:52:17 +0530 you wrote:
> This patch add support for Link up or Link down
> interrupt support in LAN8814 Quad phy
> 
> Signed-off-by: Divya Koppera <Divya.Koppera@microchip.com>
> ---
> v1 -> v2
> * Defining Common Macro for Control and status bits of
>   Link up, Link Down and sharing them across Interrupt
>   control and Interrupt status registers.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: phy: micrel: Adding interrupt support for Link up/Link down in LAN8814 Quad phy
    https://git.kernel.org/netdev/net-next/c/b3ec7248f1f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


