Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68EE8562967
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 05:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiGADKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 23:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiGADKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 23:10:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CBF248CC;
        Thu, 30 Jun 2022 20:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 313DF62258;
        Fri,  1 Jul 2022 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87430C341CF;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656645016;
        bh=8HEFfIhVligP5JQR/yO4wnOtAh+8LUCK5IsLvdGG7X0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SV6DVu9XwkmnfNZpPePDddMcx7slU3UfnUkL5xHXiQS2X5QgnROGHIdony69yHAvE
         2w0ZNc0gAEHvy+sB1q2D3VA6amG+t9JH+/sPQAGsHAhd1XnkfFsQFmkpKHeQSEUisQ
         t+4niLH/zr7mVjnS1iyXxE1gIbeLp+ZJhikr5mcCTOsf3SoMFG0+XrR8yDD03s2/CM
         6kB9VKxJpR0IxBX9jSqVZtnfO50ltCEiekcoPtHQi/8ZzrIFIOv3h5nCvoZbkIKnai
         d8i+bBPcO/ogOYIBjVJBJNAVM0XDrzMHIEcQGbYfw4ns3sIibpYZAKm1bRaJrvH177
         4gWt6mQ/3DoWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60507E49FA0;
        Fri,  1 Jul 2022 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet/emulex:fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165664501639.21670.3293352938618990469.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 03:10:16 +0000
References: <20220629123756.48860-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220629123756.48860-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 29 Jun 2022 20:37:56 +0800 you wrote:
> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/ethernet/emulex/benet/be_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - ethernet/emulex:fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/4c2d6acd765f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


