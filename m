Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E804D4D8F6F
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 23:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbiCNWVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 18:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245521AbiCNWVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 18:21:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82ADF3D4B7;
        Mon, 14 Mar 2022 15:20:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B76F61403;
        Mon, 14 Mar 2022 22:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7458AC340EC;
        Mon, 14 Mar 2022 22:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647296410;
        bh=vWDC0X+KNpASrrpeIFEc2I5l3NpOaM+7axOMNFAuyds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dn80RJKyKMe77g+BmK+pu+8wjkYK6acTz1IMBqLAGwzA7addD67jT67tYA2wxnWvC
         E80HNfv2D42EzSW0iWGCnf4E4Dpuci0/FwOHyhgB2wfi93N/dfbalzkAT9WNTKwaWv
         N1kytU2b/4J0IsQLDX0/1dL4Tz+cgHfvEI3nsN9yv8S6kzUoRzW+rZ6e8XQwsZgwfI
         vHHVWx1hk5mwCJ1GXLuYl3bltdCYr110tbLQsf3aux8l0JixTLfkGHfAUztZG4eL8p
         eno2pbS2oMBUrf/VWdcqRxFzi+xkwLlYY7NS+t4O3VkrqR9KEOwQAeUASQareVI0Ks
         vqAkcbjIcMxwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A054E73C67;
        Mon, 14 Mar 2022 22:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: phy: marvell: Fix invalid comparison in the
 resume and suspend functions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164729641036.12900.12801827635142867421.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 22:20:10 +0000
References: <20220312201512.326047-1-kurt@x64architecture.com>
In-Reply-To: <20220312201512.326047-1-kurt@x64architecture.com>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev@vger.kernel.org, kabel@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, charles-antoine.couret@nexvision.fr,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 12 Mar 2022 15:15:13 -0500 you wrote:
> This bug resulted in only the current mode being resumed and suspended when
> the PHY supported both fiber and copper modes and when the PHY only supported
> copper mode the fiber mode would incorrectly be attempted to be resumed and
> suspended.
> 
> Fixes: 3758be3dc162 ("Marvell phy: add functions to suspend and resume both interfaces: fiber and copper links.")
> Signed-off-by: Kurt Cancemi <kurt@x64architecture.com>
> 
> [...]

Here is the summary with links:
  - [net,v3] net: phy: marvell: Fix invalid comparison in the resume and suspend functions
    https://git.kernel.org/netdev/net/c/837d9e49402e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


