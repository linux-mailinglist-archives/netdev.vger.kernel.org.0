Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D000649E8E
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 13:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbiLLMUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 07:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLLMUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 07:20:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A7E62E5
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 04:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E056B61007
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 12:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4561EC433D2;
        Mon, 12 Dec 2022 12:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670847622;
        bh=aTyTIPTjTZYbLmyBEIrbRxk7euI2/MxtExgmBtnrjTY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PLrgYNOSsJWiLPkt62GvWOIvHJwzCNzFfxD2D2xZwArjPaq4K8S6NOfD0oooNKdjh
         +7k0zQgdmxCIPWE9XZaa3NfOEs1ZRupyd4W+5r1D6+3CED5ZncIplj4EzY1s2Y66aW
         aRN6dW54x6vXBBemppLcSWqETisk2OutCYqQOveG8GtNJ61z/zuPLy4/DVq0mmAt9q
         aiDqLXnPLWSEKUPpOmlObGnQTvNAH6i3+Q29neCiG6YDyk2BY2KZ0AY5sMHypRDNFp
         Hmk1pdw1NdLuNMS8ekhZ42TLQE/bmLeg/Cyhk23ZkuAOkMrDlLgeEKnaqmTHAoopk9
         Rqpyd3G/4DnGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D67AE21EF1;
        Mon, 12 Dec 2022 12:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 net-next 0/5] net: eliminate the duplicate code in the ct
 nat functions of ovs and tc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167084762217.17523.15812017198532370715.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 12:20:22 +0000
References: <cover.1670518439.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1670518439.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        pshelar@ovn.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, fw@strlen.de,
        marcelo.leitner@gmail.com, dcaratti@redhat.com, ozsh@nvidia.com,
        paulb@nvidia.com, i.maximets@ovn.org, echaudro@redhat.com,
        aconole@redhat.com, saeed@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  8 Dec 2022 11:56:07 -0500 you wrote:
> The changes in the patchset:
> 
>   "net: add helper support in tc act_ct for ovs offloading"
> 
> had moved some common ct code used by both OVS and TC into netfilter.
> 
> There are still some big functions pretty similar defined and used in
> each of OVS and TC. It is not good to maintain such big function in 2
> places. This patchset is to extract the functions for NAT processing
> from OVS and TC to netfilter.
> 
> [...]

Here is the summary with links:
  - [PATCHv4,net-next,1/5] openvswitch: delete the unncessary skb_pull_rcsum call in ovs_ct_nat_execute
    https://git.kernel.org/netdev/net-next/c/bf14f4923d51
  - [PATCHv4,net-next,2/5] openvswitch: return NF_ACCEPT when OVS_CT_NAT is not set in info nat
    https://git.kernel.org/netdev/net-next/c/779592892133
  - [PATCHv4,net-next,3/5] openvswitch: return NF_DROP when fails to add nat ext in ovs_ct_nat
    https://git.kernel.org/netdev/net-next/c/2b85144ab36e
  - [PATCHv4,net-next,4/5] net: sched: update the nat flag for icmp error packets in ct_nat_execute
    https://git.kernel.org/netdev/net-next/c/0564c3e51bc7
  - [PATCHv4,net-next,5/5] net: move the nat function to nf_nat_ovs for ovs and tc
    https://git.kernel.org/netdev/net-next/c/ebddb1404900

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


