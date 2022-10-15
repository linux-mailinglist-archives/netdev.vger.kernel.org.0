Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087185FF998
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 12:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiJOKKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 06:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJOKKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 06:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE77B2F02D
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 03:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 42F0660C07
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 10:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9ACD0C433C1;
        Sat, 15 Oct 2022 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665828614;
        bh=STt3HpLBf5ey1+HU5tJuSyXqBdwa/ZwL/PqagH1yKNM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PPMEkR5Yho1suzA4+jspzL5+PC2ZgCvzjH4VpFjjViQj7yaqKSDJ/sMZMC/4/vUgK
         T4fjpeus0o6D34JVfRYKWocO4TH5KsCBefYXpyw1uAmrndUgCLYgSSKWoJRwyO4yCN
         uVEYcO4nIVpm5ugxemQTZOG7LAJw0emsTrQcknyb/g+egNIfmqpD7TDxqJH8qfQjr/
         pGXG3jGFxvKKdCluKFEt7UifCGZMGRmVOb9APmDj8qwuR1ww902/3ezE6BgLQfbH39
         +5Lkn0tVGVrjk2/9QCcDhNkMJqDlZIHr3Zqgkosn2we1FKWEXSteNYLsgwl1/ofb+s
         xvcyo5exl51kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7C608E29F31;
        Sat, 15 Oct 2022 10:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: Change VF mac via PF as first preference if
 available.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166582861450.27777.17279814720565554448.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 10:10:14 +0000
References: <20221013095553.52957-1-jonathan.s.cooper@amd.com>
In-Reply-To: <20221013095553.52957-1-jonathan.s.cooper@amd.com>
To:     Jonathan Cooper <jonathan.s.cooper@amd.com>
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        ihuguet@redhat.com, davem@davemloft.net
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

On Thu, 13 Oct 2022 10:55:53 +0100 you wrote:
> Changing a VF's mac address through the VF (rather than via the PF)
> fails with EPERM because the latter part of efx_ef10_set_mac_address
> attempts to change the vport mac address list as the VF.
> Even with this fixed it still fails with EBUSY because the vadaptor
> is still assigned on the VF - the vadaptor reassignment must be within
> a section where the VF has torn down its state.
> 
> [...]

Here is the summary with links:
  - [net] sfc: Change VF mac via PF as first preference if available.
    https://git.kernel.org/netdev/net/c/a8aed7b35bec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


