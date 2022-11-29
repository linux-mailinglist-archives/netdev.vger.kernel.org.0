Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B92363B7B8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbiK2CUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235001AbiK2CUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D1E2AC50;
        Mon, 28 Nov 2022 18:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B1926122E;
        Tue, 29 Nov 2022 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB354C433D7;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669688416;
        bh=33C7XakMaq3EQRy9/lGU3kjLAYg4qxzb8eMuU2yoIFQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lj/SyOsei93LbftPdWzqtk0fRy5eP0QLXDrXl+BjJ5HxKiiS95w15jzzqDp7LQ4FW
         EhqX5c+QDtGvJDTmueO/+gJOViH/ZQnybT9tuXySdsGeXkDOpYedEKuu3MHwi1gZsg
         gkRxHaZRHF2Tp6Tnlmq6RxFr7l9zSQCUe06AcTC3FIRYd+Z/CIuC7S4fnOQLQIypic
         HCZkhSRIQyVaU637oulIdU2HWJf94BmaKE2m9XzQLHeO8OVLnlZuuyV+qXyZWbsegW
         0bc8uVk27bOCMCweN+gSGL0Wm4nhUwycATpvOcfHbK+sVIdis0j3WWHV5QEK+MJOxM
         mCdFiMICpPatw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB142C395EC;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mptcp: More fixes for 6.1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968841676.21086.3587694150768169897.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 02:20:16 +0000
References: <20221128154239.1999234-1-matthieu.baerts@tessares.net>
In-Reply-To: <20221128154239.1999234-1-matthieu.baerts@tessares.net>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     dcaratti@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, mathew.j.martineau@linux.intel.com,
        mengensun@tencent.com, imagedong@tencent.com, pabeni@redhat.com,
        benbjiang@tencent.com, linux-kernel@vger.kernel.org,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Nov 2022 16:42:36 +0100 you wrote:
> Patch 1 makes sure data received after a close will still be processed and acked
> as exepected. This is a regression for a commit introduced in v5.11.
> 
> Patch 2 fixes a kernel deadlock found when working on validating TFO with a
> listener MPTCP socket. This is not directly linked to TFO but it is easier to
> reproduce the issue with it. This fixes a bug introduced by a commit from v6.0.
> 
> [...]

Here is the summary with links:
  - [net,1/2] mptcp: don't orphan ssk in mptcp_close()
    https://git.kernel.org/netdev/net/c/fe94800184f2
  - [net,2/2] mptcp: fix sleep in atomic at close time
    https://git.kernel.org/netdev/net/c/b4f166651d03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


