Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9476E574E
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjDRCKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjDRCKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:10:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE9B12C;
        Mon, 17 Apr 2023 19:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67C6E62622;
        Tue, 18 Apr 2023 02:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BACCFC433D2;
        Tue, 18 Apr 2023 02:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681783819;
        bh=kQ6zw/lfkMNLksaXZVCMbwfvPw9Ucj/gHl1i7ZSW4DQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j2C9+vkV7gON74ijOdPEG3moiI7/9egr5eUIiVDTbxZLmf7Ojd5/GMraL9rvQ5jT7
         hE3G3AE0lq5ywJtfstA23+c/6tQWAxDoepKslAU4TrSnPVsHi02EWoeUDkCfrNurdS
         vAK341YasDeibwm3sqfJyzttBD7re44zS7It2y2Yb0HrGDBh1Lg4PhES1kbRxB92jz
         ClaE0nYIKIhiQql8GsU9tm1cj1mXidW9vPlIcnHF801i12vGF6A2sECZikfWmgJ64S
         LfGVYUa6tQSHbjHqjcVoUPtxJAqEjVVZSRHzB7WXAvyUj+STdHNtslZhWyJGPANfQc
         gkbX3XVLI6qiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DD33E3309F;
        Tue, 18 Apr 2023 02:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] Ocelot/Felix driver support for preemptible
 traffic classes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168178381963.5081.10115603505597492092.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 02:10:19 +0000
References: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230415170551.3939607-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        xiaoliang.yang_1@nxp.com, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 15 Apr 2023 20:05:44 +0300 you wrote:
> The series "Add tc-mqprio and tc-taprio support for preemptible traffic
> classes" from:
> https://lore.kernel.org/netdev/20230220122343.1156614-1-vladimir.oltean@nxp.com/
> 
> was eventually submitted in a form without the support for the
> Ocelot/Felix switch driver. This patch set picks up that work again,
> and presents a fairly modified form compared to the original.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: mscc: ocelot: export a single ocelot_mm_irq()
    https://git.kernel.org/netdev/net-next/c/15f93f46f312
  - [net-next,2/7] net: mscc: ocelot: remove struct ocelot_mm_state :: lock
    https://git.kernel.org/netdev/net-next/c/3ff468ef987e
  - [net-next,3/7] net: mscc: ocelot: optimize ocelot_mm_irq()
    https://git.kernel.org/netdev/net-next/c/7bf4a5b071e5
  - [net-next,4/7] net: mscc: ocelot: don't rely on cached verify_status in ocelot_port_get_mm()
    https://git.kernel.org/netdev/net-next/c/bddd96dd8077
  - [net-next,5/7] net: mscc: ocelot: add support for mqprio offload
    https://git.kernel.org/netdev/net-next/c/aac80140dc31
  - [net-next,6/7] net: dsa: felix: act upon the mqprio qopt in taprio offload
    https://git.kernel.org/netdev/net-next/c/a1ca9f8b07d8
  - [net-next,7/7] net: mscc: ocelot: add support for preemptible traffic classes
    https://git.kernel.org/netdev/net-next/c/403ffc2c34de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


