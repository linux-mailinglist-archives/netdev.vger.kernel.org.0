Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C334A56F2
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 06:30:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbiBAFaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 00:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiBAFaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 00:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79414C061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 21:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E81F61488
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 05:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81FA4C340F0;
        Tue,  1 Feb 2022 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643693410;
        bh=tRxrbnTXpB0XenW/11N4OEG+g0k9x9NbeFDG6FAwU7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SuXpySVXE6VeOlByu6wnmZaa9kcdko3GFOal2IeSC6SXoqmyid3HCOZAraEaY/GOE
         9NSCj/FNn/AWYyLdXKePzgs0d2ScwVRLqhfgVS6/6Xuswc7QkoZ2VJAPCz7PvcHzaK
         Vw1gZhQ3XMjieTMB2ADTTPeQPDZCXemL2XyBFDZPHqHMPnfANreGOgdPxm1C0ALFDU
         tJjpO6WuG7gF+xdk/9RIE++KzPqQtM2mnhqgcpl4N5TfKCcxxABWRwToiEvja0RAYb
         RICCKbsUCC3n853J4dknT0ypgtSxFcFN7ac83Ni0j0ahMpLn14KSdmCVd2HUhEBgMx
         jXvDmIWhdH2Dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 614CEE6BB3D;
        Tue,  1 Feb 2022 05:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: mt7530: make NET_DSA_MT7530 select
 MEDIATEK_GE_PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164369341039.4704.13917567478753017615.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 05:30:10 +0000
References: <20220129062703.595-1-arinc.unal@arinc9.com>
In-Reply-To: <20220129062703.595-1-arinc.unal@arinc9.com>
To:     =?utf-8?b?QXLEsW7DpyDDnE5BTCA8YXJpbmMudW5hbEBhcmluYzkuY29tPg==?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, dqfext@gmail.com,
        neil@brown.name, erkin.bozoglu@xeront.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 29 Jan 2022 09:27:04 +0300 you wrote:
> Make MediaTek MT753x DSA driver enable MediaTek Gigabit PHYs driver to
> properly control MT7530 and MT7531 switch PHYs.
> 
> A noticeable change is that the behaviour of switchport interfaces going
> up-down-up-down is no longer there.
> 
> Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: mt7530: make NET_DSA_MT7530 select MEDIATEK_GE_PHY
    https://git.kernel.org/netdev/net/c/4223f8651287

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


