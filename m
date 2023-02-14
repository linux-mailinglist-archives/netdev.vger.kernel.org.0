Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4746469561B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 02:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjBNBuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 20:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBNBuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 20:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CECD23C02;
        Mon, 13 Feb 2023 17:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76285B81A38;
        Tue, 14 Feb 2023 01:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 058EDC433D2;
        Tue, 14 Feb 2023 01:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676339416;
        bh=GVCDXYHPHV8m9gQ5XABgkmWqcqVNH1OfZdV+l/FBlTw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m8fX8RK3zS9UvXNEQnhG6zZOzLhgTnF7qDK+hzqNIt/7vLZVMMY7E20t865OphAzz
         ZVD5WgYJZSp6HlVGyVaBfQjLI5jS2GmQwkGwVr/aw4wVbRTIbq5tHFLGt+fW80+we7
         Dzv08OXmn2q3RbEJaonJt6YOBs6oCM3UA5/NxODwo25IlG8CuJKWUYMiVJrvEeQG/t
         Dhrgw3dtwxfStzMalwO5L36g/mO/GL5U+BNfBGn7hvaGbmKCm6p6NtrzCljvxRS/cY
         9e8Trl6adxNwrlwxn8cDui8jb2jr7h/8UIoXlh0IjbR+eloLQ6p1XXMq/9GDa9htCA
         yPThk9zjvQbHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DABEBE68D2E;
        Tue, 14 Feb 2023 01:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] net: lan966x: set xdp_features flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167633941589.29643.17678280457537028952.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Feb 2023 01:50:15 +0000
References: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
In-Reply-To: <01f4412f28899d97b0054c9c1a63694201301b42.1676055718.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        lorenzo.bianconi@redhat.com, horatiu.vultur@microchip.com,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 10 Feb 2023 20:06:04 +0100 you wrote:
> Set xdp_features netdevice flag if lan966x nic supports xdp mode.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [bpf-next] net: lan966x: set xdp_features flag
    https://git.kernel.org/netdev/net-next/c/ef01749f6a0d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


