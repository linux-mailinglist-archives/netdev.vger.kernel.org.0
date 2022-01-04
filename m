Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50083483AEB
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiADDUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiADDUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:20:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 638D7C061761;
        Mon,  3 Jan 2022 19:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BC04B81115;
        Tue,  4 Jan 2022 03:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1C44C36AF3;
        Tue,  4 Jan 2022 03:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641266408;
        bh=4jwxRCNqPtC4VzdME2SM3zcSAs4vIbhinHJiJjfxbl8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cWgmKVCgSLgCnZTTIX8l4BE/kiflqLc1mGTSOUaepdbcyQIbe6NECJBTSvvFKtTbR
         3xc09DmLN/3cP3Nabf6HMZbYruMwmIBtDWFWb7v66ahrT4TqSN4dvdt/f9PzFCNeAB
         J1L6fAKT1tVinPswB6ZCffO1JAeJd+xuRjTwbaXFGHPfOI3/YWzGQUL2iMd1k0P2Y1
         /hJJBGrS584O4cvEpiI5ZbMd688Yaue30r06XZoDeTphoRGMLpvGDGsxvLQJONDzfV
         ncFqR5b9tdJZygSc+QcMahemvWYDT5Ousa7kbn9hFyMbRXAnPBkDrcHgC0026DLNDF
         HxGVxdhK/VPgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CF45EF79408;
        Tue,  4 Jan 2022 03:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mdio: Demote probed message to debug print
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164126640884.16037.17897337774748931733.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 03:20:08 +0000
References: <20220103194024.2620-1-f.fainelli@gmail.com>
In-Reply-To: <20220103194024.2620-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, mbizon@freebox.fr, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  3 Jan 2022 11:40:24 -0800 you wrote:
> On systems with large numbers of MDIO bus/muxes the message indicating
> that a given MDIO bus has been successfully probed is repeated for as
> many buses we have, which can eat up substantial boot time for no
> reason, demote to a debug print.
> 
> Reported-by: Maxime Bizon <mbizon@freebox.fr>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: mdio: Demote probed message to debug print
    https://git.kernel.org/netdev/net-next/c/7590fc6f80ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


