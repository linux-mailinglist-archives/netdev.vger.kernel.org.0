Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0E06B0821
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 14:13:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231533AbjCHNNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 08:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbjCHNNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 08:13:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D1AC9C0F;
        Wed,  8 Mar 2023 05:10:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F23E617BA;
        Wed,  8 Mar 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E128EC433A4;
        Wed,  8 Mar 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678281018;
        bh=8Y4T3yo8E0yQp+AcWeUBrYSVWDuptqSmOv+yzOUy1PQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NggUpNoW5LCwvjo04XHqqhuNOza1GMkljl0Jm1d+hGxb5jqLC+PljiH4VDuFPjHF5
         iW+bZTSc45AReAhA538/46FJexio4KYjpC1Cx09Vbw6NNva2Q2jFbCKcOpQQdwT9jg
         FUZ3sM3iMnZ8oxaU3w682oTBcNaV7dY8YsLXTOC48RfUrY9TBA02zXe+R1dNjd/y/8
         hGAfcVpHONrv2Ry6yU5/2M0bpNKOWkh/tC47O+O58sQ9E6rDiVGwix7466wjEPhuNC
         EnOQ4dmuYSlkSYT9cmzVfscuw+NIVcDOnK8L3d6MPTBCWbBoRSaDtnwtlY5lQQFn0K
         QeeD9R7H5MpKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C59DCE68C16;
        Wed,  8 Mar 2023 13:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] emulex/benet: clean up some inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167828101880.17807.14568658802620507188.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 13:10:18 +0000
References: <20230307054138.21632-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230307054138.21632-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     ajit.khaparde@broadcom.com, sriharsha.basavapatna@broadcom.com,
        somnath.kotur@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  7 Mar 2023 13:41:38 +0800 you wrote:
> No functional modification involved.
> 
> drivers/net/ethernet/emulex/benet/be_cmds.c:1120 be_cmd_pmac_add() warn: inconsistent indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4396
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - emulex/benet: clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/ecf729f93bd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


