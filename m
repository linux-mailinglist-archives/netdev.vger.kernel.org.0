Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 730C146EC41
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 16:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240563AbhLIPxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 10:53:54 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:47834 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240537AbhLIPxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 10:53:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6DABACE2691;
        Thu,  9 Dec 2021 15:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88C0FC341C3;
        Thu,  9 Dec 2021 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639065009;
        bh=iKFw1SkivAtXoMkDv6HCrejky4o84z5oL0fXbqmawRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fqmouS3VQyKPqn4eWQVxGUxlWSYENSw6LeIQDqI6W2GvHyhtrJVdQFzPqkf62Ts8c
         NKWvAVK+JChsx+gyRfWwldLIjwoB3uEQ3lcKb4Sj3w/TCEHPpzNqyMSyNT8sN0pULL
         Twzhht7f8Q7Bb3AyY9sgkhR4CdMix1IndsnNGwRqbl9z/3se1k9AY+kkMvkYiRDUg3
         xV76NgCb9GYVkZTHVRQLTCT7GnH+i7X9CmH64OYSAKeTHHTQpCpXmFHBzSXQCk93Ql
         ZgOs+8hh1MKXdT/Ydux+7LZx9sOq6nEEFychNsfHE68ZMzgfE/Fdd+P8eGhF7djItH
         QUBANA1UoGRxA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64EA0609D7;
        Thu,  9 Dec 2021 15:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] can: kvaser_pciefd: kvaser_pciefd_rx_error_frame():
 increase correct stats->{rx,tx}_errors counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906500940.10006.10267892818348895466.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 15:50:09 +0000
References: <20211209081312.301036-2-mkl@pengutronix.de>
In-Reply-To: <20211209081312.301036-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de, extja@kvaser.com,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Thu,  9 Dec 2021 09:13:11 +0100 you wrote:
> From: Jimmy Assarsson <extja@kvaser.com>
> 
> Check the direction bit in the error frame packet (EPACK) to determine
> which net_device_stats {rx,tx}_errors counter to increase.
> 
> Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
> Link: https://lore.kernel.org/all/20211208152122.250852-1-extja@kvaser.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: kvaser_pciefd: kvaser_pciefd_rx_error_frame(): increase correct stats->{rx,tx}_errors counter
    https://git.kernel.org/netdev/net/c/36aea60fc892
  - [net,2/2] can: kvaser_usb: get CAN clock frequency from device
    https://git.kernel.org/netdev/net/c/fb12797ab1fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


