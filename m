Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5D63597DE6
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243152AbiHRFKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243275AbiHRFKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:10:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BABAA4F8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DFD4B82069
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2BBFC43470;
        Thu, 18 Aug 2022 05:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660799420;
        bh=11zX6vF+Xhwyj3bw3smHsrqTuBdtxH0Qf0wfKSmzhcA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NVs4RE0D/dKYILmBv7bJiqO5X2xXxz5j60hFei/kUeqhwRbCekjKGj7jUs9XoD+Wq
         muBTgXxSu8ZykpgAKZkupLemZiEOKHtfgCAsAMsFIHUKaBOCa9Z2XSGSnJA09tDetS
         4MS0KMxvKVk3hFmiNlrZ664x38qmNtZFP16MHRTDICCBoxWvcq3QIQ/dIlaoqys1IM
         JnM9H0XWjC17pG6HdjyPJupRUMz1QzlaHZG7PMKXpmV2VcIKXdnJi/Orm+xStCLPTn
         ut+k27DvGBHqvI3fm/oD9zXdsyt5F+X/EPpdl6ty5r8P80uCI3n1JyIQdzbzWXuDNS
         3U7Lz7tXoHcgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A08FFC4166F;
        Thu, 18 Aug 2022 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 1/1] stmmac: intel: remove unused 'has_crossts' flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166079942065.2023.3273607111868789477.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:10:20 +0000
References: <20220817064324.10025-1-veekhee@gmail.com>
In-Reply-To: <20220817064324.10025-1-veekhee@gmail.com>
To:     Wong Vee Khee <veekhee@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        veekhee@apple.com, kurt@linutronix.de, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 17 Aug 2022 14:43:24 +0800 you wrote:
> From: Wong Vee Khee <veekhee@apple.com>
> 
> The 'has_crossts' flag was not used anywhere in the stmmac driver,
> removing it from both header file and dwmac-intel driver.
> 
> Signed-off-by: Wong Vee Khee <veekhee@apple.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/1] stmmac: intel: remove unused 'has_crossts' flag
    https://git.kernel.org/netdev/net-next/c/e34cfee65ec8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


