Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64DA4B3254
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354509AbiBLBKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:10:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234870AbiBLBKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:10:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5081ED5C
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 17:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCEE661CA4
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 01:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43403C340EB;
        Sat, 12 Feb 2022 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644628209;
        bh=iELMVoE7nfw2DMQBBHYTWSJYma+z8rjHk/5gujNTbvk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VZAg8ftObr7OCVhk3s8ljtqzW9o6EUVSYlFgdQvLYOfkGaQRokFA2o95QrwxuB8l1
         P72j7fFYqzHFuVMtU9MrZS9G/HLlK9dS95wgrgIuCxfEXk9Ld7AXF30HP4D931hja5
         y53TftWcg6Xk6DLHk9i/S5wcqCOChdm1NWEBRk4MufsIcwMfYz7M/8tEZJOdDUoXKu
         lS3NEl2HA7RZ91AtdhIYD2rAkzntZFm8bvqhKgXnxBS94EXhs8GfVc29Twf8WmmFOy
         0vb+YJyt1k+TG4XAiBXX14sta0cU3zmU/dPdOhvLl3PNt68s7297S7Apyz4GcMZP2v
         se6MLKK11rpkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 275FFE5D09D;
        Sat, 12 Feb 2022 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: ethernet: cavium: use div64_u64()
 instead of do_div()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164462820915.17231.11686642681305819887.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Feb 2022 01:10:09 +0000
References: <20220211020544.3262694-1-kuba@kernel.org>
In-Reply-To: <20220211020544.3262694-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dchickles@marvell.com,
        fmanlunas@marvell.com, sburla@marvell.com, wangqing@vivo.com,
        christophe.jaillet@wanadoo.fr
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

On Thu, 10 Feb 2022 18:05:44 -0800 you wrote:
> This reverts commit 038fcdaf0470de89619bc4cc199e329391e6566c.
> 
> Christophe points out div64_u64() and do_div() have different
> calling conventions. One updates the param, the other returns
> the result.
> 
> Reported-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Link: https://lore.kernel.org/all/056a7276-c6f0-cd7e-9e46-1d8507a0b6b1@wanadoo.fr/
> Fixes: 038fcdaf0470 ("net: ethernet: cavium: use div64_u64() instead of do_div()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: ethernet: cavium: use div64_u64() instead of do_div()"
    https://git.kernel.org/netdev/net-next/c/f126ec9d6e57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


