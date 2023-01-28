Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D41C67F66D
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 09:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjA1IkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 03:40:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjA1IkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 03:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1141CF6D;
        Sat, 28 Jan 2023 00:40:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A9A3B8123D;
        Sat, 28 Jan 2023 08:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B5F2BC4339E;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674895217;
        bh=jDA4w6y762efolnnY+K19QZa9th064jEA9pb35qB3NA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cWb7s0zteTWg1CwHO40MmFcOhvStCZqNJfWQPW1StLqPifSSlrCEOJpzEkQyqb9eP
         0ya1v17mKMZBYgGqWSCnx3/EFqnzoicbRIvzYXf//0t9gthJJVwK+FdxB7XyMF3DSW
         qdjLEyndY6NmEEDP9Mb1ABQyPXmT+4YTx7Ixl4gM7wEjGmI8OZeidmKoF+SCynXS05
         pHR5vIcvMy3vHysM7GKctr95nosL9Z4GRCersdVmyPuGSOsdMfJVTBY73EhPm0egtd
         tHc2p9Nnm7oqobpMJQPn6YSbJPrTZLOG6yFtszz5YrDGBCQm6sbN1xXpiDSfiDfUif
         bv1TKGpKoPkBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9153AF83ED3;
        Sat, 28 Jan 2023 08:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qrtr: free memory on error path in radix_tree_insert()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167489521759.20245.14249079137752848335.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 08:40:17 +0000
References: <20230125134831.8090-1-n.petrova@fintech.ru>
In-Reply-To: <20230125134831.8090-1-n.petrova@fintech.ru>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     mani@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 25 Jan 2023 16:48:31 +0300 you wrote:
> Function radix_tree_insert() returns errors if the node hasn't
> been initialized and added to the tree.
> 
> "kfree(node)" and return value "NULL" of node_get() help
> to avoid using unclear node in other calls.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - net: qrtr: free memory on error path in radix_tree_insert()
    https://git.kernel.org/netdev/net/c/29de68c2b32c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


