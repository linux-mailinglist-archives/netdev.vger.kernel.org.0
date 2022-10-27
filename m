Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C0F60F4C7
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 12:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235440AbiJ0KUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 06:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbiJ0KU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 06:20:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 956DB2A959;
        Thu, 27 Oct 2022 03:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4ED5FB8254E;
        Thu, 27 Oct 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE421C433B5;
        Thu, 27 Oct 2022 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666866016;
        bh=/i906t4LlgLzrU1t6JV+mYaTQDQSgmlrOwu7+7bznmc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yvc1/MjS6fUCueEKtcsxRHDuZnNaajAt+9xfNbZVH/iMbYI+LRaP0WhqkALoKApO/
         fxa7yYTNDIwOXcjif0MvKvDg86CRx3gJOj1V4s0yibndVPxn1A9o8qYF5OGSdl+eEQ
         eD6t6trRyKymdju1E0MaiM+3d9Jum/p7bXJg0R9XsAMxvM/Cu2k2kflsQYwDt+GmRo
         vAxg6yPHUoL8rjjowiGxsSufQ3r6Mq+PscXFYAfwY4FAG+Fjqu5xjUILvwYOIHcL+H
         Tv4nJC0awkad55ekWWFPhM0iS9dZTEQoewhCyCjlgJ47vuUd9BC8Oazf3am7KjtXYt
         AghIdM7ps92Gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D0DF6E270D8;
        Thu, 27 Oct 2022 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] net: stmmac: remove duplicate dma queue channel
 macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166686601585.8143.16275733107810431975.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 10:20:15 +0000
References: <20221025081747.1884926-1-junxiao.chang@intel.com>
In-Reply-To: <20221025081747.1884926-1-junxiao.chang@intel.com>
To:     Junxiao Chang <junxiao.chang@intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        Joao.Pinto@synopsys.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        veekhee@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 16:17:47 +0800 you wrote:
> It doesn't need extra macros for queue 0 & 4. Same macro could
> be used for all 8 queues. Related queue/channel functions could
> be combined together.
> 
> Original macro which has two same parameters is unsafe macro and
> might have potential side effects. Each MTL RxQ DMA channel mask
> is 4 bits, so using (0xf << chan) instead of GENMASK(x + 3, x) to
> avoid unsafe macro.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: stmmac: remove duplicate dma queue channel macros
    https://git.kernel.org/netdev/net-next/c/330543d04f2c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


