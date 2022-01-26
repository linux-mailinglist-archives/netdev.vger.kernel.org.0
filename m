Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3270149CEE2
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234303AbiAZPuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:50:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57514 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235707AbiAZPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:50:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87DEFB81EE8
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 15:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 359A0C340EE;
        Wed, 26 Jan 2022 15:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643212212;
        bh=lnV+NdbxjQxf1vNM3KN26/PoxpQl5M0q6CEdmk9QJLk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iDMPnmEv15D36bMyxOSvD2o6XRMk3QPdjpoRXlWflxiq82JRZA63tFaQtUw7r9Y15
         lk08B7b31vPe5gWetys1juJ4FUrk5fz3joejY/2RBfwa53Ok/1h7DDKtal2ozFxUgF
         KM5Bl8BJVtOUtMnKf7SvWNm2/Vu3UhfkL7AILUMq/dz/tcGW5t2MVB25rP5zWv1Ay8
         VXr/+3WzbQAaqyKCTczWKqQoC55L+TtIjuWtj94JyFam4URZM4kXHuXjjFz1QSQFSy
         1dqK2HQlOtT88JTAdlXtbWJfJgf/CqRwIPcww3tiskwNnP4eoyNIxRJx/0yKbkXDNp
         txCaOXWEUULXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 232E9F607B4;
        Wed, 26 Jan 2022 15:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: axienet: modernise pcs implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164321221213.12592.9190321368977882213.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 15:50:12 +0000
References: <YfAgeKiKvxcQ0w57@shell.armlinux.org.uk>
In-Reply-To: <YfAgeKiKvxcQ0w57@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     michal.simek@xilinx.com, harinik@xilinx.com,
        radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, sean.anderson@seco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 16:08:24 +0000 you wrote:
> Hi,
> 
> These two patches modernise the Xilinx axienet PCS implementation to
> use the phylink split PCS support.
> 
> The first patch adds split PCS support and makes use of the newly
> introduced mac_select_pcs() function, which is the preferred way to
> conditionally attach a PCS.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: axienet: convert to phylink_pcs
    https://git.kernel.org/netdev/net-next/c/7a86be6a5135
  - [net-next,2/2] net: axienet: replace mdiobus_write() with mdiodev_write()
    https://git.kernel.org/netdev/net-next/c/03854d8a7723

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


