Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD48480E31
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbhL2AUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:20:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237996AbhL2AUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE68BC061574
        for <netdev@vger.kernel.org>; Tue, 28 Dec 2021 16:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B1CC61373
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E14DEC36AF1;
        Wed, 29 Dec 2021 00:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640737211;
        bh=Ctwo+U9fpXvfXkgMsGNoDYgweZo3cvN/QBcUpGIM4GY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GNPGh5MDKCQMNRDWRbe1pLN4FuUYhVBOvTFlX3LuiRMNAxMGEYR5uDVRI5PxWcanH
         XAXOAp25ayEwL1YQlhpNHLMlStYxgweQQSQORdPK5izJ9k6LOvuzuBebb53n/bNbin
         761MGJY6s3AjIuSqeizn1/EZY/sTEX+4pvcTC+PW5BU7zQTyBNIQqJ0DSA5bLWWRCN
         kUrVZPKvY5dRsbYqCIbUEvfKQ7iwB/reEGySpzJB0EiS1qgeTcA8bjFxiAeHUsYJuS
         /kOBXgz6s3QA6BGA2gI4HXDGb/oS2TAwT8dgU229LeuIjKqTl6BxdsVh6bg+HfKZeH
         t1pU7bDVf43MQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFA7BC395E8;
        Wed, 29 Dec 2021 00:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9][pull request] 10GbE Intel Wired LAN Driver
 Updates 2021-12-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164073721184.15020.4929460832997879535.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 00:20:11 +0000
References: <20211228175815.281449-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211228175815.281449-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 28 Dec 2021 09:58:06 -0800 you wrote:
> Alexander Lobakin says:
> 
> napi_build_skb() I introduced earlier this year ([0]) aims
> to decrease MM pressure and the overhead from in-place
> kmem_cache_alloc() on each Rx entry processing by decaching
> skbuff_heads from NAPI per-cpu cache filled prior to that by
> napi_consume_skb() (so it is sort of a direct shortcut for
> free -> mm -> alloc cycle).
> Currently, no in-tree drivers use it. Switch all Intel Ethernet
> drivers to it to get slight-to-medium perf boosts depending on
> the frame size.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] e1000: switch to napi_consume_skb()
    https://git.kernel.org/netdev/net-next/c/dcb95f06eab8
  - [net-next,2/9] e1000: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/89a354c03b2d
  - [net-next,3/9] i40e: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/6e19cf7d3815
  - [net-next,4/9] iavf: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/ef687d61e0e9
  - [net-next,5/9] ice: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/5ce666315848
  - [net-next,6/9] igb: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/fa441f0fa8bc
  - [net-next,7/9] igc: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/4dd330a7e894
  - [net-next,8/9] ixgbe: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/a39363367a37
  - [net-next,9/9] ixgbevf: switch to napi_build_skb()
    https://git.kernel.org/netdev/net-next/c/c15500198916

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


