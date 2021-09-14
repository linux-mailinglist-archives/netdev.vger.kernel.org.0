Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770F240AEEF
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbhINNb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:50412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233216AbhINNbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:31:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8600E61151;
        Tue, 14 Sep 2021 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626208;
        bh=oDxj4oDXax6hz0oMF99HrNtHultqkmdCGf0DtXx8CDs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sz8PWH3j5Ynb1OE679nfWfCwZTCZf0y5/NpBLoxDUchCYNJTcyod5pFFUx+jrcUOU
         doImYDTf9P5ju1VxlrkbZ0GCTuCVFxK5rd4eS9T5tBlTl36rY0Z2PedlKzcfn996xS
         xQxGF8yBjPa8++h850XHgfPlADXX56yyWs8i1/qehGQH9M+Scnk/9ghbt2Ng4M+FII
         MCBPMz6WQyvcl7pd7HGkM/7ZbpqppB3k6ipLJRNHHAW2YzAT9btmbck5Rl+Dl4ty5h
         KXiMejLb2mnJJPE3+PsZIRFzkEWARZu1vy4bZ8MtyrVJnM5QQHV/qSDXsUNZZx7tdz
         S8oWt3cst1R2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 77AF560A4D;
        Tue, 14 Sep 2021 13:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: prevent endless loop if eeprom size is
 smaller than announced
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162620848.30283.3556443431408541891.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:30:08 +0000
References: <f6b5c29f-ca07-a6a0-6e94-6b52dc56407b@gmail.com>
In-Reply-To: <f6b5c29f-ca07-a6a0-6e94-6b52dc56407b@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 13 Sep 2021 21:58:26 +0200 you wrote:
> It shouldn't happen, but can happen that readable eeprom size is smaller
> than announced. Then we would be stuck in an endless loop here because
> after reaching the actual end reads return eeprom.len = 0. I faced this
> issue when making a mistake in driver development. Detect this scenario
> and return an error.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: prevent endless loop if eeprom size is smaller than announced
    https://git.kernel.org/netdev/net-next/c/b9bbc4c1debc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


