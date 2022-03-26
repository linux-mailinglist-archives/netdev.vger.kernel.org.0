Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FDA4E81F0
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 17:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiCZQVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 12:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbiCZQVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 12:21:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB0E36173;
        Sat, 26 Mar 2022 09:20:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 158BF60A1C;
        Sat, 26 Mar 2022 16:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A24EC340EE;
        Sat, 26 Mar 2022 16:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648311611;
        bh=gLQ6lcM7EF3zjKaulJF5GfsvuJbldNZJplW99hjrbOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ecua63kYhUbCDbp6yse9D7A/x4y7xrlqlEKFGrU1OO9H9/xBfCcVD0S0R4rlJdKIa
         6rvAigl5ZMoPQ+1bP086OCWCGZptxOxqn2IIFmysSyhU4wmJ103KHzIW+h/Bt8Yu3E
         Dma6i//zAGLA/2OC6Tq80ITx5FEfU1ZnpmAQkUl8pp/bo7zhWhe9jTplQuEwajYA+e
         xRjq1XeXgM/JJVNpDtpfIDJrmwpnGBcrBXJEOCIPyMpg0U6VVaox+CDGubqZhQ7G3n
         ltqOw2c6XZZVv3/aFSTxEslkoNFNiIcGP9mlbfXQuFoIHrTtABQXd7ltfqkgR/aXyx
         kZJMcK52qi8Nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F636E6D402;
        Sat, 26 Mar 2022 16:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164831161125.22978.5795474197257933400.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Mar 2022 16:20:11 +0000
References: <20220326095105.54075-1-huangguangbin2@huawei.com>
In-Reply-To: <20220326095105.54075-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 26 Mar 2022 17:50:59 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (1):
>   net: hns3: fix phy can not link up when autoneg off and reset
> 
> Hao Chen (4):
>   net: hns3: fix ethtool tx copybreak buf size indicating not aligned
>     issue
>   net: hns3: add max order judgement for tx spare buffer
>   net: hns3: add netdev reset check for hns3_set_tunable()
>   net: hns3: add NULL pointer check for hns3_set/get_ringparam()
> 
> [...]

Here is the summary with links:
  - [net,1/6] net: hns3: fix ethtool tx copybreak buf size indicating not aligned issue
    https://git.kernel.org/netdev/net/c/877837211802
  - [net,2/6] net: hns3: add max order judgement for tx spare buffer
    https://git.kernel.org/netdev/net/c/a89cbb16995b
  - [net,3/6] net: hns3: clean residual vf config after disable sriov
    https://git.kernel.org/netdev/net/c/671cb8cbb9c9
  - [net,4/6] net: hns3: add netdev reset check for hns3_set_tunable()
    https://git.kernel.org/netdev/net/c/f5cd60169f98
  - [net,5/6] net: hns3: add NULL pointer check for hns3_set/get_ringparam()
    https://git.kernel.org/netdev/net/c/4d07c5936c25
  - [net,6/6] net: hns3: fix phy can not link up when autoneg off and reset
    https://git.kernel.org/netdev/net/c/ad0ecaef6a2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


