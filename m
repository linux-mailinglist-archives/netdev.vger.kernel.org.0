Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A31502832
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 12:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352225AbiDOKW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 06:22:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352284AbiDOKWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 06:22:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5891B8980;
        Fri, 15 Apr 2022 03:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94902B82DEF;
        Fri, 15 Apr 2022 10:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 511E6C385A8;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650018014;
        bh=dWiZ6Nex83uUYtY7bm/jpBV/+lybuaL7Uo7GprLVjlc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hVLMeNdzGLdJ2AR8Zb6T4HRs5Fssw8pw7WnozHa2u0pTrBct8hwTZ4HAN+3UIzxiF
         kqJPaMmlTqOBev01Q3NQ+z/vjT9WxKcYvYCxN5pVQ4NABnDsiGqXZPSxQ9FTe0GRMK
         PlivtVADa+AVPfuHaRQ+fsLSwkkmBn/JDQjQYaO8FIzM66aCiL35n6H6Ziwh32oAbE
         fs3LJrPP/WHtKH/qfRScRH/WhjFkyF8orwlKthvtZczED8wWUhMfvlJP7KcCEklD5q
         b5O2r54ZuhkYFThDAyFEibJOw0aeWNRdR1kFRpxKwU2jJ2sN6Tt7sA30dB3NZAKlI8
         jqY7OlhOyMZgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39C29EAC096;
        Fri, 15 Apr 2022 10:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: stmmac_main: using pm_runtime_resume_and_get
 instead of pm_runtime_get_sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165001801423.12692.14282066023712960077.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 10:20:14 +0000
References: <20220413093801.2538628-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220413093801.2538628-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        chi.minghao@zte.com.cn, zealci@zte.com.cn
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
by David S. Miller <davem@davemloft.net>:

On Wed, 13 Apr 2022 09:38:01 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: stmmac: stmmac_main: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
    https://git.kernel.org/netdev/net-next/c/85648865bb95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


