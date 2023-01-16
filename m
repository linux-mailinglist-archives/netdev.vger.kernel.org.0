Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AE966BFF9
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjAPNkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbjAPNkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7BFE144BD
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80C39B80EB7
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14FC0C433F0;
        Mon, 16 Jan 2023 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673876416;
        bh=n7cp5RP96TWIwtUHW/L6iKNMDnDqSX2dNa14K/EZlbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o2RdMs3YT3zCc+gSGSxJcYLIZHBCV32RzPMGJIn7Lb2Y/qDUho0myeqRx19M3q8TK
         +mXyE/HLoUKK0gGPh0Fwyxo7LtR3kTcYwbxNpstFUJ76f3XwWqhaufoPL0tZ2qtY3L
         Ruh2Uft619LJznNRas5yYMVYxdVZ3arNylIOfL/o/3NqGaBzjnsYdL1MrafIGnpTc9
         /yL1pCZME4CyZCQWY0Z1gksullvBLPlCNzgQsfuOOEDSCHryBgWMpfcyy/N/DRzq8u
         tszfIYGIE3MmlU7LupyaGQccDJkefdb21Qo+n80sCe7k+8ph6WKb9vLf3aDf0ZfmSY
         UOJUK1gL1MCHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC709C5C7C4;
        Mon, 16 Jan 2023 13:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] r8169: reset bus if NIC isn't accessible after tx
 timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387641596.9239.15587974305650927814.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 13:40:15 +0000
References: <4534318d-b679-9399-e410-8aee2a9cbf58@gmail.com>
In-Reply-To: <4534318d-b679-9399-e410-8aee2a9cbf58@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 13 Jan 2023 23:46:19 +0100 you wrote:
> ASPM issues may result in the NIC not being accessible any longer.
> In this case disabling ASPM may not work. Therefore detect this case
> by checking whether register reads return ~0, and try to make the
> NIC accessible again by resetting the secondary bus.
> 
> v2:
> - add exception handling for the case that pci_reset_bus() fails
> 
> [...]

Here is the summary with links:
  - [net-next,v2] r8169: reset bus if NIC isn't accessible after tx timeout
    https://git.kernel.org/netdev/net-next/c/ce870af39558

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


