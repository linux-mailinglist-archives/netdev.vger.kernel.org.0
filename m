Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 464E064261C
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiLEJuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiLEJuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD6C55A6
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21200B80E05
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 09:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFCB2C43148;
        Mon,  5 Dec 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670233816;
        bh=eFXPektRJveGTmX3zkOKtyTzdtuIDBnjugPGsSYRqdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EcmM8/aOHKipfLQdMOriaUhHibSLNZBnUqxSO38661DMu2af4RDlu7qAQEv5P9Gn0
         +6JNfA60m9bge1fuVUoX58vkfjJQo0C3pehbhe+eP/bqMj2N+kTq/a8zcp/lCITfSn
         4UZo7n8aCB+CIkVl3Isw+4eA1nOv35ImSI75UaE6NBmrVlrs+ApKjz0IOxKMilRUSF
         dFJSRUcJdp3hvmf7GmN3rrwytDr+7Wce/m5MFKDSenBprqS/jFO52mNcFA1fvLxBAW
         xOdltpFJ9+5jyjzYPLhqE29CoY7jYy8R2ANwuBM3VtzuVI6BYLEH3sQ8C26B51Ueat
         /3voEpA687TlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7526C395E5;
        Mon,  5 Dec 2022 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: add and use
 netdev_sw_irq_coalesce_default_on()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167023381674.8030.11755427036235097524.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 09:50:16 +0000
References: <e4d1cc88-2064-caa0-c786-41f8720869a4@gmail.com>
In-Reply-To: <e4d1cc88-2064-caa0-c786-41f8720869a4@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 30 Nov 2022 23:25:23 +0100 you wrote:
> There are reports about r8169 not reaching full line speed on certain
> systems (e.g. SBC's) with a 2.5Gbps link.
> There was a time when hardware interrupt coalescing was enabled per
> default, but this was changed due to ASPM-related issues on few systems.
> 
> Meanwhile we have sysfs attributes for controlling kind of
> "software interrupt coalescing" on the GRO level. However most distros
> and users don't know about it. So lets set a conservative default for
> both involved parameters. Users can still override the defaults via
> sysfs. Don't enable these settings on the fast ethernet chip versions,
> they are slow enough.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: add netdev_sw_irq_coalesce_default_on()
    https://git.kernel.org/netdev/net-next/c/d93607082e98
  - [net-next,2/2] r8169: enable GRO software interrupt coalescing per default
    https://git.kernel.org/netdev/net-next/c/42f66a44d837

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


