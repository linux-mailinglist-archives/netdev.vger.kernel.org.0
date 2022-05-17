Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473C1529DD4
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244668AbiEQJUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243281AbiEQJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A73229807
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 02:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04A6FB817E0
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 09:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4BB9C34118;
        Tue, 17 May 2022 09:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652779211;
        bh=76ZbgacrUQTGkAc0zA8UBrk+bcvXGgSU5nmTUAXtSus=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ms+XEs0fT/KhzhCeXlgGWlggBtEuXDKn39TRW7yQ3kqpXM+XmJvKSeIme3Yv5uR3y
         yYmaYSsJz3GcVvwN+mnJhKv98uKXJDFxLHbwJr/oPIIVluyceXBM0wFntVfBsSeBo+
         mFLuzRkByMek3nlWalspsFggfljHIQBSRd2JSd0aNmUXjyv6BIOCuSB62IDzIexM97
         cApRpu5h6q44WTnvtEolURJgBEozU7nUp34Rk0iu2O7a4YPP2D0hRJnjAaMMRoQWZz
         6ZQdccDOu3zDBeG0oH8ju+F48vBi/JlVShbk+uWVbkl+S9yvFq/EX9JbCERuZL2mAV
         9tdK4dFoFuW+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 891C6F0383D;
        Tue, 17 May 2022 09:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 ipsec] xfrm: set dst dev to blackhole_netdev instead of
 loopback_dev in ifdown
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165277921155.14719.16431629079370629159.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 09:20:11 +0000
References: <e8c87482998ca6fcdab214f5a9d582899ec0c648.1652665047.git.lucien.xin@gmail.com>
In-Reply-To: <e8c87482998ca6fcdab214f5a9d582899ec0c648.1652665047.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, steffen.klassert@secunet.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 15 May 2022 21:37:27 -0400 you wrote:
> The global blackhole_netdev has replaced pernet loopback_dev to become the
> one given to the object that holds an netdev when ifdown in many places of
> ipv4 and ipv6 since commit 8d7017fd621d ("blackhole_netdev: use
> blackhole_netdev to invalidate dst entries").
> 
> Especially after commit faab39f63c1f ("net: allow out-of-order netdev
> unregistration"), it's no longer safe to use loopback_dev that may be
> freed before other netdev.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,ipsec] xfrm: set dst dev to blackhole_netdev instead of loopback_dev in ifdown
    https://git.kernel.org/netdev/net/c/4d33ab08c0af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


