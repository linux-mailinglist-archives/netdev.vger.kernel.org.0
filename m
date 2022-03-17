Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8914DBDDF
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 05:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiCQE40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 00:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiCQE4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 00:56:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0A111A98A
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 21:37:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E2A1B81E15
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 04:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C763AC340ED;
        Thu, 17 Mar 2022 04:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647490810;
        bh=cPbYeZdY0uu4gVBvvy1FWYxqnnjpW8VRCNBEQUmmAWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AddaqbsReibWxnoek1UYnD1oY54/5g5BWpngd74r471RmHDyehMsHdqxv3O3Z69m1
         Hmp1q20Scmc/1hzcH3ZfcutGBH7n1ptqVDr5hT2uWqpQ5RZvlsOqkAqfselx0RtcVb
         RvB/UbMx1mgtgRFW5I4PJH35MVtYnxx6MVQM1f0xdRDyrPym/6w+3repNxVqWIGTUu
         5kShyIYcHA2Llndb4vrA3eobcY1VqTf9ldtdjqcvkNIEXPi56UXOVmyOe/lcZw738k
         O7Dk9EKCeKJuqEq2mGFp6qjQ7z/OBu5wVhHRmX33FhIPFaofp3GLFZ263r9pBHiL8V
         aoblrns+ldxVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA271E6D3DD;
        Thu, 17 Mar 2022 04:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] flow_offload: add tc vlan push_eth and
 pop_eth actions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164749081069.12338.12201015148048235485.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 04:20:10 +0000
References: <20220315110211.1581468-1-roid@nvidia.com>
In-Reply-To: <20220315110211.1581468-1-roid@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, maord@nvidia.com, kuba@kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, jiri@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Mar 2022 13:02:08 +0200 you wrote:
> Offloading vlan push_eth and pop_eth actions is needed in order to
> correctly offload MPLSoUDP encap and decap flows, this series extends
> the flow offload API to support these actions and updates mlx5 to
> parse them.
> 
> v2:
> - wrap vlan push_eth related members into struct.
> - merge two helpers into one.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] net/sched: add vlan push_eth and pop_eth action to the hardware IR
    https://git.kernel.org/netdev/net-next/c/ab95465cde23
  - [net-next,v2,2/3] net/mlx5e: MPLSoUDP decap, use vlan push_eth instead of pedit
    https://git.kernel.org/netdev/net-next/c/697319b2954f
  - [net-next,v2,3/3] net/mlx5e: MPLSoUDP encap, support action vlan pop_eth explicitly
    https://git.kernel.org/netdev/net-next/c/725726fd1fb7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


