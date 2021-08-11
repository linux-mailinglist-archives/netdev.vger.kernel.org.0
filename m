Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9203E9AAB
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbhHKWAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:32882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232166AbhHKWA3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:00:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B66D46101E;
        Wed, 11 Aug 2021 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628719205;
        bh=723kbs6YS3i+RjAJfpDnRidqUBek82X8fKddkblZblM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PMQfJ8DQrwj9t6D07IZMENCK6FTBkNpaQFTf872KEn1db0gbAA/Nz6Ui+ybb2MLan
         0uFgeisGLH9QQBmRsBOwAqGOXCqdDAC9FBrJiCEJwt69B+iywA3QKRFlSxP7Wj456X
         qlrcxv0e+ODRe4VodYKwErgi8nx2E474TBLZOCQ/QiPwnBcQkX6RtDgsaxzYDGMP+E
         tf84hBwRYbqzDplgM4jmH6M7lhDG6Hyp4TvoZO98I5i+aLMRzPG1VcUV3/dyQwvG3J
         iNnM8X2xP0qhX4I3ydHiNAv7mTVv9xPMbB4dFnAbDdmCNDNHKfFbEnD/6+LFx34XEU
         X7KULfK1iqHIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F60060A54;
        Wed, 11 Aug 2021 22:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mscc: Fix non-GPL export of regmap APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162871920564.21131.2679380379070441056.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 22:00:05 +0000
References: <20210810123748.47871-1-broonie@kernel.org>
In-Reply-To: <20210810123748.47871-1-broonie@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 13:37:48 +0100 you wrote:
> The ocelot driver makes use of regmap, wrapping it with driver specific
> operations that are thin wrappers around the core regmap APIs. These are
> exported with EXPORT_SYMBOL, dropping the _GPL from the core regmap
> exports which is frowned upon. Add _GPL suffixes to at least the APIs that
> are doing register I/O.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: mscc: Fix non-GPL export of regmap APIs
    https://git.kernel.org/netdev/net-next/c/bc8968e420dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


