Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90DEC4D5564
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 00:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344694AbiCJXbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 18:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344715AbiCJXbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 18:31:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CB416BF8C;
        Thu, 10 Mar 2022 15:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4605B82977;
        Thu, 10 Mar 2022 23:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80C7EC340F9;
        Thu, 10 Mar 2022 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646955010;
        bh=OmiH1rkkwDE4MvdTK+ueV6th3KQ1rH29do+nnexNmeM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZIBNW1cIk0srYcw20shDMZxPiSx7n2DNC1oZF9TPp/bjBXUN+4aEHZn8G6UlZBxxe
         1OPIXaekuHJhkz4i2fbg2ebFIvkK/MmCp0GkBwvD5cZgDptuFLrBN93cuA9m9uW783
         khSYVo8WULzi40Apccxg663pOgfbs5opKnyeTa+z4EDGPahLn3xX8PypOW7ZkMhJfC
         LYJvjpoKuvoSYJ0tj+Dc4e7eTDDDmyYkaYmUphCEw19vE/NSSOF/x7jf8gireqIfLf
         hyye3h1IvPlRbnQmlQKl/lIbqU+/oYd7MXyBkYTvKy7QsogvSqxyxxLGKDcgvLoLAT
         tg5c3o4YAe+Mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D119EAC095;
        Thu, 10 Mar 2022 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ice: Fix race condition during interface enslave
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164695501044.21304.15926630200023275833.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 23:30:10 +0000
References: <20220310171641.3863659-1-ivecera@redhat.com>
In-Reply-To: <20220310171641.3863659-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, poros@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Mar 2022 18:16:41 +0100 you wrote:
> Commit 5dbbbd01cbba83 ("ice: Avoid RTNL lock when re-creating
> auxiliary device") changes a process of re-creation of aux device
> so ice_plug_aux_dev() is called from ice_service_task() context.
> This unfortunately opens a race window that can result in dead-lock
> when interface has left LAG and immediately enters LAG again.
> 
> Reproducer:
> ```
> #!/bin/sh
> 
> [...]

Here is the summary with links:
  - [net] ice: Fix race condition during interface enslave
    https://git.kernel.org/netdev/net/c/5cb1ebdbc434

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


