Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A2047986E
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 04:30:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231965AbhLRDaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 22:30:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56490 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231896AbhLRDaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 22:30:18 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B6B3BB82B83
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 03:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D7FAC36AEA;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639798216;
        bh=/DEMqvAwcuaF91NeQpGbY/2H7i8NDaH0rMbImFFHS/0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HMYT3ZjMt1Fzhp6FzfwSWDJGdQYRKhLAiGd4EWOHAPK1dMrziNW0kPGSgdGQ3I5bv
         GfdN5gNXiLQ5CQV0XK/deAqX33daFhsCITHHN59EdYl/+IqJwHlOrMGrpRZJ86dCb4
         3GZdDvzVKdN7kMnkOI+dT6QUEIzw39nPOuJdESWaHuik5yepR7FDB5LmAmEBTbQzAd
         qmIEb3vs0XX34uGG+IrwiS/O5n+JyUwUXvPaZoGbiZry4HyVmqPGbAzGe1HAKjtm/F
         vm3CNIaDXlzFexkPpGnf6PvK+gO3u+5+to1Kqv6lEvjPJ9lOU0nTRFrF9D1r3x89L6
         cksnu7XPdtEmg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D886609BB;
        Sat, 18 Dec 2021 03:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tsnep: Fix s390 devm_ioremap_resource warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163979821644.17814.14326060758512838301.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 03:30:16 +0000
References: <20211216200154.1520-1-gerhard@engleder-embedded.com>
In-Reply-To: <20211216200154.1520-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Dec 2021 21:01:54 +0100 you wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> The following warning is fixed with additional config dependencies:
> 
> s390-linux-ld: drivers/net/ethernet/engleder/tsnep_main.o: in function `tsnep_probe':
> tsnep_main.c:(.text+0x1de6): undefined reference to `devm_ioremap_resource'
> 
> [...]

Here is the summary with links:
  - [net-next] tsnep: Fix s390 devm_ioremap_resource warning
    https://git.kernel.org/netdev/net-next/c/00315e162758

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


