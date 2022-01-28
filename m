Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF24549F1BD
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 04:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345677AbiA1DUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 22:20:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60370 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345661AbiA1DUL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 22:20:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D9461E25
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 03:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D49AC340E7;
        Fri, 28 Jan 2022 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643340010;
        bh=OFTKBUga+x8TPaIEs8KeMhhv9jJSwyu7WptTmjog5hc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YCLDCw9X/IUwkbOIB9ZkKZ2bn8kJY0HZNu/qOUOSIYJMJBRu9dtrbhyxwMxIfm8pe
         F9O/qnVJdrNYekY0HygIXphAKihtWMzyiNDfDzMp8R/Ze1eYwMnxE56TSSzk9i+l62
         gk2Mmey+T5uffIIJmditMCigVt+a+OfpVvzyxO1OQEQBO5gj7kTzn+OlnDQu4k2wkw
         fFO0owXxQJwH5GUQ51TGd7shFvU1EXvjX9ks68gLqK6nyM7WSvXPMkFg4I2jUsqtq4
         WpBgc4fNJ/8E60XscKOZH0y9dYM/HJsgtWl5U8oh6k+X2iqhQ0x5zQP4EzEzznCiDD
         kD5pXYLjO2YRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 144D3E5D07D;
        Fri, 28 Jan 2022 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net:amd-xgbe: ensure to reset the tx_timer_active flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164334001007.1685.6750317411479847449.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 03:20:10 +0000
References: <20220127060222.453371-1-Raju.Rangoju@amd.com>
In-Reply-To: <20220127060222.453371-1-Raju.Rangoju@amd.com>
To:     Raju Rangoju <Raju.Rangoju@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Shyam-sundar.S-k@amd.com,
        Sudheesh.Mavila@amd.com, sudheesh.mavila@amd.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Jan 2022 11:32:22 +0530 you wrote:
> Ensure to reset the tx_timer_active flag in xgbe_stop(),
> otherwise a port restart may result in tx timeout due to
> uncleared flag.
> 
> Fixes: c635eaacbf77 ("amd-xgbe: Remove Tx coalescing")
> Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
> Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
> 
> [...]

Here is the summary with links:
  - [net] net:amd-xgbe: ensure to reset the tx_timer_active flag
    https://git.kernel.org/netdev/net/c/7674b7b559b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


