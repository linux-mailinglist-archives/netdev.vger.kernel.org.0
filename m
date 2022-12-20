Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368BF65186A
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 02:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiLTBoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 20:44:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbiLTBnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 20:43:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D148920360;
        Mon, 19 Dec 2022 17:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E356B8111C;
        Tue, 20 Dec 2022 01:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29258C433D2;
        Tue, 20 Dec 2022 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671499816;
        bh=rpcsgYHJM+oFaznNJPhOHkZYxtUkbdWCteSgdck/oMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TqdIq9Tx7hZa8heKW/+Gw8sofX5888ibSCvY6/A9sPIeZE68SDfGdb5lR7kPQMIGO
         qIpEgjwoGfo/a4jGpQyBpLIzHovc8RkfZoMMS97M8fdS2FDQDT4+Rfar6RKjGVMuac
         AjFlF3gy/LlUUd8E+WShPJG3qIj+7ULvBn/ATuSl4sqCX06AvMVSz65oVXlNlThGfn
         yq7SJeBpSKxkXNV+c9kew2H/QPZ8r6YawNwZX6fTw/EnYJgSL/gPG+xg6jLXVM1ZaV
         +ld5gpCswf2zUzq9MzSXAQsEZJbN77nJGFC8r8s0om5rYWXnLdwzrvG04NdjOUhe/E
         tmWgXe2qDScWQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0DBBDC43159;
        Tue, 20 Dec 2022 01:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net] net: dsa: microchip: remove IRQF_TRIGGER_FALLING in
 request_threaded_irq
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167149981605.31045.4149895969466202774.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Dec 2022 01:30:16 +0000
References: <20221213101440.24667-1-arun.ramadoss@microchip.com>
In-Reply-To: <20221213101440.24667-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, ceggers@arri.de
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

On Tue, 13 Dec 2022 15:44:40 +0530 you wrote:
> KSZ swithes used interrupts for detecting the phy link up and down.
> During registering the interrupt handler, it used IRQF_TRIGGER_FALLING
> flag. But this flag has to be retrieved from device tree instead of hard
> coding in the driver, so removing the flag.
> 
> Fixes: ff319a644829 ("net: dsa: microchip: move interrupt handling logic from lan937x to ksz_common")
> Reported-by: Christian Eggers <ceggers@arri.de>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: microchip: remove IRQF_TRIGGER_FALLING in request_threaded_irq
    https://git.kernel.org/netdev/net/c/62e027fb0e52

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


