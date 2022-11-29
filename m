Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9808063B7B7
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235170AbiK2CUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234795AbiK2CUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095212AC6D;
        Mon, 28 Nov 2022 18:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A000C6152E;
        Tue, 29 Nov 2022 02:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0A42C43470;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669688417;
        bh=gA9o+Q1pX1a5YN1qUo3JSKHYTmcCScQC4+gx69uFiu0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UicuvELBoSSDn1ARVbqWWdNf16aFzuPftno0NkkE1LgDDwkC+3Bw7uQKN+0z/h3jz
         FffJyp7s0zcnJY5WPKUAMdBX+KxCf+3ToZlkeCssf8oTVA1fe1MFQTqCPP/ZdMisMa
         e0+GDK3/AMdh3ydZOgAyn8sVurKfpx/8MQRARZgT/W/IVpv18ihUqzOYoKt04uTVmT
         t8RdSXD9TtxnWChUNpB2Onvkp0MgJhjDlHtLLDimGDJ3epGW9lryWC0TVUmVFbFGzb
         Iz8QN+vlfMInFqL82nrQiFGajtz6uAM2PyQiXeZICpGZBMj4lI6FWZCHYJT/aXFeu8
         8gd5Pci9R4DSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D262CE29F43;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] dsa: lan9303: Correct stat name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968841685.21086.964893464837475677.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 02:20:16 +0000
References: <20221128193559.6572-1-jerry.ray@microchip.com>
In-Reply-To: <20221128193559.6572-1-jerry.ray@microchip.com>
To:     Jerry Ray <jerry.ray@microchip.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 28 Nov 2022 13:35:59 -0600 you wrote:
> Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
> 
> This patch changes the reported ethtool statistics for the lan9303
> family of parts covered by this driver.
> 
> The TxUnderRun statistic label is renamed to RxShort to accurately
> reflect what stat the device is reporting.  I did not reorder the
> statistics as that might cause problems with existing user code that
> are expecting the stats at a certain offset.
> 
> [...]

Here is the summary with links:
  - [net] dsa: lan9303: Correct stat name
    https://git.kernel.org/netdev/net/c/39f59bca275d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


