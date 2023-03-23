Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5546C5F2E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjCWFu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjCWFuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:50:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFA02387E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C403362401
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 290CEC433AE;
        Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679550622;
        bh=7NIhmDrt8p9SGUSTTDCk4B2xgQ0nJYg2DoQ9PFOKE3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DIFMJNPp4+3kLrG1XMh0WemzcC95NyIBrVSOSFaxxvilQHreiW5vqjMDxdue/VPZG
         aVwXyFn8ofYLZy8UR5O+HF1QPEk2SEa+mcbXxhmvanEJmNOWv+EtjzjaNKS60b6+ws
         eOpq3eBtR4OS4JhbYYTu0zhu0kmhszJSNIBa304kLSjj/Wj5gVzYg8LqGj739j9nxl
         5KMRlkpYaJrbTeOMJxVhAwjvOUxSMOjftYxgIX1W8BySZcoeQitCSb0mxJkhSdGt0K
         i8XYSvc0RoLXrJTtRTihR8ezHVlzc0/nnoh+TVpaVXc0kyWN7SnIgxAkeSVbWGy+TO
         1uoNQpYqyt2xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DCE7E61B88;
        Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Remove phylink_state's an_enabled member
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955062205.14332.6474442964854871663.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:50:22 +0000
References: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
In-Reply-To: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, ioana.ciornei@nxp.com, kuba@kernel.org,
        Jose.Abreu@synopsys.com, netdev@vger.kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 15:57:31 +0000 you wrote:
> Hi,
> 
> Now that all the fixes and correctness patches have been merged, it is
> time to switch the two users that make use of .an_enabled to check the
> Autoneg bit in the advertising mask, and finally remove the
> .an_enabled member.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dpaa2-mac: use Autoneg bit rather than an_enabled
    https://git.kernel.org/netdev/net-next/c/99d0f3a1095f
  - [net-next,2/3] net: pcs: xpcs: use Autoneg bit rather than an_enabled
    https://git.kernel.org/netdev/net-next/c/459fd2f11204
  - [net-next,3/3] net: phylink: remove an_enabled
    https://git.kernel.org/netdev/net-next/c/4ee9b0dcf09f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


