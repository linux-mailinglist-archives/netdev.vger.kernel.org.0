Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D64662B688
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 10:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiKPJaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 04:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbiKPJaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 04:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1070314006
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 01:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD1F4B81C6A
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68848C433C1;
        Wed, 16 Nov 2022 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668591017;
        bh=8TurB/EPIOUoeilnHBCBK+S24plUh1ixhMcqKXpZrok=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D6+5KG66kX9WwoQAYfmowWADKVc/jrjvZhRACP4FZYUtGWZKZFOypOLoKJ3xcWGJi
         IHx37UH4yuRDAdUUaIy243irsdihcfRgsOD5qSktPf+oL5mCqA9Io/vAeilumWswxQ
         0kT5JeIeixd6MgX0czLOC2RUqxRiJkahl9hBGewch2f6ltiQVeHI+dTzOPprwB90fu
         O8omR8bTtQGFb/pYTn1ZZGX7btzqoCW16bNL/X1YYsJwFJLMxmO9XA/jrIXAQueOw+
         lbos9Nd4CtsisbfE95qIg4iC2PJlaCY14t+uNq1FzAZVs6VeJ7u1XXatEdoXrJb6H9
         PqpWNi1vsT0HA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 459E0C395F6;
        Wed, 16 Nov 2022 09:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: thunderbolt: Fix error handling in tbnet_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166859101727.10536.9382451307302337804.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 09:30:17 +0000
References: <20221114142225.74124-1-yuancan@huawei.com>
In-Reply-To: <20221114142225.74124-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     michael.jamet@intel.com, mika.westerberg@linux.intel.com,
        YehezkelShB@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        andriy.shevchenko@linux.intel.com, amir.jer.levy@intel.com,
        netdev@vger.kernel.org
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

On Mon, 14 Nov 2022 14:22:25 +0000 you wrote:
> A problem about insmod thunderbolt-net failed is triggered with following
> log given while lsmod does not show thunderbolt_net:
> 
>  insmod: ERROR: could not insert module thunderbolt-net.ko: File exists
> 
> The reason is that tbnet_init() returns tb_register_service_driver()
> directly without checking its return value, if tb_register_service_driver()
> failed, it returns without removing property directory, resulting the
> property directory can never be created later.
> 
> [...]

Here is the summary with links:
  - [v2] net: thunderbolt: Fix error handling in tbnet_init()
    https://git.kernel.org/netdev/net/c/f524b7289bbb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


