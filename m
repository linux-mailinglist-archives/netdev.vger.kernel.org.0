Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5F3616260
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiKBMAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:00:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiKBMAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBA21F8;
        Wed,  2 Nov 2022 05:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3C1BB821D8;
        Wed,  2 Nov 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78C0DC433D6;
        Wed,  2 Nov 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667390416;
        bh=MLMiNgKQ47MiTBdvKuAqu/9RyqJIVmLHyYclffVTKdM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PF0yM/+lZuwqbL4spPvlF9jBe0rjyzaR4mTR2qpe1XkbAEDcLDHy5oDUz5iVveaHl
         jiGhafvAWwq35dezxfKbNxn3dDTgLaxGopDm+AkXCxSdIoGKoRjb2M0JwFXiG/dnKR
         yMSqxyRR0mz34R8o9be56+x62QJUIeOuzu4X8q9qFHOGl/suWfEmZjtfnWtymqNeXi
         ar3jAdlMB+GDB6llfbUP5bm8QQ21+vb/npzPsQMvG8wurbf5wQhkphtQAgVPzbuiwV
         +cq2z6lAMA85lA7VCocFl4cJykC63btZBgln0z85HcD37VFyTlJUIYHPqmos5Y0yUV
         nLu38APynC7PA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61F9FC395FF;
        Wed,  2 Nov 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: wwan: iosm: add rpc interface for xmm modems
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739041639.9516.5047338636227466746.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 12:00:16 +0000
References: <20221029090355.565200-1-shaneparslow808@gmail.com>
In-Reply-To: <20221029090355.565200-1-shaneparslow808@gmail.com>
To:     Shane Parslow <shaneparslow808@gmail.com>
Cc:     loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        linuxwwan@intel.com, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 29 Oct 2022 02:03:56 -0700 you wrote:
> Add a new iosm wwan port that connects to the modem rpc interface. This
> interface provides a configuration channel, and in the case of the 7360, is
> the only way to configure the modem (as it does not support mbim).
> 
> The new interface is compatible with existing software, such as
> open_xdatachannel.py from the xmm7360-pci project [1].
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: wwan: iosm: add rpc interface for xmm modems
    https://git.kernel.org/netdev/net-next/c/d08b0f8f46e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


