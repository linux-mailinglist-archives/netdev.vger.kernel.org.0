Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368E649E3B9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbiA0NkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:40:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44610 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiA0NkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB1861C4B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2BFCC340E8;
        Thu, 27 Jan 2022 13:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643290811;
        bh=i7tc8NRkWktInkRQ0ykCX7tCCUl91b7K2ozaElx6geg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uzknx+R6GZunzEXbROYKYp/7OA+yseLa3K6xEQP9TRY+/BM9Od1XYf+daeKtMMydW
         JSSf9LIc3nE/0Rji98zM5IboDzC4NJLLWQwAS1wq/9cvIwVkr1Edg3FXAN5uC3DKVM
         aiRJ9BRteO0ygAWxuGsnckCVUID3HoJdTypiuSmjKKaEk2OaMMfLODecb+fNJkgzTp
         JJuQNpPYlHltPAttpp554Ld5tfuILdl0v+S1twoHsSftGHmXrCLFgYH8UTvgURFyYD
         ZGAMF4ZFkMBdxj3lO1iAtWJcPyVH4LeCssI3Gqa5ynSx4zSWHidlyPh9r5snUIbmG1
         JnZPLgMT2xnMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E002DE5D07E;
        Thu, 27 Jan 2022 13:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: mvneta: use .mac_select_pcs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329081091.3515.17212618814255816226.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 13:40:10 +0000
References: <YfAsXaXfSGQX8w75@shell.armlinux.org.uk>
In-Reply-To: <YfAsXaXfSGQX8w75@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 16:59:09 +0000 you wrote:
> Hi,
> 
> This series converts mvneta to use the .mac_select_pcs() like eventually
> everything else will be. mvneta is slightly more involved because we
> need to rearrange the initialisation first to ensure everything required
> is initialised prior to phylink_create() being called.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: mvneta: reorder initialisation
    https://git.kernel.org/netdev/net-next/c/72bb9531162a
  - [net-next,2/2] net: mvneta: use .mac_select_pcs() interface
    https://git.kernel.org/netdev/net-next/c/0ac4a71fc09c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


