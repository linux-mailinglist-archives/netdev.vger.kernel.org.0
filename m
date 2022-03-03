Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96EE74CB6B5
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiCCGLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiCCGLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:11:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA277165C3C
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E15EB82132
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35C59C340F5;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646287813;
        bh=hRfZJw0/QCkYMvTtJZNgf4JZtzzTCNGGnMoSbb5IaY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O82Jsczrj2w0CV/k+Dt/F0+vU622T4sHJVRmkKW6vIGXg29YXO1vNskMTXem8r44c
         mphuiIUPgpdE6ZfX5Qm/NtYHYSK350Go41B82p3MyQTjjDz2OM4tymEEpwyRG59gKd
         mFAPXODcjUzR4qlMTjrGNlyafV8TIerrgMTNmTvz/cxj5ckpRgdprjze3b0s6yDazf
         TB6FNv8mhM68DIGee1YLWouT7+iPajNobWWCXmfVj7kQHc/5Lj6qGdoqIiVU1tKbNZ
         cSJWliDSG9VPxV9HsebpA8e2uYUpuhFzo+5puspHw/aMxYw4PO8PWyVitayjScqVoE
         vpqpALzpcAWHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 165E8EAC09E;
        Thu,  3 Mar 2022 06:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: use %pe for printing errors
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628781308.31171.12774951759342312831.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:10:13 +0000
References: <E1nOyEI-00Buu8-K9@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nOyEI-00Buu8-K9@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 01 Mar 2022 08:51:34 +0000 you wrote:
> Convert phylink to use %pe for printing error codes, which can print
> them as errno symbols rather than numbers.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/phy/phylink.c | 20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)

Here is the summary with links:
  - [net-next] net: phylink: use %pe for printing errors
    https://git.kernel.org/netdev/net-next/c/ab1198e5a1dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


