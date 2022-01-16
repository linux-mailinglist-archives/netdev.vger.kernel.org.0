Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF8448FFA5
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 00:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbiAPXkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Jan 2022 18:40:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57052 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiAPXkJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Jan 2022 18:40:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FF3761021
        for <netdev@vger.kernel.org>; Sun, 16 Jan 2022 23:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 647CCC36AE3;
        Sun, 16 Jan 2022 23:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642376408;
        bh=eT6gKexXSYceR2fGZcmrja/cWhjguJImsTEiCL0oles=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lOwcBzfJfSvLU91Yn/1hyWo+y/JqvOypzpc3UWYJ0NK/If/beG4naf+DSiGvtrJRG
         FijXXmAiUaiEM2uLQj4NtlEi4tUxFrPsLIWy3tIsgfLk1uZqtCLsHsI6A8s11p0WBi
         f9PZsQS3/J61ZWx2/dcLrWLx6a8ApYsMx+kXUM7Gk8nhYSMt8lbNN/qcgk99ub/Ge9
         guPLpyp+TawIRkMIR6Kbu/pEGWp1ZNVer9yIaIVuNPX+mZcFOxjyLcAM+nHNcr9Sxp
         x/wU9OiHr9/7WygirzvqzVVLCpOvZyIRmsUX+BgnGDhj+XgiNxg6Zh+lbQ5PWKvMwN
         oSLgY5NVa6rRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 453B7F60795;
        Sun, 16 Jan 2022 23:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] bonding: Fix extraction of ports from the packet
 headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164237640827.28388.6229190499343583559.git-patchwork-notify@kernel.org>
Date:   Sun, 16 Jan 2022 23:40:08 +0000
References: <20220116173929.6590-1-moshet@nvidia.com>
In-Reply-To: <20220116173929.6590-1-moshet@nvidia.com>
To:     Moshe Tal <moshet@nvidia.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        joamaki@gmail.com, daniel@iogearbox.net, tariqt@nvidia.com,
        saeedm@nvidia.com, gal@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 16 Jan 2022 19:39:29 +0200 you wrote:
> Wrong hash sends single stream to multiple output interfaces.
> 
> The offset calculation was relative to skb->head, fix it to be relative
> to skb->data.
> 
> Fixes: a815bde56b15 ("net, bonding: Refactor bond_xmit_hash for use with
> xdp_buff")
> Reviewed-by: Jussi Maki <joamaki@gmail.com>
> Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
> Reviewed-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Moshe Tal <moshet@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] bonding: Fix extraction of ports from the packet headers
    https://git.kernel.org/netdev/net/c/429e3d123d9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


