Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B6D58269E
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 14:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbiG0Ma6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 08:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233051AbiG0Mav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 08:30:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72895DF84;
        Wed, 27 Jul 2022 05:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C94160FDD;
        Wed, 27 Jul 2022 12:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E186EC43142;
        Wed, 27 Jul 2022 12:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658925014;
        bh=z4+X3/lE4RQYWxQzTpVOq75PHGIQ/VULfH5YuSo1yb8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QjKg2SrSKsl3acZmURejReBkmneEup1gxkCb+S5jMLw1+zNcfHtUcRL7cF+Ae9Zif
         gYq8/xtkon5sqfZX1n/C2/OyNCqiV04sqWUdq25I5BOdaFPsRL3VMUbFdvVByj4wUX
         R6BYwPSP5t8v1zn2mteC/cH+HsmQ/dvlnzl8TBdpBryHAGKRPjFyy8c0AiDbD3fUcW
         49+W5RHB7DD/TFnUVR4rcfcahv0nN7N1ZnM9D89+MUuEQIfxjlKrUCWxKdtb7nszOI
         h+DZzlIZgQdXauHgBmbiP7XyD+2PHNLYz1jMLw6ZwR7uj3eVOIFhcKctBS+4EUbWu6
         yPvdWJ8XTD2pA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB9F7C43144;
        Wed, 27 Jul 2022 12:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net/smc: updates 2022-07-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165892501483.3549.12934641923205057607.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jul 2022 12:30:14 +0000
References: <20220726100330.75191-1-wenjia@linux.ibm.com>
In-Reply-To: <20220726100330.75191-1-wenjia@linux.ibm.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        kgraul@linux.ibm.com, raspl@linux.ibm.com, wintera@linux.ibm.com,
        tonylu@linux.alibaba.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 26 Jul 2022 12:03:26 +0200 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patches to netdev's net-next tree.
> 
> These patches do some preparation to make ISM available for uses beyond
> SMC-D, and a bunch of cleanups.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net/smc: Eliminate struct smc_ism_position
    https://git.kernel.org/netdev/net-next/c/eb481b02bd18
  - [net-next,v2,2/4] s390/ism: Cleanups
    https://git.kernel.org/netdev/net-next/c/0a2f4f9893c8
  - [net-next,v2,3/4] net/smc: Pass on DMBE bit mask in IRQ handler
    https://git.kernel.org/netdev/net-next/c/8b2fed8e2712
  - [net-next,v2,4/4] net/smc: Enable module load on netlink usage
    https://git.kernel.org/netdev/net-next/c/28ec53f3a830

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


