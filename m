Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0AE598B1D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345528AbiHRSah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345491AbiHRSaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B64B6D2C
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E827B823D0
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 18:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E05C8C43147;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660847417;
        bh=QapOYGrx4cXnVIxVL7x0tU/so+JcvUK2N6RTRxIbv10=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gSzxhGajapKFMUOKH/ItKK73Ys+TPZpj5R2/KM/I/BKeieMNt9/y1XTUC3BcpKpS1
         +Cmx5xRwgBGC22ECTrOg1IZnfnEyuERyoM3rFFphJFkBgL+X9dogV/RqwUxXPZ5Qz6
         N79pe9yiACBUR4pAFjO12a9vhnNYgDeIpVWmdJE+ja9QwtpPvEJzZqRfLrkVrOu7Lk
         +7axYb92f5kUIDIDH0isfNUSZBYMV/yMxsYDeqspPOoukZ0kfXBjp8GsURMjWW5Nu5
         LF+Y1bcQ9O63czWoSv54f4x37GyF/G54dSmX6XitGuvkEJIfzDkfFHJ4A/QN06f5gn
         hAKsvdGV1kyow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF3FBE2A059;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igb: Add lock to avoid data race
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084741777.25395.12893313190054860159.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 18:30:17 +0000
References: <20220817184921.735244-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220817184921.735244-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, linma@zju.edu.cn, netdev@vger.kernel.org,
        alex.williamson@redhat.com, konrad0.jankowski@intel.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 17 Aug 2022 11:49:21 -0700 you wrote:
> From: Lin Ma <linma@zju.edu.cn>
> 
> The commit c23d92b80e0b ("igb: Teardown SR-IOV before
> unregister_netdev()") places the unregister_netdev() call after the
> igb_disable_sriov() call to avoid functionality issue.
> 
> However, it introduces several race conditions when detaching a device.
> For example, when .remove() is called, the below interleaving leads to
> use-after-free.
> 
> [...]

Here is the summary with links:
  - [net,1/1] igb: Add lock to avoid data race
    https://git.kernel.org/netdev/net/c/6faee3d4ee8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


