Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573F1357759
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhDGWKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:10:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhDGWKT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D781E6120E;
        Wed,  7 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617833409;
        bh=prE2QgFankyvsQWt55I0nOA3hk2hXN78ujHxrGLBd7M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KPG7xEr7o64cmLnJHPQC4hllvd5BiUiQwn4eUOL87RwHFlw7otYrg2A3E9QUqajnW
         8k+WcP75isD+Q+LNorJKJQ5szuEmsz5/e62mPv9RcD9ER0NoinA6F5N7abRgmNtGGR
         xSM3X7Y5Uh0REySKrq6ycYUqSSe2Snu1Tru4xO1gniKG44YWy5GfPuyZWbM6SuwmeN
         sTAmZgUHrUi3xiHmSj9VnI3cF/85mggToBX8PyNdkocB6JYs/87wC9aqYyw/6A+6+0
         0h8trpErxp1oa5dTqQ4Z9ySCd5VhrOD9bQanvZrdSE8MEHsohtHa1TyyDSEWQV+ZxJ
         5/VCYfODNuoyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAF8F609D8;
        Wed,  7 Apr 2021 22:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] Fix link_mode derived params functionality
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783340982.5631.4957683158409610232.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:10:09 +0000
References: <20210407100652.2150415-1-danieller@nvidia.com>
In-Reply-To: <20210407100652.2150415-1-danieller@nvidia.com>
To:     Danielle Ratson <danieller@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        eric.dumazet@gmail.com, andrew@lunn.ch, mkubecek@suse.cz,
        f.fainelli@gmail.com, acardace@redhat.com, irusskikh@marvell.com,
        gustavo@embeddedor.com, magnus.karlsson@intel.com,
        ecree@solarflare.com, idosch@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 7 Apr 2021 13:06:50 +0300 you wrote:
> Currently, link_mode parameter derives 3 other link parameters, speed,
> lanes and duplex, and the derived information is sent to user space.
> 
> Few bugs were found in that functionality.
> First, some drivers clear the 'ethtool_link_ksettings' struct in their
> get_link_ksettings() callback and cause receiving wrong link mode
> information in user space. And also, some drivers can report random
> values in the 'link_mode' field and cause general protection fault.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] ethtool: Remove link_mode param and derive link params from driver
    https://git.kernel.org/netdev/net/c/a975d7d8a356
  - [net,v3,2/2] ethtool: Add lanes parameter for ETHTOOL_LINK_MODE_10000baseR_FEC_BIT
    https://git.kernel.org/netdev/net/c/fde32dbe712b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


