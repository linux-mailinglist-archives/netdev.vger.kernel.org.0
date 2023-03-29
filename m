Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815686CD418
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 10:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjC2IKj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 04:10:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjC2IK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 04:10:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB83D4489
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 01:10:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F24561B5F
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 08:10:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C11D4C433A4;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680077426;
        bh=kLpb7JphX+wamUH/nKM9YjEVqnfXtZ40oo3epDzbarE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IaDBTwzABZMSHvKmUiPfJIqbKkDU8RTw82eVq1ifOAblrJ6srzNuB2up1kyLqNaxk
         BRHf96L6XgdzvLkLU1RD9hV9She7+lSlElMCmOl+Q9eWtWA7dMIxVK+OFMcSaNg9zo
         EafJADfZluoRKDzaKeKwtTTryz41bzZ9mny43Gwm4SZF8PVj15VgZf2McN5CCWA54R
         ZxinEg+/FMXiq5AihN77yusbJcq00Zp1nd396VkrlHXzjSx4z/+8DwKjzoVnpMsL8i
         XlNgCzpOyAuQr4vaZpS18q5xC5cJhBB+fzPW0bceOt5RGH+7MivIwlbpZNS9YtLTkB
         eXVH6wWOphdcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A3092E55B22;
        Wed, 29 Mar 2023 08:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next] net: hns3: support wake on lan configuration and
 query
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168007742666.16006.15919086477916702760.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Mar 2023 08:10:26 +0000
References: <20230327135504.47367-1-lanhao@huawei.com>
In-Reply-To: <20230327135504.47367-1-lanhao@huawei.com>
To:     Hao Lan <lanhao@huawei.com>
Cc:     andrew@lunn.ch, simon.horman@corigine.com, davem@davemloft.net,
        kuba@kernel.org, alexander.duyck@gmail.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        edumazet@google.com, pabeni@redhat.com, richardcochran@gmail.com,
        shenjian15@huawei.com, netdev@vger.kernel.org,
        wangjie125@huawei.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 27 Mar 2023 21:55:04 +0800 you wrote:
> The HNS3 driver supports Wake-on-LAN, which can wake up
> the server from power off state to power on state by magic
> packet or magic security packet.
> 
> ChangeLog:
> v1->v2:
> Deleted the debugfs function that overlaps with the ethtool function
> from suggestion of Andrew Lunn.
> 
> [...]

Here is the summary with links:
  - [v4,net-next] net: hns3: support wake on lan configuration and query
    https://git.kernel.org/netdev/net-next/c/3b064f541be8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


