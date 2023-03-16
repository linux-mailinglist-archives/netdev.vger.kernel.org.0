Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D205B6BD749
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjCPRlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjCPRlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:41:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B696FC6419;
        Thu, 16 Mar 2023 10:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78081620CE;
        Thu, 16 Mar 2023 17:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C737DC4339B;
        Thu, 16 Mar 2023 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678988417;
        bh=WbWJzWWmjrBLQSbLSwG+zCFQ5vbzSmmf/MuGY6JVjaY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WD1A5EIfxaW2EwkTzUE5gI/bgoh/KAjABQsV9JRwFXqaqJ7pddtA+ok+dGrw1rQEW
         hL3/foiYYLyVIHhk95u4pkW1c9bKBYfVGe3t0LgWDU3zDf2YsCEsqeH3V03/0j1CW1
         DhG5VTLVG7PPtFOdUHtcn6EsNPKuu5ZIwW11sxdIwqu9W0vvApWy4qIr/RoJNyo4FI
         FYAN3JWutoLGSyMhjZ/vD82GqO+d84z0P18Kdme+ngxt6ZMYxQKJqT7QofvmfKZwlf
         xu4GEIcfnKUor0HHse9Zu5kh7dkEgKOhC0c1g3LBv7Sbi+Q9ABheC90nApCAQ0IMIn
         HJgXpfSDHRnhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2DA8E66CBB;
        Thu, 16 Mar 2023 17:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ice: xsk: disable txq irq before flushing hw
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167898841766.29063.15581899056946442159.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:40:17 +0000
References: <20230314174543.1048607-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230314174543.1048607-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        larysa.zaremba@intel.com, chandanx.rout@intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Mar 2023 10:45:43 -0700 you wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> ice_qp_dis() intends to stop a given queue pair that is a target of xsk
> pool attach/detach. One of the steps is to disable interrupts on these
> queues. It currently is broken in a way that txq irq is turned off
> *after* HW flush which in turn takes no effect.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ice: xsk: disable txq irq before flushing hw
    https://git.kernel.org/netdev/net/c/b830c9642386

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


