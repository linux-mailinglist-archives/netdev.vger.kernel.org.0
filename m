Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9550472EDB
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 15:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhLMOUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 09:20:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:35250 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239060AbhLMOUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 09:20:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 534F0B81071
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 14:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2239AC34606;
        Mon, 13 Dec 2021 14:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639405230;
        bh=Av3S80W0fvy6wnzWO32z5CViNO3WtbiDhhNpq9nRZrY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PsiQdnPyjJC9eFtu0hjace+6N49OyPxACtUSW3KT50XzH5EgXTQZeIAen28JvmWZ1
         w89eM2TAQ4enCRS+L6SlJoB/+8ydIJ1o1Hvqa5Qvu8cigut0B3XwzzgSGhtehLDSlp
         iFgtsbEcmOU0QpdQjoEeQygB3p5Q3FR07ZiacqV6l26NBYEoNIo3jFCE+h1MAtDttX
         44LVzMmEeCYNlrLF+gO7xCP7ftVcAF9MFxIx/Vl1ETsBI8rYxLEoDF9Nb0N47KSA1P
         sCtk7EfOVkrd7znMv/G4i/qTGK2b3SLhah5EqLwxcckNLgYdCy2t25m2FIBPB2aEFp
         k4f1WBmtwDPkA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 121D36098C;
        Mon, 13 Dec 2021 14:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mvneta: mark as a legacy_pre_march2020 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940523006.6863.12507640601955680015.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 14:20:30 +0000
References: <E1mwOTh-00FHge-1K@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1mwOTh-00FHge-1K@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, kabel@kernel.org,
        thomas.petazzoni@bootlin.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 12 Dec 2021 13:01:21 +0000 you wrote:
> mvneta provides mac_an_restart and mac_pcs_get_state methods, so needs
> to be marked as a legacy driver. Marek spotted that mvneta had stopped
> working in 2500base-X mode - thanks for reporting.
> 
> Reported-by: Marek Behún <kabel@kernel.org>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mvneta: mark as a legacy_pre_march2020 driver
    https://git.kernel.org/netdev/net-next/c/2106be4fdf32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


