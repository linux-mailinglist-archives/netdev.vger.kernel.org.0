Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0D450855C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 12:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377437AbiDTKDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 06:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351387AbiDTKDB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 06:03:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150BC1ADB9;
        Wed, 20 Apr 2022 03:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D9E2616F9;
        Wed, 20 Apr 2022 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF5FEC385AB;
        Wed, 20 Apr 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650448814;
        bh=dhQfBfjBfd8kHtAso1G7CgeR9goZyo+iYz7i15tnhZU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jziENf8qx3k6pjF3Qapz2Au1lB/stnW91cw12IXcoWDLzfujWTs7BgfgJXCW6FQkb
         E5YW53m9a2HFCyN6zG4TM9Gp1Fjfuc+Mvw/Vsu/VrBNy7gALNg3LH455pvFfC3uTZq
         4UJMwgX5agPYWeaIU2orl88mEfjR10RP1bQjs9c+d2h9OEiwd49xLzyRQ1zC151N6y
         w0yZs+Y/9lTPIvVMjc3bRv7lMYMFt2GawH34yPtmCOZ3KNNq2jJr+oAYZjMOsjER2J
         4qV2CacYjbBfULBTpSdyBLZOWYUcmptzF1IDSD77CJ5exG72Uk/wO98qEL8sPeGxRF
         +aH0ruS5yCu5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2AD8F0383D;
        Wed, 20 Apr 2022 10:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/9] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165044881465.4054.9283567188625331679.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Apr 2022 10:00:14 +0000
References: <20220419032709.15408-1-huangguangbin2@huawei.com>
In-Reply-To: <20220419032709.15408-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Apr 2022 11:27:00 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> Change logs:
> V1 -> V2:
>  - Fix failed to apply to net-next problem.
> 
> Hao Chen (3):
>   net: hns3: refactor hns3_set_ringparam()
>   net: hns3: add log for setting tx spare buf size
>   net: hns3: remove unnecessary line wrap for hns3_set_tunable
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/9] net: hns3: add ethtool parameter check for CQE/EQE mode
    https://git.kernel.org/netdev/net-next/c/286c61e72797
  - [V2,net-next,2/9] net: hns3: refactor hns3_set_ringparam()
    https://git.kernel.org/netdev/net-next/c/07fdc163ac88
  - [V2,net-next,3/9] net: hns3: refine the definition for struct hclge_pf_to_vf_msg
    https://git.kernel.org/netdev/net-next/c/6fde96df0447
  - [V2,net-next,4/9] net: hns3: add failure logs in hclge_set_vport_mtu
    https://git.kernel.org/netdev/net-next/c/bcc7a98f0d3c
  - [V2,net-next,5/9] net: hns3: add log for setting tx spare buf size
    https://git.kernel.org/netdev/net-next/c/2373b35c24ff
  - [V2,net-next,6/9] net: hns3: update the comment of function hclgevf_get_mbx_resp
    https://git.kernel.org/netdev/net-next/c/2e0f53887011
  - [V2,net-next,7/9] net: hns3: fix the wrong words in comments
    https://git.kernel.org/netdev/net-next/c/9c657cbc2c15
  - [V2,net-next,8/9] net: hns3: replace magic value by HCLGE_RING_REG_OFFSET
    https://git.kernel.org/netdev/net-next/c/350cb4409246
  - [V2,net-next,9/9] net: hns3: remove unnecessary line wrap for hns3_set_tunable
    https://git.kernel.org/netdev/net-next/c/29c17cb67271

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


