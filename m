Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F200410B39
	for <lists+netdev@lfdr.de>; Sun, 19 Sep 2021 13:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbhISLVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 07:21:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:57590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhISLVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Sep 2021 07:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0548661212;
        Sun, 19 Sep 2021 11:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632050409;
        bh=JIGaJfOPy+A1wK7LQs8BrNuGNzGSnz0lSF7BBZxPuEw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kNua6bxEtWMIrNmF5IbyeNiaA+0GQWHCl0XTC3mf/2d+2rAK69djFKzHJ4rAMoGWZ
         NCTSRi/W1wED0qcwOYGtOMgpHiNsMcQcMPvlyqndTVoov4lgadU/Sq88i7VtY5aNH8
         Ljp78gZS50HKafMDrHOLoKsI01ySDoDXBg7zM3u28dUPjIivKRmlOGY1kdDQoezum1
         BGuC/oE3KeD+gRngHzV5AbPEuKpLxaRpmwoEg3v/CSWlPunTwZunvwk1QDU/GauN5p
         0IzOmHjNn9u5CBbUzCGRVOHDvkbLOVTSUAvilzq+xUoiYZ/xiEx158BeynFcT4mxoz
         j2K/pxuaD5PfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED5FD60A2A;
        Sun, 19 Sep 2021 11:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] enetc: Fix uninitialized struct dim_sample field usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163205040896.14261.9966381063593908675.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Sep 2021 11:20:08 +0000
References: <20210917102206.20616-2-claudiu.manoil@nxp.com>
In-Reply-To: <20210917102206.20616-2-claudiu.manoil@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 17 Sep 2021 13:22:06 +0300 you wrote:
> The only struct dim_sample member that does not get
> initialized by dim_update_sample() is comp_ctr. (There
> is special API to initialize comp_ctr:
> dim_update_sample_with_comps(), and it is currently used
> only for RDMA.) comp_ctr is used to compute curr_stats->cmps
> and curr_stats->cpe_ratio (see dim_calc_stats()) which in
> turn are consumed by the rdma_dim_*() API.  Therefore,
> functionally, the net_dim*() API consumers are not affected.
> Nevertheless, fix the computation of statistics based
> on an uninitialized variable, even if the mentioned statistics
> are not used at the moment.
> 
> [...]

Here is the summary with links:
  - [net] enetc: Fix uninitialized struct dim_sample field usage
    https://git.kernel.org/netdev/net/c/9f7afa05c952

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


