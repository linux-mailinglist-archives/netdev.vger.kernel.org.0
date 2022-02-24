Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA924C3669
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 21:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbiBXUAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 15:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbiBXUAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 15:00:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CE102763F9
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 12:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF5F2B8292D
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 20:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50EEEC340EF;
        Thu, 24 Feb 2022 20:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645732810;
        bh=Z+T0ZoAZiDSNnVD8TlEip33rQZ8SiODw6H5z0do/14Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TYfcpEGAYTSE2jjL2chEM5flrA5xM8dDSjHh7viqhR2D7FL50rC2mf/PRB7QpAmsQ
         MGHqWJ+04/1IFs7azb6y8AzWrw0Sz45bkiZZ0B5ANhTVDcXtt/XiwvAZeauxckffbk
         xuTKrbPbnrG4TApm07iVnO1adpLkLJ6pOuRB9XQdPDRQm+LFdAEEVAvGVN7SaVVw3F
         EkwLZD/Lf9GWXcVzy1qBK4WZQLWxQDBryLsYUKsELV6PRJiOOUj8xWNXj4XyTke0aF
         xqmt3CVzvljusJ7jEFw2Pjek1nm47bCs3/hmHWPkG6Y5MjrEh8MTKeIs33GCRv8XXb
         42lnMWeFgp3Jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BFE2EAC09A;
        Thu, 24 Feb 2022 20:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-02-23
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164573281017.27321.16168476427077439398.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 20:00:10 +0000
References: <20220223185424.2129067-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220223185424.2129067-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 23 Feb 2022 10:54:22 -0800 you wrote:
> This series contains updates to ixgbe and ixgbevf drivers.
> 
> Yang Li fixes incorrect indenting as reported by smatch for ixgbevf.
> 
> Piotr removes non-inclusive language from ixgbe driver.
> 
> The following are changes since commit 6ce71687d4f4105350ddbc92aa12e6bc9839f103:
>   Merge branch 'locked-bridge-ports'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 10GbE
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] ixgbevf: clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/c6fbfdcbcef9
  - [net-next,2/2] ixgbe: Remove non-inclusive language
    https://git.kernel.org/netdev/net-next/c/93b067f154b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


