Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4813B6636E5
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 02:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbjAJBuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 20:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbjAJBuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 20:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE3FE02D
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 17:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60838614A5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AA76C433F1;
        Tue, 10 Jan 2023 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673315416;
        bh=9C8g7qSPHQOW3UqnWYPH+1aWk7a3LSKONgBFJJTqzn0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z9HKZHlmqCmXMiobY8FhO1VFabqKPR/Z6eKyf5C6CufDMusAL6JT2Rlmt8t1TtfQ3
         3XkrFTEgKpXzg9aoMPL1JRUznEpvOM2vP8SG/tyoueFA7tqVVM/ZKlh3CPZ3VlDVMP
         sahq4YUdqdQaYxiU08rpDmnxhXBuK5rQLrZ/N824nyuwf38AkDAwmVZMp2WS2LvyFw
         I6gm4V7ZVJQ5b6j7hZtaUhTRa4eQKBjn8wVveTPtubPJNSmuQKtmPyRDlIroAhC1Lx
         bNwIwfgDavJhPTG0gn6Qj6dvuTaY0cMeLEkN4r+h5+3lsVdEwCi4HDw3wZxLoTFjVL
         duu4q6MJII0wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65386E21EEA;
        Tue, 10 Jan 2023 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised Support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167331541640.22546.5854841980034591622.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 01:50:16 +0000
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jamie.gloudon@gmx.fr, netdev@vger.kernel.org,
        sasha.neftin@intel.com, naamax.meir@linux.intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  3 Jan 2023 15:06:53 -0800 you wrote:
> From: Jamie Gloudon <jamie.gloudon@gmx.fr>
> 
> This enables link partner advertised support to show link modes and
> pause frame use.
> 
> Signed-off-by: Jamie Gloudon <jamie.gloudon@gmx.fr>
> Tested-by: Naama Meir <naamax.meir@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] e1000e: Enable Link Partner Advertised Support
    https://git.kernel.org/netdev/net-next/c/cbdbb58b6c79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


