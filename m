Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2117A4567C2
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 03:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbhKSCDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 21:03:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:49108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234033AbhKSCDM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 21:03:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2785461AA7;
        Fri, 19 Nov 2021 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637287209;
        bh=4INYA40t0/Hh2r+rxiI0FsVhGWfbpoY5iByY2EhDJl8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pji+7DS6YySGHZ9FICllsiVQGBCOxPrq0JTRV3jjMc7GyWyTcGNbzSioyR8Zaf5Vl
         Scf4I+fpSOxFVBvLo4+7yNO4D+rXW9bFAlR2KLNriA0idA7x5UlK+oDOv0oGPvfplm
         YmS9GRzZY3twkGNdISeMe/GGhWa5PDaxlW4DZavU8KvQxBUvQhVXkWrTD7AcwizMub
         YqHxNkwtFvV1iecHbtSZ8zFPlz5Pdl7WfS0d4jo8n2lQsKq8oeaWGXe2sD18ykb6Qr
         ospyMNU0T8R5xS3wWjhCfppQC7k+QmBv8d1+cCNr5N+wsBupwFNj8sLisvu9DfCZdV
         veCTH6APCymTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1A2EA60BD0;
        Fri, 19 Nov 2021 02:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: regmap: allow to define reg_update_bits for no bus configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163728720910.25941.7730212992903083746.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Nov 2021 02:00:09 +0000
References: <20211117210451.26415-2-ansuelsmth@gmail.com>
In-Reply-To: <20211117210451.26415-2-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, broonie@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Mark Brown <broonie@kernel.org>:

On Wed, 17 Nov 2021 22:04:33 +0100 you wrote:
> Some device requires a special handling for reg_update_bits and can't use
> the normal regmap read write logic. An example is when locking is
> handled by the device and rmw operations requires to do atomic operations.
> Allow to declare a dedicated function in regmap_config for
> reg_update_bits in no bus configuration.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Link: https://lore.kernel.org/r/20211104150040.1260-1-ansuelsmth@gmail.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> [...]

Here is the summary with links:
  - regmap: allow to define reg_update_bits for no bus configuration
    https://git.kernel.org/netdev/net-next/c/02d6fdecb9c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


