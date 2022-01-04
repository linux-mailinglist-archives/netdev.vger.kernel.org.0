Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22700484194
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiADMUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiADMUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:20:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9054C061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 04:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 790E3B811DA
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F269C36AE9;
        Tue,  4 Jan 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641298810;
        bh=SAEk7PUuTaxxv7sTtF9s0VXGNn+9FGL6m+eKkC3122k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i8bFvlNTPu0Jzil47tQjN+lPN2UzfXzGC24wcsY6VtrXIUFHALGodyYLLWgmaOA4K
         JubUNWtDmfiXs2NSF6nxvEMxv5KfwiNFOVlmybViECPFrl5TcGgnC6XkwS0mFFmlcS
         86uUmz8PR3ljM/Cap6cvOW0vBVBx75WexPcRvjafoXdQ/p0MYaV/7xvCHhGFLZYmVw
         8DJj1y9rhAB6mBvfFAPmCrw3IGIK7/D0fDZ5838vngAXzqnfaXW5C3R7UwFW2bEecX
         5LmMkdZzE39zwY/aXSmRJqzRqM6xdygWs+1sYLl/Lh93ZQBhZKEWCUtGFtSfUcp9h+
         TYqKUHQAetgZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2068EF79402;
        Tue,  4 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net/sched: Pass originating device to drivers
 offloading ct connection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164129881012.16438.7486914070926806905.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:20:10 +0000
References: <20220103114452.406-1-paulb@nvidia.com>
In-Reply-To: <20220103114452.406-1-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, saeedm@nvidia.com,
        xiyou.wangcong@gmail.com, jhs@mojatatu.com, pshelar@ovn.org,
        davem@davemloft.net, jiri@nvidia.com, kuba@kernel.org,
        marcelo.leitner@gmail.com, ozsh@nvidia.com, vladbu@nvidia.com,
        roid@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 3 Jan 2022 13:44:49 +0200 you wrote:
> Hi,
> 
> Currently, drivers register to a ct zone that can be shared by multiple
> devices. This can be inefficient for the driver to offload, as it
> needs to handle all the cases where the tuple can come from,
> instead of where it's most likely will arive from.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net/sched: act_ct: Fill offloading tuple iifidx
    https://git.kernel.org/netdev/net-next/c/9795ded7f924
  - [net-next,2/3] net: openvswitch: Fill act ct extension
    https://git.kernel.org/netdev/net-next/c/b702436a51df
  - [net-next,3/3] net/mlx5: CT: Set flow source hint from provided tuple device
    https://git.kernel.org/netdev/net-next/c/c9c079b4deaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


