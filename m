Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26063D960E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 21:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhG1TaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 15:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229690AbhG1TaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 15:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2979861050;
        Wed, 28 Jul 2021 19:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627500607;
        bh=lQrvcEmtVLC7eu65VsoX4LPWcaM9nWCjE4TSqMFHB5c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CKOJ0NkF6KODIci71awMFsuD2dvBAjEaaEcS5jMUou/oyBmlWmp1/eW9NjHhF46E3
         gfvciab5C9p/DS0ANZzK6s1Eno9ZzKsq+aNeiAS/FCkKB/weKMgVM6lx41oOyTOl7+
         0CV/N9iShuvHFQzMV9OhS2o4s7P5+O9zoJFZDCkolbOg9mRUx1z8IXUAI1OXttyIMq
         HggE1TAia5jSqQaV6JERMCq6x754zZNlaUBnNzvojAzlOBvWjyv61Is7RXJsTYg2BZ
         M4GPYr7KR8nEw5pCxgrxiSdoya7V8YqpcHTYDyURM3Y686Bi1FFsBOUB9yU0YbNHoM
         moMgsevrIpkPw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E615609F7;
        Wed, 28 Jul 2021 19:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Plug the last 2 holes in the switchdev notifiers
 for local FDB entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162750060712.2664.8238348903742973027.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Jul 2021 19:30:07 +0000
References: <20210728182748.3564726-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210728182748.3564726-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        idosch@nvidia.com, jiri@nvidia.com, roopa@nvidia.com,
        nikolay@nvidia.com, tobias@waldekranz.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 21:27:46 +0300 you wrote:
> The work for trapping local FDB entries to the CPU in switchdev/DSA
> started with the "RX filtering in DSA" series:
> https://patchwork.kernel.org/project/netdevbpf/cover/20210629140658.2510288-1-olteanv@gmail.com/
> and was continued with further improvements such as "Fan out FDB entries
> pointing towards the bridge to all switchdev member ports":
> https://patchwork.kernel.org/project/netdevbpf/cover/20210719135140.278938-1-vladimir.oltean@nxp.com/
> https://patchwork.kernel.org/project/netdevbpf/cover/20210720173557.999534-1-vladimir.oltean@nxp.com/
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: bridge: switchdev: replay the entire FDB for each port
    https://git.kernel.org/netdev/net-next/c/b4454bc6a0fb
  - [net-next,2/2] net: bridge: switchdev: treat local FDBs the same as entries towards the bridge
    https://git.kernel.org/netdev/net-next/c/52e4bec15546

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


