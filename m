Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ED93B491E
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 21:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhFYTM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 15:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:46992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhFYTMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 15:12:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D93D661960;
        Fri, 25 Jun 2021 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624648204;
        bh=ug/5msKSrNeJYy7gjcgVSoBTrpSD5PKgmI2MgfnsBw0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G3uEKuWKI+2Y/vI16vzkt/uhbw04ccF6ndv8PBoipcnR1cVApxyjoREMrV4tjQDb2
         GSyYqppH872Ma54AE+Ok1NLLQs65bWGTAVuvWxgfIJP3U5XAGrD5kpwH9mf+1CT7MW
         Uw1UsAaPtfmvIIi7ZSkfE6bU+C6C1VE+bJwaP3mHVlztc5dgreo5QifSksxO1YvpuJ
         UYi54Bc85EEmDAWg/f+AbrwX+kD7xEXiSRQrIID7/Mb+hW0HzJ2uP9EIO/Ly3dB3nt
         83b0Nzp+Z7t/qBXWG024u80Mw2bvbKjuiqrYyjhPn/eEz4VDQdlCOLfXUKItx/hBmx
         aNca6Sa6K0HVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CC86960A53;
        Fri, 25 Jun 2021 19:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-06-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162464820483.10281.1811440196302864199.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Jun 2021 19:10:04 +0000
References: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210625185733.1848704-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 25 Jun 2021 11:57:28 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Jesse adds support for tracepoints to aide in debugging.
> 
> Maciej adds support for PTP auxiliary pin support.
> 
> Victor removes the VSI info from the old aggregator when moving the VSI
> to another aggregator.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] ice: add tracepoints
    https://git.kernel.org/netdev/net-next/c/3089cf6d3caa
  - [net-next,2/5] ice: add support for auxiliary input/output pins
    https://git.kernel.org/netdev/net-next/c/172db5f91d5f
  - [net-next,3/5] ice: remove the VSI info from previous agg
    https://git.kernel.org/netdev/net-next/c/37c592062b16
  - [net-next,4/5] ice: remove unnecessary VSI assignment
    https://git.kernel.org/netdev/net-next/c/70fa0a078099
  - [net-next,5/5] ice: Fix a memory leak in an error handling path in 'ice_pf_dcb_cfg()'
    https://git.kernel.org/netdev/net-next/c/b81c191c468b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


