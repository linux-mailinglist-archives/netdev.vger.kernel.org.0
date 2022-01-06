Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DB4485E06
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 02:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344310AbiAFBUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 20:20:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43300 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344308AbiAFBUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 20:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D21461A11;
        Thu,  6 Jan 2022 01:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B41FAC36AE9;
        Thu,  6 Jan 2022 01:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641432009;
        bh=U48RtyVvcZAb11ESIWJVKP2J8q2PyXH7STc+hMqc/JI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oauJHd2MfyOUYEi+eNsBBH8VLAAKF1YWFruBOfceckDs6GAcZfdpgRE3rFeHwlWzS
         /LDkZVE9jo1xIP5Uqu3JgjxBy9cxQBXzZp6K9zmchvLcrzFBwOdU51I5DDcA4izSF2
         GcL/KWuhWyRPfMGN1UHyXt6gM1p9RzvFFiCvB3AmdrOhGXuQhPqoklfr8z6LOucACU
         Hx3ioHbhl811L+MaCOxqKlJNeN0WTHj32hI1yVbJ4RKQDb3zE8LCpj5XYz7HsJ8eqS
         qNJX1qvrP++8pqEpBmnRvOIhFKpj/9lxQm3s87ZmLnVjJYxMnYzMq0GVjZhctJOQS5
         MZLbvXwlayqVA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99D64F7940B;
        Thu,  6 Jan 2022 01:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] can: gs_usb: fix use of uninitialized variable,
 detach device on reception of invalid USB data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164143200962.6490.5453127499700459621.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jan 2022 01:20:09 +0000
References: <20220105205443.1274709-2-mkl@pengutronix.de>
In-Reply-To: <20220105205443.1274709-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed,  5 Jan 2022 21:54:42 +0100 you wrote:
> The received data contains the channel the received data is associated
> with. If the channel number is bigger than the actual number of
> channels assume broken or malicious USB device and shut it down.
> 
> This fixes the error found by clang:
> 
> | drivers/net/can/usb/gs_usb.c:386:6: error: variable 'dev' is used
> |                                     uninitialized whenever 'if' condition is true
> |         if (hf->channel >= GS_MAX_INTF)
> |             ^~~~~~~~~~~~~~~~~~~~~~~~~~
> | drivers/net/can/usb/gs_usb.c:474:10: note: uninitialized use occurs here
> |                           hf, dev->gs_hf_size, gs_usb_receive_bulk_callback,
> |                               ^~~
> 
> [...]

Here is the summary with links:
  - [net,1/2] can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
    https://git.kernel.org/netdev/net/c/4a8737ff0687
  - [net,2/2] can: isotp: convert struct tpcon::{idx,len} to unsigned int
    https://git.kernel.org/netdev/net/c/5f33a09e769a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


