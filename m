Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5C73E9ABE
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 00:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhHKWKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 18:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232453AbhHKWKa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 18:10:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D06F6109F;
        Wed, 11 Aug 2021 22:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628719806;
        bh=prXndJNjaIm3bcDrbf+XDXd7YHauPH4WIVLJ+tBG3nA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MmmNfMWGAi3xm33Q8oD/LTwYRmFSTu5ypi7SeQs/s9P/4JwX1m7ZZpWoUDUUwh2V9
         qoc95T1C+JNZJxO3zu3QcoWtAPrC7Qd6seuDuPa2Yx+jEyJbVZvFgqyryZ2MAO+/f0
         UTcMiSGMGntEE4vcK6E/GscZ5bh+EP1ao43tYHTM/FIwHk1FG/MtTugp0ZIQtH8YPK
         dak75TGEz1Vdr79g6SfHHdSrXfpmAt/hlGjK4+Bqpg7e/GYgDpTmm3TC1PJNbuD5zw
         Bq1i+8we7C3/nCG9yrqY+eESGJB7Jn7DEFW2NH3C7T1ugZTQLX09+Vm9IDPLOV5kkH
         nQRqidFZi0P1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35AB860A54;
        Wed, 11 Aug 2021 22:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] bonding: cleanup header file and error msgs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162871980621.25380.6433139082031839938.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 22:10:06 +0000
References: <cover.1628650079.git.jtoppins@redhat.com>
In-Reply-To: <cover.1628650079.git.jtoppins@redhat.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, joe@perches.com, leon@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 22:53:29 -0400 you wrote:
> Two small patches removing unreferenced symbols and unifying error
> messages across netlink and printk.
> 
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> 
> Jonathan Toppins (2):
>   bonding: remove extraneous definitions from bonding.h
>   bonding: combine netlink and console error messages
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] bonding: remove extraneous definitions from bonding.h
    https://git.kernel.org/netdev/net-next/c/891a88f4f576
  - [net-next,v2,2/2] bonding: combine netlink and console error messages
    https://git.kernel.org/netdev/net-next/c/6569fa2d4e01

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


