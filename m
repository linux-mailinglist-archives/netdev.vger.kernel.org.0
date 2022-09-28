Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D535ED83A
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 10:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbiI1Iuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 04:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiI1IuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 04:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5248287FAC
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 01:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 096EA61DAA
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 08:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D660C433C1;
        Wed, 28 Sep 2022 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664355017;
        bh=qJPLky4KLV5tymJfcZRJKUEFvItxar8FXT+8ZHUbGQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KnKZuO3tkbiFIHyDBkze3t/4lSAVpMla7lbc0QfD+kpM5Q/Qb8ePgfOhZlBMNu5Ea
         rzP4eHfnR0Hc5zk9egny8EK9PAWbOqXhrZx7tW37qRBbuZF+6pQPvrENOFzJIoy91z
         uIHAg5QHKs0YYnJRi/oklNgMF/sDvu0mC8EBkk6eYOHD0gQ9NFLapNjQYhCHcmVeuO
         ufCHQyTfD/8Cp+YM/WLSKWGMdbQScVAXhMH8AcFF2bJQ3VKK+aremvTYTyx9OKjDfu
         6SUyoQHyPnuhd4tqJufizXYcEeE+atelr2z0GuqnvW1S2eb3oQIthNY3Lmkie0gzza
         C8t3luExhcCaw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E1F2E4D035;
        Wed, 28 Sep 2022 08:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/6] sfc: bare bones TC offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166435501724.19549.11910754562202475038.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 08:50:17 +0000
References: <cover.1664218348.git.ecree.xilinx@gmail.com>
In-Reply-To: <cover.1664218348.git.ecree.xilinx@gmail.com>
To:     <ecree@xilinx.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 26 Sep 2022 19:57:30 +0100 you wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> This series begins the work of supporting TC flower offload on EF100 NICs.
> This is the absolute minimum viable TC implementation to get traffic to
>  VFs and allow them to be tested; it supports no match fields besides
>  ingress port, no actions besides mirred and drop, and no stats.
> More matches, actions, and counters will be added in subsequent patches.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/6] sfc: bind blocks for TC offload on EF100
    https://git.kernel.org/netdev/net-next/c/9dc0cad203ab
  - [v2,net-next,2/6] sfc: bind indirect blocks for TC offload on EF100
    https://git.kernel.org/netdev/net-next/c/5b2e12d51bd8
  - [v2,net-next,3/6] sfc: optional logging of TC offload errors
    https://git.kernel.org/netdev/net-next/c/7c9d266d8faf
  - [v2,net-next,4/6] sfc: add a hashtable for offloaded TC rules
    https://git.kernel.org/netdev/net-next/c/f54a28a21166
  - [v2,net-next,5/6] sfc: interrogate MAE capabilities at probe time
    https://git.kernel.org/netdev/net-next/c/7ce3e235f212
  - [v2,net-next,6/6] sfc: bare bones TC offload on EF100
    https://git.kernel.org/netdev/net-next/c/d902e1a737d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


