Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065B95BFD6D
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiIUMAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiIUMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438937695B;
        Wed, 21 Sep 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D749962A84;
        Wed, 21 Sep 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 315C8C433D7;
        Wed, 21 Sep 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663761616;
        bh=i69ZmGdHu5PUuqWlHjhxOd/tkF7768DYdJ7U9BGdZ1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KRoOTgRvcOEg+fOnKAUOqSo0ExLK+AQvs96L604Lz5Zn0GOHVyUOhryZRWPND04lI
         0UB0y36PImI4qbh9w3YbPmhfvVUUadHTifhEnkBI4CZrt2xzTND/nTHV6nu4iF4fcg
         BxD6oL5MXaDS9cY/5xri2v/I8L/At+E/2plSLwi1nQg5bUQTDMf7uBPO+JO+3wHJwI
         bwIxOm+o6APz92dbmj1vio9YMlhsZbMongQf/YYaA9PossYnjfjpg/4A9wBMnrbNVT
         Zua7wZ7Kjsg9F2MwY+rkdUrJS+CSsDRyHjQDp6fpOy+8jCOh7umnjx3a50wrBBCj2V
         VpCQMwYToaTIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FADEE4D03C;
        Wed, 21 Sep 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: atlantic: fix potential memory leak in aq_ndev_close()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166376161606.20264.11965749848090373345.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 12:00:16 +0000
References: <20220914014238.7064-1-niejianglei2021@163.com>
In-Reply-To: <20220914014238.7064-1-niejianglei2021@163.com>
To:     Jianglei Nie <niejianglei2021@163.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed, 14 Sep 2022 09:42:38 +0800 you wrote:
> If aq_nic_stop() fails, aq_ndev_close() returns err without calling
> aq_nic_deinit() to release the relevant memory and resource, which
> will lead to a memory leak.
> 
> We can fix it by deleting the if condition judgment and goto statement to
> call aq_nic_deinit() directly after aq_nic_stop() to fix the memory leak.
> 
> [...]

Here is the summary with links:
  - net: atlantic: fix potential memory leak in aq_ndev_close()
    https://git.kernel.org/netdev/net/c/65e5d27df612

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


