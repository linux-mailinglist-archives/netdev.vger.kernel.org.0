Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90313627C5A
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236498AbiKNLaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbiKNLaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:30:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7501B1ED
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 03:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08E9BCE0F60
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 11:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24671C43470;
        Mon, 14 Nov 2022 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668425416;
        bh=t+MRNEvCQpGXFw4iq6x1HSJDs4BGZ/qw71rEz1m5LgE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qy6A63wIAL0rYGTIy3EsuKSvAyl+LdGjGE75WxgSweka6toIHB1ZUafz9ylK/pcm8
         jyWGAKGGu/oVmwnXAPsGPuzvVX2lGYUX594HsCe0tFczSSAm6nmsJgMB1GZzTNMBW9
         PRlmomv3vVmVBmV5dIEcAtySm9gIEeAKfZMZpladG242KsEaoxBEGNnA1nElu8MpKl
         Byx9eAu36/b0bS/fyMJvo3r0Zo3l6dRO9sniH4Td1gHPMH6Ikw2VGcW4XwgNOWoao7
         WGOaB1nx9tLRJdcMiP2dNqiWoUL0MlEuC3xWoXZmgZHv+sLDJw88Sv6s1YBsyqM1OT
         o4m4bWWs/ePeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E429E4D021;
        Mon, 14 Nov 2022 11:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] ibmvnic: Introduce affinity hint support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842541605.32199.18080021186022555156.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 11:30:16 +0000
References: <20221110213218.28662-1-nnac123@linux.ibm.com>
In-Reply-To: <20221110213218.28662-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, bjking1@linux.ibm.com, haren@linux.ibm.com,
        ricklind@us.ibm.com, mmc@linux.ibm.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Nov 2022 15:32:15 -0600 you wrote:
> Hello,
> 
> This is a patchset to do 3 things to improve ibmvnic performance:
>     1. Assign affinity hints to ibmvnic queue irq's
>     2. Update affinity hints on cpu hotplug events
>     3. Introduce transmit packet steering (XPS)
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ibmvnic: Assign IRQ affinity hints to device queues
    https://git.kernel.org/netdev/net-next/c/44fbc1b6e0e2
  - [net-next,2/3] ibmvnic: Add hotpluggable CPU callbacks to reassign affinity hints
    https://git.kernel.org/netdev/net-next/c/92125c3a6024
  - [net-next,3/3] ibmvnic: Update XPS assignments during affinity binding
    https://git.kernel.org/netdev/net-next/c/df8f66d02df7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


