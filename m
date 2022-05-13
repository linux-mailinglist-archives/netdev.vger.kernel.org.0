Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 600025258E2
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 02:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358361AbiEMAKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 20:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiEMAKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 20:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA92285AC3
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 17:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2027B82BD2
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 00:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 537CDC34113;
        Fri, 13 May 2022 00:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652400616;
        bh=DSmGvMxjU6UtmgXy5svNgdl4EIsGrpIgVbHAE19kEQs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=adcNvjR0vM6lC064mGh1KouskQ0pPvpq9NCGnBVqOAJ8QKnb9t6FlNhxIlUxSut0S
         X/Rxjv4L+BUoMFWCN3oF43UBVZCUsB3OOrOp4b+G2g6WKsE4LOhOjjDnsN0pXgpV97
         y0lRtvpMqEqbtsPp9u50axEP7lll/SsboFHvwzyGmf4j5CWW8a0tw7gg2lUZZn7Gyt
         i1IrE46e+urkSk04Huji9TBeWsd4pWPyZKStn9twJN7GJcZqSjZ/fnAJekv+yQZ2Q2
         y+FETQ5L7P0tF9mJ6y30oJhCDqhq/mafq/pas92cVnyEOi+eRQ3o0IzsdIEcfWRee6
         a+aHB2jLEF7dw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 378D3F03934;
        Fri, 13 May 2022 00:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6]: Make sfc-siena.ko specific to Siena
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165240061621.28704.7056528047240101241.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 00:10:16 +0000
References: <165228589518.696.7119477411428288875.stgit@palantir17.mph.net>
In-Reply-To: <165228589518.696.7119477411428288875.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org, ecree.xilinx@gmail.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 17:19:12 +0100 you wrote:
> This series is a follow-up to the one titled "Move Siena into
> a separate subdirectory".
> It enhances the new sfc-siena.ko module to differentiate it from sfc.ko.
> 
> 	Patches
> 
> Patches 1-5 create separate Kconfig options for Siena, and adjusts the
> various names used for work items and directories.
> Patch 6 reinstates SRIOV functionality in sfc-siena.ko.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] siena: Make MTD support specific for Siena
    https://git.kernel.org/netdev/net-next/c/65d4b471b3cf
  - [net-next,2/6] siena: Make SRIOV support specific for Siena
    https://git.kernel.org/netdev/net-next/c/dfb1cfbd497e
  - [net-next,3/6] siena: Make HWMON support specific for Siena
    https://git.kernel.org/netdev/net-next/c/f62a074525de
  - [net-next,4/6] sfc/siena: Make MCDI logging support specific for Siena
    https://git.kernel.org/netdev/net-next/c/58b6b3d5379d
  - [net-next,5/6] sfc/siena: Make PTP and reset support specific for Siena
    https://git.kernel.org/netdev/net-next/c/ef9b5770945d
  - [net-next,6/6] sfc/siena: Reinstate SRIOV init/fini function calls
    https://git.kernel.org/netdev/net-next/c/c374303969ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


