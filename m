Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98ED94CB72D
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbiCCGu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiCCGu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:50:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FD41693AD
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:50:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C519AB8240A
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BBA2C340E9;
        Thu,  3 Mar 2022 06:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646290210;
        bh=2Q7a5/WBgs45rmX4n08Xr205mwFrKfAjblymj5fqaJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ph4Iz1o2iFWrSoqDOHrYqopDpoan7GbBj2wOhV//k/5ZwySFAsTAgo7iyAB6+zj3a
         dAg7D2PhowDof011PbWJmHmprJl16MK4tkgcI6z54q2M3YL+R+SVxRufV7n9Rs1ylb
         0HDJN4MskZBIux1MJc+5iVTCKPhYYrL0W0u7nzRuSX+ijsZij34OcIVgRElPhBps9z
         QcMpppzjrjeIN+/xkp4tHgagogkb93kt4HLtpkUuFNHrTWsoiJbOIW6UDhtcPKPSGo
         qyxvgpgSwIARikf4a1P1TyGPCMSoIygBb3ILQMdndK7VVmpauHGMgiTcza9d91TP9C
         nNCyr91eyOGwA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69792E7BB08;
        Thu,  3 Mar 2022 06:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: don't error out cmode set
 on missing lane
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164629021042.19346.5102114302040055091.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:50:10 +0000
References: <cd95cf3422ae8daf297a01fa9ec3931b203cdf45.1646050203.git.baruch@tkos.co.il>
In-Reply-To: <cd95cf3422ae8daf297a01fa9ec3931b203cdf45.1646050203.git.baruch@tkos.co.il>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, baruch.siach@siklu.com,
        netdev@vger.kernel.org, linux@armlinux.org.uk
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Feb 2022 14:10:02 +0200 you wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> When the given cmode has no serdes, mv88e6xxx_serdes_get_lane() returns
> -NODEV. Earlier in the same function the code skips serdes handing in
> this case. Do the same after cmode set.
> 
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: mv88e6xxx: don't error out cmode set on missing lane
    https://git.kernel.org/netdev/net-next/c/13b0bd2e62e7
  - [net-next,2/2] net: dsa: mv88e6xxx: support RMII cmode
    https://git.kernel.org/netdev/net-next/c/002028857384

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


