Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2388D4F53B6
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443216AbiDFEWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356749AbiDEUXn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 16:23:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D014EEDF1F;
        Tue,  5 Apr 2022 13:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87680B81FCC;
        Tue,  5 Apr 2022 20:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38856C385A5;
        Tue,  5 Apr 2022 20:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649189412;
        bh=fN+tF5XtErveJG8cBvd3ijJXtwZIIyWQAU/05y/BfnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sjlRAsmEt18Mkb/47At1qXQhpPmJnh6sDtOq76R7gZsf6pXZPLSMtBcL7p3ZRb7Ug
         Z3+tHZsRt7wCc1wsdTPFuGfJ+7ZInSaTiG4xj+vyhaiAQ30BqrIEpbACdhpHGdmlAo
         FDip7giRtclSkH274A+YiJEoXVYMPqWEQ7gueT37o4D8f0wkd+6CtohXopf/TzsA4p
         LoadczN/YpIso9J+eKtIw7iDXVYV8XcMT1LUI1DYr9YLm5onWgqm3xarUFgYsr2DpB
         EcZPMDnq7tBIt7HhPIJIHvJaDwBzW5A34CIWv6aI+aUXk3dSWtvRTShksJ6Y1gD9Yt
         KbpFMiEg1rQ+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1B7FEE6D402;
        Tue,  5 Apr 2022 20:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: bitwise: fix reduce comparisons
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164918941210.23958.7861571827921966644.git-patchwork-notify@kernel.org>
Date:   Tue, 05 Apr 2022 20:10:12 +0000
References: <20220405100923.7231-2-pablo@netfilter.org>
In-Reply-To: <20220405100923.7231-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
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

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue,  5 Apr 2022 12:09:22 +0200 you wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
> 
> The `nft_bitwise_reduce` and `nft_bitwise_fast_reduce` functions should
> compare the bitwise operation in `expr` with the tracked operation
> associated with the destination register of `expr`.  However, instead of
> being called on `expr` and `track->regs[priv->dreg].selector`,
> `nft_expr_priv` is called on `expr` twice, so both reduce functions
> return true even when the operations differ.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: bitwise: fix reduce comparisons
    https://git.kernel.org/netdev/net/c/31818213170c
  - [net,2/2] netfilter: nf_tables: memcg accounting for dynamically allocated objects
    https://git.kernel.org/netdev/net/c/42193ffd79bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


