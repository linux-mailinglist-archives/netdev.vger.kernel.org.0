Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8908361943B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiKDKKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiKDKKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B417F29818;
        Fri,  4 Nov 2022 03:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F688B82C8F;
        Fri,  4 Nov 2022 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B7F61C433B5;
        Fri,  4 Nov 2022 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667556615;
        bh=J8CZFUGOPx/AVEJK/Ycw4FGNnpIuJTlXcapx+R5G78I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rwB5HJxTncNR7alLN/v4lQn2UMPHzceEe8613CwUhaHSYmipDAT3a8m9rzPvxaxL7
         rwvzVWr8HRrajtFT4sXxxN5+fGQpsjQfvdU8AXB9UCp3O8MhTV1dHs0HdjTfjG2RzY
         IpEOBSPCnYuGnANWqShEZqeUI3OD9GAbR+J8q4aJrIlp3z/hW2SycnGYoScQEQFHvU
         wSUbsIfTdyWTNMGOsRJoqH1650nLPBcQ2lOmqpvdocn5tUvvY1oM3nv1rbNwie0LE+
         /2F6L1lI8i9hyP3E/Q880jjJ4rZW5yOh3r6hgTUAbbSnc0hl0cYqzkp7txP2McaTJU
         JoRvMfZCFOvsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 986A6E270FB;
        Fri,  4 Nov 2022 10:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hns3: fix get wrong value of function
 hclge_get_dscp_prio()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755661561.16370.3864120686996843410.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 10:10:15 +0000
References: <20221101074838.53834-1-huangguangbin2@huawei.com>
In-Reply-To: <20221101074838.53834-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, shenjian15@huawei.com,
        lanhao@huawei.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 1 Nov 2022 15:48:38 +0800 you wrote:
> As the argument struct hnae3_handle *h of function hclge_get_dscp_prio()
> can be other client registered in hnae3 layer, we need to transform it
> into hnae3_handle of local nic client to get right dscp settings for
> other clients.
> 
> Fixes: dfea275e06c2 ("net: hns3: optimize converting dscp to priority process of hns3_nic_select_queue()")
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: hns3: fix get wrong value of function hclge_get_dscp_prio()
    https://git.kernel.org/netdev/net/c/cfdcb075048c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


