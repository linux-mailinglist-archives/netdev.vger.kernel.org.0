Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EFA64A947
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:11:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbiLLVLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiLLVLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:11:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B1919008;
        Mon, 12 Dec 2022 13:11:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 263D3B80E66;
        Mon, 12 Dec 2022 21:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C19F7C43392;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670879472;
        bh=WBhG7uyfsUq2rp7tP8foDmxdYegku/4KerUvwsz1T34=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PJobA1SVkrKfc1jv1nWnZI2Mo2hBBDIoArgfTNbWdKNzDzTCRTSEQhizFzO3DlJrS
         TzMATm1zFxE7MWu17A3RaGLq8gBJHyBFbT0Kqp+tDZt0nARtx/rH58jSeldISA/N79
         QnbdGlHFpdPrqeRqpRld19wQQLXSxRSh6hBDcj22uHm1ofszV77DFEfCyDqY4SLgHL
         O6Eu5ASkYrOIK1XxRkJIbpuvVHk3JbI41QwRodqNWkeI73aTOTbsnPQdfM9BvyenmW
         jcXuUFsNpCMertmvlJ4adzHsV+4/ApYTehrWT5RJ+LhBHFZVl2EtuvkLcBQ3GxRxt1
         FglDp6ZpDhafw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4DA2E270C9;
        Mon, 12 Dec 2022 21:11:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 6.0 070/157] can: can327: flush TX_work on ldisc .close()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087947267.28989.6916321231543650902.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:11:12 +0000
References: <20221212130937.442350836@linuxfoundation.org>
In-Reply-To: <20221212130937.442350836@linuxfoundation.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        jirislaby@kernel.org, max@enpas.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-can@vger.kernel.org,
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

This series was applied to bpf/bpf-next.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Mon, 12 Dec 2022 14:16:58 +0100 you wrote:
> From: Max Staudt <max@enpas.org>
> 
> commit f4a4d121ebecaa6f396f21745ce97de014281ccc upstream.
> 
> Additionally, remove it from .ndo_stop().
> 
> This ensures that the worker is not called after being freed, and that
> the UART TX queue remains active to send final commands when the
> netdev is stopped.
> 
> [...]

Here is the summary with links:
  - [6.0,070/157] can: can327: flush TX_work on ldisc .close()
    https://git.kernel.org/bpf/bpf-next/c/f4a4d121ebec
  - [6.0,071/157] can: slcan: fix freed work crash
    https://git.kernel.org/bpf/bpf-next/c/fb855e9f3b6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


