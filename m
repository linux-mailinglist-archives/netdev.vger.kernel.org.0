Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0972152CA12
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiESDKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbiESDKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2AB8DE312;
        Wed, 18 May 2022 20:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0681F61920;
        Thu, 19 May 2022 03:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60966C36AE3;
        Thu, 19 May 2022 03:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652929813;
        bh=LvuANKic4Swt7hf04ETk8GqSz0khQp/gzpNDBzz91YQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jIECwSeZDDaMQ2PZ2ktRdZxueTuPmmZWn5xkQrgkNSOELdxCQt3ghFyDcKD3vWWhk
         MAVxjx3EQwFq7ohm7nurzeLCFQ7MLIvJd3+IHAPvcl62hD/esEWII34vFx5/5idz3g
         4d8PbCoPWaomVed9cVI4wE3Lcrf30LoeVLYt5amXr8Ipg+6UHoJSK28CyLr5WWGvod
         kzD9amjGbx7xWLa5CibBKdAYr+nUBuaPfUQ4Hqjj46DT3wKD9LyEzWpH1DmK/pTtMV
         cN8RqCTAPa1RNxV0UfynAKcIxH1ECuhPzZ4ODmZD2E9mReAxB8NSCkpey2bDZ2uVyp
         XtT8Wo5OVNqhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 438F8F0392C;
        Thu, 19 May 2022 03:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] octeon_ep: Fix the error handling path of
 octep_request_irqs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165292981327.2906.8358628971940512633.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 03:10:13 +0000
References: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <cover.1652819974.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     vburru@marvell.com, aayarekar@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        sburla@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 17 May 2022 22:59:43 +0200 you wrote:
> I send a small serie to ease review and because I'm sighly less confident with
> the 2nd patch.
> 
> They are related to the same Fixes: tag, so they obviously could be merged if
> it is preferred.
> 
> Details on modification of this v2 are given in each patch.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] octeon_ep: Fix a memory leak in the error handling path of octep_request_irqs()
    https://git.kernel.org/netdev/net-next/c/4d3bf6fb5334
  - [v2,2/2] octeon_ep: Fix irq releasing in the error handling path of octep_request_irqs()
    https://git.kernel.org/netdev/net-next/c/3588c189e45a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


