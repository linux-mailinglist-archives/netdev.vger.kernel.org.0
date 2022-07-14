Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975D1574B56
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 13:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238197AbiGNLAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 07:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237669AbiGNLAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 07:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5CE4B4BA
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 04:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8D0260C23
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 11:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 488B8C341C6;
        Thu, 14 Jul 2022 11:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657796415;
        bh=+3Ct3voitB+vklcM1xTlH+eYIdHreTFqtTETdCS7S58=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SERjeJPGShOOuFg9XftFPXwRKbP6yk3YAFpjvdgeGtPKl/Tr32ZaXaq57WSe7k29U
         +X6oGPcpfTB+V4F2NiuPMtOXyooyY3hXllHA1pPRbklk8EDMC10vxFJQYO37HllnHG
         GXWsHbsf5toB3IofxCtMUdbQnR7WTOUYTEIeSgk/+22KiKA4jdpOg5qipcKkPGcYQf
         Ef0zb53KKuJXqPRhnjTHw+/0TBoSD0z+68JNUJ2Ek3UYbA4U6cffA3lChcgervCm00
         UxGETq1iNj+EQ8zHOLFxJtuD1s7p9BCr3RtOYq9GeYXddgskzJjOdFO8ONWSofGqi6
         Q3oiHoyggqH5A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25AD6E45224;
        Thu, 14 Jul 2022 11:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: fix kernel panic when creating VF
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165779641514.29408.13173310746486538195.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 11:00:15 +0000
References: <20220713092116.21238-1-ihuguet@redhat.com>
In-Reply-To: <20220713092116.21238-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        sshah@solarflare.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        yuma@redhat.com
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

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 13 Jul 2022 11:21:16 +0200 you wrote:
> When creating VFs a kernel panic can happen when calling to
> efx_ef10_try_update_nic_stats_vf.
> 
> When releasing a DMA coherent buffer, sometimes, I don't know in what
> specific circumstances, it has to unmap memory with vunmap. It is
> disallowed to do that in IRQ context or with BH disabled. Otherwise, we
> hit this line in vunmap, causing the crash:
>   BUG_ON(in_interrupt());
> 
> [...]

Here is the summary with links:
  - [net] sfc: fix kernel panic when creating VF
    https://git.kernel.org/netdev/net/c/ada74c5539eb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


