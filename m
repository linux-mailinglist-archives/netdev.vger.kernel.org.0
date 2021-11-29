Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA57F461522
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354489AbhK2Mfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:35:30 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59322 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244746AbhK2Md3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:33:29 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3B7CB8105A;
        Mon, 29 Nov 2021 12:30:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 717DA60184;
        Mon, 29 Nov 2021 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638189009;
        bh=YumIVWW8v4CgXiygB9D+c81bh6Mc4361zipd22kWrcs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bORHPDKpD09HrJC4raYE+/dvcGxogT8lIugWpsBnpDKB9pvomlIRV4hpIjGWWkstE
         Pi+as2VOZsngMQdk4zvgoQ15yXHKlAkKwhTrvof2/LX/fZIZULuwr6vhm8b9sn76LS
         cAwKTFh7THT/o8ISjx9MExXVf6AHsLUMq+LCFmYnezWJ0vuS5CYlRczbgHrL3ubeS1
         owIHCXoBDN+HpZ/NP7NNMBghk/O2v9mEB3bGBGHxf4jxgIiWEngXW1YtKmQkoP9egZ
         7wFq6gqZhMgWrr7MIdwesYjSptt06Ys2wIv4UStJUcBlMMqXLZXUNbZWypZd7k4xpB
         93L3tVCostTqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6066760A45;
        Mon, 29 Nov 2021 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] net: wwan: Add Qualcomm BAM-DMUX WWAN network
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818900938.24631.13563359260502643872.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:30:09 +0000
References: <20211127173108.3992-1-stephan@gerhold.net>
In-Reply-To: <20211127173108.3992-1-stephan@gerhold.net>
To:     Stephan Gerhold <stephan@gerhold.net>
Cc:     davem@davemloft.net, kuba@kernel.org, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        bjorn.andersson@linaro.org, agross@kernel.org, robh+dt@kernel.org,
        aleksander@aleksander.es, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, jeffrey.l.hugo@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 27 Nov 2021 18:31:06 +0100 you wrote:
> The BAM Data Multiplexer provides access to the network data channels
> of modems integrated into many older Qualcomm SoCs, e.g. Qualcomm MSM8916
> or MSM8974. This series adds a driver that allows using it.
> 
> All the changes in this patch series are based on a quite complicated
> driver from Qualcomm [1]. The driver has been used in postmarketOS [2]
> on various smartphones/tablets based on Qualcomm MSM8916 and MSM8974
> for more than a year now with no reported problems. It works out of
> the box with open-source WWAN userspace such as ModemManager.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] dt-bindings: net: Add schema for Qualcomm BAM-DMUX
    https://git.kernel.org/netdev/net-next/c/f3aee7c900ed
  - [net-next,v3,2/2] net: wwan: Add Qualcomm BAM-DMUX WWAN network driver
    https://git.kernel.org/netdev/net-next/c/21a0ffd9b38c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


