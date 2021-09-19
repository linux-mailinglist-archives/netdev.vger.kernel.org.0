Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D04410B79
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 14:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhISMLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 08:11:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:42516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhISMLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 08:11:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6374A6127B;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632053408;
        bh=tJpTymouqGkRGzxlt+rfk0Az13JptJoFnLz5XQqwGTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=To2lJkyu0XseE5GxrnKg3izcq/Cr4MTii5vd/ROZG3VEFtvcEfGogTkDPldvdFzmY
         O9srd4MoigzKd/Kfbi9x4NAg53iVDcploCtyB29UA1PGyjCMkreG5+OYlbJktUNwTQ
         XRuh78zmDMfFL1Lmgv/DYeQeubBxtWr0jZNGE8k0jmPe0SAAompSFSmacvdtb0ePAm
         j4NQ9kT6yQdjgSAIWUYNnoBRDiMfXchhQ2SuVnlXM4Mk08hyOEWvZFv8g7WOIPgrnh
         Mnzfv3afMNHBpMP4YmlkOLpDL/dQVpOt/TKgHXjre857NT7Q0a5KI5Wgt8vz/DgZ5O
         WioaxXPwp+7Vw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 47EA660A37;
        Sun, 19 Sep 2021 12:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net 0/2] ocelot phylink fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205340828.3254.3027678837058017593.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 12:10:08 +0000
References: <20210917153905.1173010-1-colin.foster@in-advantage.com>
In-Reply-To: <20210917153905.1173010-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 08:39:03 -0700 you wrote:
> When the ocelot driver was migrated to phylink, e6e12df625f2 ("net:
> mscc: ocelot: convert to phylink") there were two additional writes to
> registers that became stale. One write was to DEV_CLOCK_CFG and one was
> to ANA_PFC_PCF_CFG.
> 
> Both of these writes referenced the variable "speed" which originally
> was set to OCELOT_SPEED_{10,100,1000,2500}. These macros expand to
> values of 3, 2, 1, or 0, respectively. After the update, the variable
> speed is set to SPEED_{10,100,1000,2500} which expand to 10, 100, 1000,
> and 2500. So invalid values were getting written to the two registers,
> which would lead to either a lack of functionality or undefined
> funcationality.
> 
> [...]

Here is the summary with links:
  - [v3,net,1/2] net: mscc: ocelot: remove buggy and useless write to ANA_PFC_PFC_CFG
    https://git.kernel.org/netdev/net/c/163957c43d96
  - [v3,net,2/2] net: mscc: ocelot: remove buggy duplicate write to DEV_CLOCK_CFG
    https://git.kernel.org/netdev/net/c/ba68e9941984

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


