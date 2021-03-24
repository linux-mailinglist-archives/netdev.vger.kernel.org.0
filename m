Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B19E34822F
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 20:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237981AbhCXTuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 15:50:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237836AbhCXTuJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 15:50:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3CD2261A21;
        Wed, 24 Mar 2021 19:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616615408;
        bh=jWlbCW3ZvY9ep7+jRAH9k7cY3rs1dnmpwgoeOz00z3w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XvWZJy4NHh8YmWYB8PAjHxyx49VVepw96KB0QiUqOhGfsgQCMCMHass0aSITxUnDL
         zqONfHDu2Rh9xt9iydwQhFVQFV2qFsC/RsE5JCuhuJud+kSv43icaaSJ8WV36rNDBB
         u6w5SeXpFQp4y6w/sWCgjN4Amn6DM0dkE9NRG25pygwhWBIbKJ+rQZYP0KjhAUPYlp
         /tcnv+aGplz62JyEtRGuJDU53WmGky+Z5BbgHOcExhGOSdU4BzICJbSEzoAPfTf/zz
         l5OkSCqmE5EvKhJHjeDDzITvjfUFKYqW1jOkeGZ1mFnhR3yb6GfRtc3PWxATBmMJpt
         2iaqc+kkiH6Bw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2AC6260A6A;
        Wed, 24 Mar 2021 19:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] net: bridge: Fix missing return assignment from
 br_vlan_replay_one call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161661540817.24400.14095983696664158789.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Mar 2021 19:50:08 +0000
References: <20210324150950.253698-1-colin.king@canonical.com>
In-Reply-To: <20210324150950.253698-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, vladimir.oltean@nxp.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 15:09:50 +0000 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The call to br_vlan_replay_one is returning an error return value but
> this is not being assigned to err and the following check on err is
> currently always false because err was initialized to zero. Fix this
> by assigning err.
> 
> [...]

Here is the summary with links:
  - [next] net: bridge: Fix missing return assignment from br_vlan_replay_one call
    https://git.kernel.org/netdev/net-next/c/ad248f7761eb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


