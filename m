Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094F72FD743
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 18:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbhATRfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 12:35:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:36528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727489AbhATRas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 12:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8EFB9233ED;
        Wed, 20 Jan 2021 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611163808;
        bh=1OGeVor8PoAEPAnPzHXCQGagjAn4PrpYzP1UZodirUY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UsSAeK4B6p8Ldl+RBrEw1M+AWmp3qK2cMqR6PC0cMQwRnEvsGsqZ5w7T5CQCAWPfF
         QZGOwMrtwULFAUiwxFCQebJprAOKfr17pN5WJBxM8lF/CUosBEHMESrYcRgna8zZDc
         W1Psu+hYNL0hhPIdw+tgkSQcFQFNGFgE1xyH43bQPlV2E7tib/WSB4G9lgWn16gFkd
         ovu/rKT1C0mMBn2ppGmYgoSi93dNccl6KzqK2clQYCBNJF7G5CLr5B4sssmmPvXt/6
         P9+qIGdv+cSfcH4ISDZveTB+dcVWAHnzhuk3u8YKRDVAUaDnwq01cS1hksmPbMWjV/
         7KGr2qMYckP+A==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 84B216036C;
        Wed, 20 Jan 2021 17:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/3] Fix several use after free bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161116380853.4786.15085299208073374903.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 17:30:08 +0000
References: <20210120114137.200019-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210120114137.200019-1-mailhol.vincent@wanadoo.fr>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     mkl@pengutronix.de, socketcan@hartkopp.net,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        wg@grandegger.com, s.grosjean@peak-system.com,
        loris.fauster@ttcontrol.com, alejandro@acoro.eu,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 20 Jan 2021 20:41:34 +0900 you wrote:
> This series fix three bugs which all have the same root cause.
> 
> When calling netif_rx(skb) and its variants, the skb will eventually
> get consumed (or freed) and thus it is unsafe to dereference it after
> the call returns.
> 
> This remark especially applies to any variable with aliases the skb
> memory which is the case of the can(fd)_frame.
> 
> [...]

Here is the summary with links:
  - [v4,1/3] can: dev: can_restart: fix use after free bug
    https://git.kernel.org/netdev/net/c/03f16c5075b2
  - [v4,2/3] can: vxcan: vxcan_xmit: fix use after free bug
    https://git.kernel.org/netdev/net/c/75854cad5d80
  - [v4,3/3] can: peak_usb: fix use after free bugs
    https://git.kernel.org/netdev/net/c/50aca891d7a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


