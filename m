Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2825B5EB1DC
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 22:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiIZUK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 16:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiIZUKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 16:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69FF74AD47
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 13:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16B9DB80E97
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 20:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9EE4C433D7;
        Mon, 26 Sep 2022 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664223014;
        bh=keGAp657NW7EyPHzcR1GJ8FWEPaQL75oQRxlhCDiH64=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YOUzxp0gG/FBjzLvTsiRtPly4lLAabpIQ3cLO0MspRmRV62qmdBkWPjUVE5XWQ4WX
         jFHoJ12lM1vIcQQdeCIfKPlI0RF2BdSV35s6y6P4krSqnPK2pT+3gAUZXtlFJFJNdw
         RCjBlNUAl9Bs8ZMa25P0ZYvNb4YoFfeE4QiirS69vnyY2c49mk8670FA4a0cE801TB
         T4zNzb1blfYhgU4nYXzhCMCPTSaG75ycvQ27Hnag11hyvACE1heo6vQzdzxruEHEpL
         STwQF72T6IiaQG11GJr9u/iojAyz4PCTXOB1O5K406HgV+iT49aGlxnUHYPaSr5I8l
         Vd0tuCQy+ciEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0403E21EC2;
        Mon, 26 Sep 2022 20:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: ethernet: adin1110: Add missing
 MODULE_DEVICE_TABLE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422301465.2958.2256595966001128283.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 20:10:14 +0000
References: <20220922070438.586692-1-yangyingliang@huawei.com>
In-Reply-To: <20220922070438.586692-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, lennart@lfdomain.com,
        alexandru.tachici@analog.com, pabeni@redhat.com,
        davem@davemloft.net
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 22 Sep 2022 15:04:38 +0800 you wrote:
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.
> 
> Fixes: bc93e19d088b ("net: ethernet: adi: Add ADIN1110 support")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: ethernet: adin1110: Add missing MODULE_DEVICE_TABLE
    https://git.kernel.org/netdev/net-next/c/bb65131bb62c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


