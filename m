Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCC8349DCB
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbhCZAaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:30:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229984AbhCZAaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA45A61A45;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718610;
        bh=mtNKwEDj2i+9zjHQgOt+IwVVz5Cty2kpMZocaxeQOpQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ilMpRZ1i1kDu+rJwGJP8ojgcjYqI4BlUahk949oXYdjfb8rY5lyHDJQo0sJdiN8Cv
         f+19l2bbWX3Tm7cXG0OanCPvTSUn2R3A35FzYVCbwXZL2h9yvPGbDFww3x6T3KQWCv
         F3LPHm6JxI5TKx4IpQTIaPuUn1gzyKGzMOlZYu3RxlXBXic5tA3l6OQ7pJUj/olFyB
         xpP2z2hZIuao6A1zjQhSe5gW2Nmpvgb2QZWqSliDiydVekzlpg9PuKocndmkmL41dl
         OxKeDbDoq9PQAjjWSjCxIgI6185AaKCFVccfZKLMAVyaJRA6QFPPD359NKiYF2w/Ip
         AXqI7cr8RhLsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9C637625C0;
        Fri, 26 Mar 2021 00:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: lantiq_gswip: Let GSWIP automatically set the
 xMII clock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671861063.2256.3129644710566054150.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:30:10 +0000
References: <20210324193604.1433230-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20210324193604.1433230-1-martin.blumenstingl@googlemail.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     hauke@hauke-m.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 24 Mar 2021 20:36:04 +0100 you wrote:
> The xMII interface clock depends on the PHY interface (MII, RMII, RGMII)
> as well as the current link speed. Explicitly configure the GSWIP to
> automatically select the appropriate xMII interface clock.
> 
> This fixes an issue seen by some users where ports using an external
> RMII or RGMII PHY were deaf (no RX or TX traffic could be seen). Most
> likely this is due to an "invalid" xMII clock being selected either by
> the bootloader or hardware-defaults.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: lantiq_gswip: Let GSWIP automatically set the xMII clock
    https://git.kernel.org/netdev/net/c/3e6fdeb28f4c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


