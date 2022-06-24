Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D030558F6A
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 06:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiFXEAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 00:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiFXEAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 00:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7AD54BDC;
        Thu, 23 Jun 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86438B82642;
        Fri, 24 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 315BBC341CA;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656043214;
        bh=VJiavjA8xOOFAc2iSowzYNKR16YNTTRpFvsaUgaWpzU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J2AgxfUHRPn5wGP6bgDbe9aWZxOnmBYN7cmWu71IUVXhrFNS5SaqyU1/SF+xq+znc
         /nSH2C/5eCl1dWJ46lPobLcIhRMTrjH8aXgJmqDeZrXYagsYBrIIWfO1VHYoIqrK4k
         TfRIPhK3h7pLkOXH67jrAXsd3xG2KOpOGWBxeeMS4J9rTQSH2XC+MvAheU28vMRMnu
         A6vxcxnccy4tLXnio1Yv0ABOZo75YcJ7MhP0HBehgHJQdMWBelzNMw6KvLX9y8dfbD
         9wKmRkp9AnjOjGGQgEqNHkiGDCfFY9j1ZXXrTEEVuyesztyIOE0/Dq3cDLVloiAGgW
         3CDhFJykX2pMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12C77E737F0;
        Fri, 24 Jun 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnxt: Fix typo in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165604321407.27108.15485461171113431977.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 04:00:14 +0000
References: <20220622144526.20659-1-jiangjian@cdjrlc.com>
In-Reply-To: <20220622144526.20659-1-jiangjian@cdjrlc.com>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, michael.chan@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Jun 2022 22:45:26 +0800 you wrote:
> Remove the repeated word 'and' from comments
> 
> Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bnxt: Fix typo in comments
    https://git.kernel.org/netdev/net-next/c/c909e7ca494f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


