Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A93F14E57D8
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 18:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343792AbiCWRvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 13:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343780AbiCWRvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 13:51:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95BF8566F
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 10:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 852B9B81FFB
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 17:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25334C340F6;
        Wed, 23 Mar 2022 17:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648057812;
        bh=hRmBIq8XyNQ6t7Q3zXREFYvNBAhGHf/4sAhPKhPB4hw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iuIF4qeAB7s6G26nmsa86P6kuqRXrl4nOLBucbE5Ij0BpGXp7sUl5s+eGjfuijUe8
         wj/c/rsAoqkRtsL1sOz/FQeY1VGCYFyTL414Bwl3a/ZDvs4nXqqb2Yjfl2dpZaGr54
         bs80g64kdXVl74KvcyIbWb2b2xt3I5rYta9wsBRukPNPuzq3V61Ut8pJIZlU15tR9b
         c7U1d60bQEIbeDp+llTQkUgqwj9UcYMzBJZLazQG34r86B3+Umk3zMYnis7ADynoy6
         569wpg96VZdz8j7Ai3V2vDLCdkWPVMAvR8AEPqyTdBbft4eYMTJ6k6vSpcZPnb/hLd
         DJzLMUD1KBb7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0422DE7BB0B;
        Wed, 23 Mar 2022 17:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net] net/sched: fix incorrect vlan_push_eth dest field
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164805781201.23946.15379782665249511735.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 17:50:12 +0000
References: <20220323092506.21639-1-louis.peens@corigine.com>
In-Reply-To: <20220323092506.21639-1-louis.peens@corigine.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, maord@nvidia.com,
        roid@nvidia.com, netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Mar 2022 11:25:06 +0200 you wrote:
> From: Louis Peens <louis.peens@corigine.com>
> 
> Seems like a potential copy-paste bug slipped in here,
> the second memcpy should of course be populating src
> and not dest.
> 
> Fixes: ab95465cde23 ("net/sched: add vlan push_eth and pop_eth action to the hardware IR")
> Signed-off-by: Louis Peens <louis.peens@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net] net/sched: fix incorrect vlan_push_eth dest field
    https://git.kernel.org/netdev/net-next/c/054d5575cd6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


