Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E00457A114
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiGSOSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232225AbiGSORr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:17:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D374331A;
        Tue, 19 Jul 2022 06:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 85C6A616A0;
        Tue, 19 Jul 2022 13:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A698FC341CB;
        Tue, 19 Jul 2022 13:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658238612;
        bh=DGlxRP33VqzBfDwOICrhSjITDqlOpZRqqdCXeOJUUjk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zzde+bpKJZmriDIrR78oKmFK0KAU39l4/NfYJ4BoHwxq4Oyrlo+EzIocz/Ct03vDC
         DBwAoTxlw16uXE8w3D3IeYIL5KMR2T+nP5kqa4eu5oTbn4PLK3T24nGLvT9VEjahwK
         00AUP4s6FhdcFUgQH2jeJkot0upjlx4UT5rzLt48610J4Fb8/FmZT3AkpLZ4TCcbip
         itnKtZpIHWrgz0Y5WSvV2kurIraiwoWH+1XSpTLguoMJ66frtwPJ0S/kZo3dA9vaa4
         xgpcpPpghbxk+/EdvjXP8poKPOkdKK6W0R/LWvRrmosnCLmnpH9kk0P05cg55ta4p5
         v7Yq0TAxqlPNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 880E3E451B3;
        Tue, 19 Jul 2022 13:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: microchip: fix the missing ksz8_r_mib_cnt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165823861255.29302.8893482972654729793.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jul 2022 13:50:12 +0000
References: <20220718061803.4939-1-arun.ramadoss@microchip.com>
In-Reply-To: <20220718061803.4939-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 18 Jul 2022 11:48:03 +0530 you wrote:
> During the refactoring for the ksz8_dev_ops from ksz8795.c to
> ksz_common.c, the ksz8_r_mib_cnt has been missed. So this patch adds the
> missing one.
> 
> Fixes: 6ec23aaaac43 ("net: dsa: microchip: move ksz_dev_ops to ksz_common.c")
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: microchip: fix the missing ksz8_r_mib_cnt
    https://git.kernel.org/netdev/net-next/c/769e2695be41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


