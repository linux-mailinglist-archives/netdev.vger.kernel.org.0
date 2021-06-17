Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8E83ABBD7
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbhFQScQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:32:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231855AbhFQScM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 14:32:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 31A2D613E7;
        Thu, 17 Jun 2021 18:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623954604;
        bh=7BDxLlDD3PuEB99HgXgPAG2MhenLPpSWI4TCLJJL2Fg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t+MnYqhYPIRdgKDwBmLkKODVdeYhAb3go6kzjzAA5sfcbREL/Cv7e5RWBas4hg8bd
         pNM8J82obsOMJJI8a7Ofs2d3jh6bui83rVIs0hXcWiOSzGXul5inbKrkILS+ElpZhd
         I/Nte58TCNpSJt/E27pyNd4hbDfCHCBDQfK8X2wTlVBzUnFMSRRtZAX59cb2BuDkzI
         EgB6q9zOYZ4SgNTE4Zm/xPmO/laUrtgO0E/iov+gPJrng+FNggx+5G9NBe2KuLCYHA
         cArhM42Q+6lWXuq+JKQBNZJ3DXHgL2z/1/i4a4JdHi+MC9hZwOioRkhqzQK3jJOo0W
         rSqdXT8ucYyQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2B22F60A54;
        Thu, 17 Jun 2021 18:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] documentation: networking: devlink: fix
 prestera.rst formatting that causes build warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395460417.29839.15386152111348932740.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 18:30:04 +0000
References: <20210616174607.5385-1-oleksandr.mazur@plvision.eu>
In-Reply-To: <20210616174607.5385-1-oleksandr.mazur@plvision.eu>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     jiri@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vadym.kochan@plvision.eu, andrew@lunn.ch, nikolay@nvidia.com,
        idosch@idosch.org, sfr@canb.auug.org.au, corbet@lwn.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 20:46:07 +0300 you wrote:
> Fixes: 66826c43e63d ("documentation: networking: devlink: add prestera switched driver Documentation")
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
> V3:
>  1) use right commit hash in 'Fixes' tag.
> V2:
>  1) add missing 'net-next' tag in the patch subject.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] documentation: networking: devlink: fix prestera.rst formatting that causes build warnings
    https://git.kernel.org/netdev/net-next/c/01f1b6ed2b84

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


