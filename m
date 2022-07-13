Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59DC8573699
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbiGMMuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234462AbiGMMuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FEB32EF5;
        Wed, 13 Jul 2022 05:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 666BC61BA0;
        Wed, 13 Jul 2022 12:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6FE9C34114;
        Wed, 13 Jul 2022 12:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657716613;
        bh=UAZQ3e11PSqREtLGLj03rvjjOONs6n0YC5OE9U7jODA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ho2K6e9pGVhRcfOJasRfj3M6CKTbxH2C5X6FxlUsIevHT1mrNUhfaHY4w7XI/vFsZ
         IOLRI46YzYhQpZLzuue0yFdujqk2hW5N2tjKXYG+AU5X/FdXfJm9wnzj+SJmfxwUHf
         Of+i5ATKzohiVEFgqzTHHQJgrLsckKuCR9ro77ndksM1MLtLBTCqmuNY3jm8E4IRUX
         iBXkX+9Y22I1n7LB3e9X4u3Ngo5YAbzuT+jFOu2ybH3j2NGWCGXcZIv8z/0eiG+7a8
         s/trbq9GOkvkOxdk6IykwUxYVWnlO6h3tQIxIX5ASty/44CXKsfoKbqaMxG/9BpRfN
         VTgd/6ghaqjkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8886E45223;
        Wed, 13 Jul 2022 12:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] octeontx2-af: Skip CGX/RPM probe incase of zero
 lmac count
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165771661368.8674.11632704817904156772.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 12:50:13 +0000
References: <20220712064250.29903-1-gakula@marvell.com>
In-Reply-To: <20220712064250.29903-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, sgoutham@marvell.com, hkelam@marvell.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Jul 2022 12:12:50 +0530 you wrote:
> From: Hariprasad Kelam <hkelam@marvell.com>
> 
> In few error cases MAC(CGX/RPM) block is having 0 lmacs.
> AF driver uses MAC block with lmac pair to get firmware
> data etc. These commands will fail as there is no LMAC
> associated with MAC block.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-af: Skip CGX/RPM probe incase of zero lmac count
    https://git.kernel.org/netdev/net-next/c/3e35d198cee6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


