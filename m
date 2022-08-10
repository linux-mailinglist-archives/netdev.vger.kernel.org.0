Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C053558EC42
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 14:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiHJMuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 08:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232119AbiHJMuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 08:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E122D642D0;
        Wed, 10 Aug 2022 05:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7908961380;
        Wed, 10 Aug 2022 12:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 976DDC4314B;
        Wed, 10 Aug 2022 12:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660135815;
        bh=d9ItW5YEKhh32HxGw9G+EcZWqf0bptbe+f2x0eDlw3E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EeMbGNOp41C70lmMCCSpagzfQifhNMPeOZ1yDrUm7pEXrECyog1J/Ac9gxhA4w1kT
         xY8IqTrpnQ2QvS86qivH4//ARbMJjoMkefGVFX28OWSPLcJy9cRvp6pPLiYytrO0C3
         zON7pP7FfjJjT/PREzmLcp3nObYZcARYJFjFLK0pkbrPUGQJOr9RB0j86JoQEYcYtD
         dx5crLl311FNlL5XDgv2U1b7qfPA9gvy7NUftMtlS5OwfAxiP3o6XmnqQjq6UdPhR6
         yRbSuDSVUEGiUZMa3Qz9iDoxAAz1YQAc14q5NzZkwgOxcnT6J3PlYOkAYboZMb7lvJ
         kEmFBIx8/RZdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64E9FC43143;
        Wed, 10 Aug 2022 12:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net:bonding:support balance-alb interface with vlan to
 bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166013581540.3703.5149069391225440733.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 12:50:15 +0000
References: <20220809062103.31213-1-sunshouxin@chinatelecom.cn>
In-Reply-To: <20220809062103.31213-1-sunshouxin@chinatelecom.cn>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, razor@blackwall.org,
        huyd12@chinatelecom.cn
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  8 Aug 2022 23:21:03 -0700 you wrote:
> In my test, balance-alb bonding with two slaves eth0 and eth1,
> and then Bond0.150 is created with vlan id attached bond0.
> After adding bond0.150 into one linux bridge, I noted that Bond0,
> bond0.150 and  bridge were assigned to the same MAC as eth0.
> Once bond0.150 receives a packet whose dest IP is bridge's
> and dest MAC is eth1's, the linux bridge will not match
> eth1's MAC entry in FDB, and not handle it as expected.
> The patch fix the issue, and diagram as below:
> 
> [...]

Here is the summary with links:
  - [v2] net:bonding:support balance-alb interface with vlan to bridge
    https://git.kernel.org/netdev/net/c/d5410ac7b0ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


