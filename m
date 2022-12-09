Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9B5648120
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 11:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiLIKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 05:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLIKuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 05:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC967326D2;
        Fri,  9 Dec 2022 02:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6980662213;
        Fri,  9 Dec 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BD80BC4339E;
        Fri,  9 Dec 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670583016;
        bh=1Z4MTBuUheQSqBo/QMyK6dTREtkDgn0tx4E9Algvv9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MVBlkBY5Ewgwn+q/vnQjgzukmqdku9eBcNz5MxYlDLzJaeFBZr8UKfypbjP8B85Rd
         krsUoK7KvazTBqszMW/+oKTRBIKkv08q0Al/TUp9TLr3LXyWWoAugySHL53ED4jaUA
         9LDwkeg+hu3kXl3Kcx2sjnJoblPeVTGz9VY+52ni1SPAmwl/p8wXfSwHQvr11NA/aE
         eyOIm8kPZbaD9MRlhAe6bNhO299p/sNr465j6iOJJORWrN8JO9GYtQIYAWRyI3OosC
         tjyH6qj1kfAf/lCouJWsFLSjuzKdDeB/w8VZR1kjN58loVhTpKSbVv0FFUFlf1tUIm
         uqhMNkZ+Gm/FQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F86CE1B4D8;
        Fri,  9 Dec 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [PATCH v9 net-next] net: openvswitch: Add support to count
 upcall packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167058301664.16848.12349707069284287031.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 10:50:16 +0000
References: <20221207013857.4066561-1-wangchuanlei@inspur.com>
In-Reply-To: <20221207013857.4066561-1-wangchuanlei@inspur.com>
To:     wangchuanlei <wangchuanlei@inspur.com>
Cc:     leon@kernel.org, jiri@resnulli.us, echaudro@redhat.com,
        alexandr.lobakin@intel.com, pabeni@redhat.com, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        wangpeihui@inspur.com, netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 6 Dec 2022 20:38:57 -0500 you wrote:
> Add support to count upall packets, when kmod of openvswitch
> upcall to count the number of packets for upcall succeed and
> failed, which is a better way to see how many packets upcalled
> on every interfaces.
> 
> Signed-off-by: wangchuanlei <wangchuanlei@inspur.com>
> 
> [...]

Here is the summary with links:
  - [v9,net-next] net: openvswitch: Add support to count upcall packets
    https://git.kernel.org/netdev/net-next/c/1933ea365aa7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


