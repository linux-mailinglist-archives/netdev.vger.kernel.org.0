Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC42C6EB723
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 05:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbjDVDka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 23:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjDVDkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 23:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F7C1BD4;
        Fri, 21 Apr 2023 20:40:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25DEE64430;
        Sat, 22 Apr 2023 03:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73A11C4339E;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682134820;
        bh=CKVGbNL1CDMqJ52adbSYFbDf9P+aKOtB/jBkwFDm8Pc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TzV1T8dhGyECXKUV6fTgARMAW64+Gd1f4YMhCLQFCJfvEgC+Uia/X31NkSnVUUm2V
         QSLouMi3ZCXW4dlfgbrmOAtYKDNC96via6r4kpSTNhGKcqgZSNSCnWtu5FmZ8U7Dbe
         QK+OyK3xenBs3FtEnHTXJeYbRtVB6eP5Bl8LkHt4hL41RF7JwBVYh+NhANAxxfiSQY
         z+jjRvwHzTwK0u+CASUnVfhxKUtizhOf8DxixsGy/rUrtJ6JijKvu9V11i4bnupfpP
         EZ2Jky2Ob5fSqIIj7Loo90f5nrbhlKApahHVsGaiD3O4Kl6tEpU+QLD+VRsWUNPvlL
         uaf42FtvzrNow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FC6DE4D000;
        Sat, 22 Apr 2023 03:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] nfp: fix incorrect pointer deference when offloading
 IPsec with bonding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168213482031.27640.14971982573981481441.git-patchwork-notify@kernel.org>
Date:   Sat, 22 Apr 2023 03:40:20 +0000
References: <20230420140125.38521-1-louis.peens@corigine.com>
In-Reply-To: <20230420140125.38521-1-louis.peens@corigine.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        leon@kernel.org, simon.horman@corigine.com, netdev@vger.kernel.org,
        stable@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 20 Apr 2023 16:01:25 +0200 you wrote:
> From: Huanhuan Wang <huanhuan.wang@corigine.com>
> 
> There are two pointers in struct xfrm_dev_offload, *dev, *real_dev.
> The *dev points whether bonding interface or real interface, if
> bonding IPsec offload is used, it points bonding interface; if not,
> it points real interface. And *real_dev always points real interface.
> So nfp should always use real_dev instead of dev.
> 
> [...]

Here is the summary with links:
  - [net] nfp: fix incorrect pointer deference when offloading IPsec with bonding
    https://git.kernel.org/netdev/net/c/63cfd210034c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


