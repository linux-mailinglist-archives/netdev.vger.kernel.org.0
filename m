Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0F746046F2
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiJSNZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbiJSNY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:24:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2071160ECA
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 06:11:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0516B82495
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 13:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87DCAC433C1;
        Wed, 19 Oct 2022 13:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666185019;
        bh=zC9XA18YC6b4UQw3YuHcfGSILD1ps1/Q+PfUXGFqrkc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SpR3p+oRqpIE0RT6JN4dDKObbuG899v4Uz+1u93yDXO4skeJ/DfZDmpfz98jAg3Ry
         ZekPFnlok7zbwuPenPOZTtAXnHHEW77qkkU19FwTsNsftr6fisAZjnDkxziDNEKlkp
         oi/qC84737aIJyna898FEsMjMJBBiCcV37NxII1FRBzzgUzm9qL4uNw3zdWJfFkaL1
         SzsG9J13v7BIeOLtzLuXA/u9PAxxkrfhw0qBRfFAsREKgIcmLvmGYXdtEDsVGtppke
         eoaGqWQjoi7CvYbYRcnUv55TC0467UMKxStnKpcVRMqVCcz5O5Zc3FdPWswWyno1VS
         1lnXxx1SAJtzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6EEBBE4D007;
        Wed, 19 Oct 2022 13:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] bridge: A few multicast cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166618501944.21602.8884811342175634772.git-patchwork-notify@kernel.org>
Date:   Wed, 19 Oct 2022 13:10:19 +0000
References: <20221018064001.518841-1-idosch@nvidia.com>
In-Reply-To: <20221018064001.518841-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Oct 2022 09:39:57 +0300 you wrote:
> Clean up a few issues spotted while working on the bridge multicast code
> and running its selftests.
> 
> Ido Schimmel (4):
>   selftests: bridge_vlan_mcast: Delete qdiscs during cleanup
>   selftests: bridge_igmp: Remove unnecessary address deletion
>   bridge: mcast: Use spin_lock() instead of spin_lock_bh()
>   bridge: mcast: Simplify MDB entry creation
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] selftests: bridge_vlan_mcast: Delete qdiscs during cleanup
    https://git.kernel.org/netdev/net-next/c/6fb1faa1b92b
  - [net-next,2/4] selftests: bridge_igmp: Remove unnecessary address deletion
    https://git.kernel.org/netdev/net-next/c/b526b2ea1454
  - [net-next,3/4] bridge: mcast: Use spin_lock() instead of spin_lock_bh()
    https://git.kernel.org/netdev/net-next/c/262985fad1bd
  - [net-next,4/4] bridge: mcast: Simplify MDB entry creation
    https://git.kernel.org/netdev/net-next/c/d1942cd47dbd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


