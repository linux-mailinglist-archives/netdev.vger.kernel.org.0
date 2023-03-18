Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103D26BF7DD
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjCRFAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjCRFAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4594F945;
        Fri, 17 Mar 2023 22:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8487BB826D2;
        Sat, 18 Mar 2023 05:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24CB0C433EF;
        Sat, 18 Mar 2023 05:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679115618;
        bh=crAEie36XOImJ/qQl4zX/JGKO9lLujy8hBEaFuTal4M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eLFsr8JkEfRbFiUA8HX/OfmGNVUjnZiA509RNxKv5Uy7S8GNbMwDHuaoE2gITnJxG
         JqbbsHyPo8snFThsw0yPwlV7nRm/D4FzgjSdHAFqFNOqoU2I+L2tc4Ezydp8JfXEzn
         ybGdfimIr34/fZ/LkTO3SmfmkxZPYGRF8vqnjkE9eBH2IzCJnFQjFI1EIXpXc2PrU1
         2QoyG5NtEC6bN0M2dduiGJpLM+oyU2ar8YIMIwb+ThhyFkld8t6pdHo7SOYkmbAIFX
         11+51l8l++oxvfeFDgDeayjFpNJH1QxXz1mIndNyuaKghFhL7a3ZAjBlQjM/gOVSFL
         jielTj9j/ZaDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09229E21EE6;
        Sat, 18 Mar 2023 05:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: b53: mmap: fix device tree support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911561803.25115.16411057391873150240.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:00:18 +0000
References: <20230316172807.460146-1-noltari@gmail.com>
In-Reply-To: <20230316172807.460146-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
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

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 18:28:07 +0100 you wrote:
> CPU port should also be enabled in order to get a working switch.
> 
> Fixes: a5538a777b73 ("net: dsa: b53: mmap: Add device tree support")
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  v2: switch to B53_N_PORTS
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: b53: mmap: fix device tree support
    https://git.kernel.org/netdev/net/c/30796d0dcb6e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


