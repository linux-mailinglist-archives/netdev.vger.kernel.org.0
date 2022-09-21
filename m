Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE66D5E567C
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 01:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231248AbiIUXAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 19:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiIUXAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 19:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D22F98CA1;
        Wed, 21 Sep 2022 16:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F88F632FE;
        Wed, 21 Sep 2022 23:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7D8FC43470;
        Wed, 21 Sep 2022 23:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663801215;
        bh=8HwKAux3bph8RNtaqSp//isVW/UI71GTvyFC0ukdryo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O9wxnHNPrg1VNKju5oUhxbxZLfL5v6eTPKw2FTgAiBZy5ezUnfovvZJ/ETNssF6M4
         uIq5AaIbIbzySUWPtvYkzy10kYL6NqlGYcC3jorucF08pOboyNTUvhzLUZYY5F086F
         uvZkfP4k/+H7K2rc7+WLHmHjbJ4P0Ldk41lGE3UajY72wZwn/8DYQ//59+TGkh95Nr
         r6KCQx4ONgDEACpaw1DP978cfSY4O9X+e4VWlT/kODDuCIdSF65rHPT2AxTJ7AoILo
         YYt3dxdt5ekm3PLQoYht1+Vu+gXru/LNNJqFp5pB8PUH7oYuqcJdJQREaG8KkTt0j0
         8JlC1SayIYSRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB076E4D03D;
        Wed, 21 Sep 2022 23:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166380121576.23271.14681054591525406424.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 23:00:15 +0000
References: <20220916023803.23756-1-huangguangbin2@huawei.com>
In-Reply-To: <20220916023803.23756-1-huangguangbin2@huawei.com>
To:     huangguangbin (A) <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        lanhao@huawei.com, shenjian15@huawei.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 16 Sep 2022 10:37:59 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> Guangbin Huang (2):
>   net: hns3: optimize converting dscp to priority process of
>     hns3_nic_select_queue()
>   net: hns3: add judge fd ability for sync and clear process of flow
>     director
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hns3: add support for external loopback test
    https://git.kernel.org/netdev/net-next/c/04b6ba143521
  - [net-next,2/4] net: hns3: optimize converting dscp to priority process of hns3_nic_select_queue()
    https://git.kernel.org/netdev/net-next/c/dfea275e06c2
  - [net-next,3/4] net: hns3: refactor function hclge_mbx_handler()
    https://git.kernel.org/netdev/net-next/c/09431ed8de87
  - [net-next,4/4] net: hns3: add judge fd ability for sync and clear process of flow director
    https://git.kernel.org/netdev/net-next/c/236b8f5dc75d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


