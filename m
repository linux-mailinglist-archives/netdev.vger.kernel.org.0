Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7A8567A78
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 01:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiGEXAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 19:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbiGEXAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 19:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD631837D;
        Tue,  5 Jul 2022 16:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 057AE61D54;
        Tue,  5 Jul 2022 23:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60881C341C8;
        Tue,  5 Jul 2022 23:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657062013;
        bh=sMHUtfx37inBiWE4NcZNRyuniWlUq58v05CnvpEccyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KomGJmSqaz3Pz5ke9dgFZ1+D/ri6SYl4a2wp0jMIgoOOxiIjczznb5R/2O/gmAtok
         yPyDLMUf9ZgKDlk7DPjNOCPHr2QlseBGc2GlIlwRT1oPi6wuY89r0rJJuY4uKY3ZJo
         mrsF8TaOpKt0/Qj3P9SdXcma3000Sj7N0mVoUCyZUlwwMfQUiMd9EX/evdc5b0I0+O
         HyL8EC0HaGmFBE7nPVuq6lmpG/oHQ7toXn0DCB446GA44JAbgNyqRkFyEDMENMds6s
         nxKNlgwKhWjUFuMCIzGbQqF0aP/38Y42clwKUyEAB3jtSE6dWCRZLN3ntw288oTGea
         fLXmemwPSu4gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 394C8E45BDE;
        Tue,  5 Jul 2022 23:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: remove neterion/vxge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165706201323.1820.7088439299724265295.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Jul 2022 23:00:13 +0000
References: <20220701044234.706229-1-kuba@kernel.org>
In-Reply-To: <20220701044234.706229-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, corbet@lwn.net, jdmason@kudzu.us,
        vburru@marvell.com, jiawenwu@trustnetic.com,
        linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 30 Jun 2022 21:42:34 -0700 you wrote:
> The last meaningful change to this driver was made by Jon in 2011.
> As much as we'd like to believe that this is because the code is
> perfect the chances are nobody is using this hardware.
> 
> Because of the size of this driver there is a nontrivial maintenance
> cost to keeping this code around, in the last 2 years we're averaging
> more than 1 change a month. Some of which require nontrivial review
> effort, see commit 877fe9d49b74 ("Revert "drivers/net/ethernet/neterion/vxge:
> Fix a use-after-free bug in vxge-main.c"") for example.
> 
> [...]

Here is the summary with links:
  - [net-next] eth: remove neterion/vxge
    https://git.kernel.org/netdev/net-next/c/f05643a0f60b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


