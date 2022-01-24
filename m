Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3A497E64
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238068AbiAXMAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiAXMAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:00:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F044C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 04:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EFC460C7C
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B384C340E4;
        Mon, 24 Jan 2022 12:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643025611;
        bh=S0yzZx/yPX12LBtPQl5nQOp1wA2qLNDTv+BxJFGNi6Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IuD6XU+lbZD8vinZ/plzGf5VwzXXTGMScQkBLY2v4JWrsQZ0Fy5dkfEjhhwoLel6t
         IHvNRVb4dcwhd2l2qNkrcVbE+wTI38LAq4O+ZV9tiaEdqLdiPNsE/PaYGzWK69SkOm
         k+cGjIwzhVlE0c6M2t7bMLo4Rj0CrTCRwIDKkgxNiuwEPIh0RcgRGvceRJK2SdNVRS
         f0IglpZdqYqCVlyse/1OHSIkRE4QXHKlwDaJhnzvvDp5FuUIJ/GMABmV5NJB0JcQoy
         SEUyZ0EC6klvr5ZXBjXC75QA4aO+hoA9TxdfW8+9dTLfmSr38Mrhg+sS/wS4yBOHne
         5YVyA0Dxvct0A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7405F6079B;
        Mon, 24 Jan 2022 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: use rcu_dereference_rtnl when get bonding active
 slave
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164302561094.14817.7012728270995904223.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 12:00:10 +0000
References: <20220121082518.1125142-1-liuhangbin@gmail.com>
In-Reply-To: <20220121082518.1125142-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com,
        jay.vosburgh@canonical.com, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Jan 2022 16:25:18 +0800 you wrote:
> bond_option_active_slave_get_rcu() should not be used in rtnl_mutex as it
> use rcu_dereference(). Replace to rcu_dereference_rtnl() so we also can use
> this function in rtnl protected context.
> 
> With this update, we can rmeove the rcu_read_lock/unlock in
> bonding .ndo_eth_ioctl and .get_ts_info.
> 
> [...]

Here is the summary with links:
  - [net] bonding: use rcu_dereference_rtnl when get bonding active slave
    https://git.kernel.org/netdev/net/c/aa6034678e87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


