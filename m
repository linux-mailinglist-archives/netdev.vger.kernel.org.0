Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CCD5E64F7
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiIVOUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiIVOUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:20:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34AF83051;
        Thu, 22 Sep 2022 07:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E066B8378E;
        Thu, 22 Sep 2022 14:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B593C433D6;
        Thu, 22 Sep 2022 14:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663856415;
        bh=Z5KklAxJJjnZ2bt/Zb2GDJC3FTImU2unFl2S6/hePIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lq12is0of7Ve3Jk4KC1OuR0ZShoYkMbjNoZOpGQU3IXo6IQaPDmwKY/sqIH6jLvlt
         kySQn3mU3Pu0OWqKHBIDisbIN7Zbz/bQFI8+pL2dsv0bqOT4gDV7Qo8XgoaZfbsiZL
         /SDNUZJBRKb/vDLcl8lyXoYeCLzuidrBm4SqX1Nmp2tXZABPPFMjljvyOxm/DWMRmc
         5/VlNPVaaEzTJUg1pPRflj35WrEOsXJCiubhXW5K7enP7vrK1vdQUiZNklFYZNboN0
         cKZokey6aMXyBcXHAg9F5rHooBWdHni+Lzr11A5fAXjBBKbBWbVYErWZJVJFqLJowf
         pFUt0rP0e0+Vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1ADB6E4D03D;
        Thu, 22 Sep 2022 14:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: sched: fix possible refcount leak in tc_new_tfilter()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166385641510.9882.16423342832094915476.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 14:20:15 +0000
References: <20220921092734.31700-1-hbh25y@gmail.com>
In-Reply-To: <20220921092734.31700-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, vladbu@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vladbu@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 17:27:34 +0800 you wrote:
> tfilter_put need to be called to put the refount got by tp->ops->get to
> avoid possible refcount leak when chain->tmplt_ops != NULL and
> chain->tmplt_ops != tp->ops.
> 
> Fixes: 7d5509fa0d3d ("net: sched: extend proto ops with 'put' callback")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: sched: fix possible refcount leak in tc_new_tfilter()
    https://git.kernel.org/netdev/net/c/c2e1cfefcac3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


