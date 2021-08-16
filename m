Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D142B3ED1FF
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbhHPKbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:47976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235799AbhHPKai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:30:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2534B61BE3;
        Mon, 16 Aug 2021 10:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629109807;
        bh=/+5fSS2mmFCat+Q0E926NBXqV4wgVmzfjhsd78iYPwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ub7pRNcQnL1FFy3JToDSNgkrbm+RxnKisjqkmxdUuDNgUlsfFVRFTUtMdpVE8FNlD
         m7Fj28HfpAF3m+8kzL8oavgjxzO1ZL01nOi89pSg9xhlSCP8zl+d/GMHsmdfPOYXC9
         t8hIrEGLILCWjWJEU6pOpgJjHP4T3V2PlUTsDGPnk1/7/GUYN0yef1FyFePNECAJJ2
         eIWP9dvtPgoL3d94tWJtEfRdyPRxZrj+a5hN7B63gqTrMTO9aveoCFQTetfr0PRd6H
         cgHvr8PkNoQHjjY5zUsb8aPRzbIZlwvDvhtMgalM96KY23PyEk7iZxfzHswuMtCD2Z
         Uw5IbXtamoOOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1EB1D609DA;
        Mon, 16 Aug 2021 10:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: reorganize probe, remove,
 setup and teardown ordering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910980712.576.15937722305011211916.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:30:07 +0000
References: <20210815120035.1374134-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210815120035.1374134-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 15 Aug 2021 15:00:35 +0300 you wrote:
> The sja1105 driver's initialization and teardown sequence is a chaotic
> mess that has gathered a lot of cruft over time. It works because there
> is no strict dependency between the functions, but it could be improved.
> 
> The basic principle that teardown should be the exact reverse of setup
> is obviously not held. We have initialization steps (sja1105_tas_setup,
> sja1105_flower_setup) in the probe method that are torn down in the DSA
> .teardown method instead of driver unbind time.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: reorganize probe, remove, setup and teardown ordering
    https://git.kernel.org/netdev/net-next/c/022522aca430

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


