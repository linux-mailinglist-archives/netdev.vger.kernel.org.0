Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A2055028A
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbiFRDkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbiFRDkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182D6522E2;
        Fri, 17 Jun 2022 20:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A75DE61F73;
        Sat, 18 Jun 2022 03:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13FC0C341C6;
        Sat, 18 Jun 2022 03:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655523613;
        bh=hohAOtR0LpeUR1occu7KFZMNLwRI76rxHxBy0YVtukY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y1NtvL8PD9ZLuJ7ylS2p6Jcq4s4ri9YyD+I5hr/iL12KTLmGz8bBlPay5o1ORfpxK
         i6fA8J5C6LWtW1d2DC73F7PcuJDGeOHGO3DxcZF9SMo5Dps37UleYdZhXCNwDAH90v
         G0mgoBNNvWmRjaDJjT9u+FHq0mnX6VZx8MvYbpEEtbIWSU+0CzDO/2JRxopV939WW/
         2GQLBI6UFyTkiCSBBhexHiEAzrbvzTo41lvICCYXQ8X8ulOvmLYumWTPJMsNgh3r2k
         dY/6QFgIELJu2zdG1egIs930efft8Vfhn36owAAkfLgfraexO6exwokNZ9Co4ZCJv8
         S/ntGqBWXKP0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00079FD99FF;
        Sat, 18 Jun 2022 03:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] ax25: use GFP_KERNEL in ax25_dev_device_up()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552361299.10717.7998088987527311239.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:40:12 +0000
References: <20220616152333.9812-1-pjlafren@mtu.edu>
In-Reply-To: <20220616152333.9812-1-pjlafren@mtu.edu>
To:     Peter Lafreniere <pjlafren@mtu.edu>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        ralf@linux-mips.org, lkp@intel.com, dan.carpenter@oracle.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 16 Jun 2022 11:23:33 -0400 you wrote:
> ax25_dev_device_up() is only called during device setup, which is
> done in user context. In addition, ax25_dev_device_up()
> unconditionally calls ax25_register_dev_sysctl(), which already
> allocates with GFP_KERNEL.
> 
> Since it is allowed to sleep in this function, here we change
> ax25_dev_device_up() to use GFP_KERNEL to reduce unnecessary
> out-of-memory errors.
> 
> [...]

Here is the summary with links:
  - [v4] ax25: use GFP_KERNEL in ax25_dev_device_up()
    https://git.kernel.org/netdev/net-next/c/f0623340fd2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


