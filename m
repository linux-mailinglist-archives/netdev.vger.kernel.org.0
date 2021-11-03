Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B854C44431A
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbhKCOMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 10:12:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231131AbhKCOMo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 10:12:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32D4E6113E;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635948608;
        bh=kn+4TsjHiThzYZ8w0WNWCTaQhG8XzIsqFBqetlc2WeU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WwT0VnL1vN7MbPW9t6QAh3vSxF4QbTnbqk5dfDcBZ3X5whmTHUSMOV0DIYF1B+cd0
         P5te43W0ExVl4BrVh1bT3+vmdUpFB9zdaBkQXEnUB02STnAEI049orL3yMn43BPwZx
         cEnHyfOUZIxMJfhkq+A7imnwMQn8UAB6s/2gKXTNaeIbUXB9VY9rvgxIlNfFKUlXK4
         EPYs79smYZp/g4yx+gVVo8lQj4S9Ng+nKrhZzLIcWvGcP+/bIuN8ZDZ5vnl4cc8ZQ3
         mXO7Nh0tcMr3jz+z0Ce7uFWBhIP5sR/pY8D62w+vfBmiu5x5tNo37MHsHHMhj5zdf8
         YpKrQH+CQEX0A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1C2D060A4E;
        Wed,  3 Nov 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ethtool: fix ethtool msg len calculation for pause
 stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163594860810.30241.5195872083246136745.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 14:10:08 +0000
References: <20211102220236.3803742-1-kuba@kernel.org>
In-Reply-To: <20211102220236.3803742-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, saeedm@nvidia.com,
        mkubecek@suse.cz, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 Nov 2021 15:02:36 -0700 you wrote:
> ETHTOOL_A_PAUSE_STAT_MAX is the MAX attribute id,
> so we need to subtract non-stats and add one to
> get a count (IOW -2+1 == -1).
> 
> Otherwise we'll see:
> 
>   ethnl cmd 21: calculated reply length 40, but consumed 52
> 
> [...]

Here is the summary with links:
  - [net,v2] ethtool: fix ethtool msg len calculation for pause stats
    https://git.kernel.org/netdev/net/c/1aabe578dd86

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


