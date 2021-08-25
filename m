Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4EF43F7279
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239807AbhHYKBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:01:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239611AbhHYKA7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:00:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 80EA661178;
        Wed, 25 Aug 2021 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629885613;
        bh=yp3IRO9FCB9oK1+XLLX639+q9a7keOG91VnqqQQXNBk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mvvAXOOjCMbGE2rLJUvufqrW2+2SsAkPzoZ8FoMc4HtXrui78wEou98+it7HIQQt1
         Y0A0yzImCMv9iTDiaPqu3buf6mc5mBXD01635oEoFeOdDYwb52aVOG2bXsOnbpS5ET
         gqkFZ3FcFWBHfVJYTrPqJe45XZ6c4Ov8ocaCjCDiydr1VnqeTNDLX+I+/j/vj+blI7
         f0ePQ/pE24G1MQDIKDYnA9ScB/kQ8+IkRAJuLc43zNz34K1z60H+2r6GGGvgBd9zNQ
         vLh+lYsI1HlHHjLwSJSTXE/TeX91lrPPWEhlO83CnRi7GrNV8Q4uh0wAmVagJPifj4
         wr9CzYKzBS0aw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 751FB60A02;
        Wed, 25 Aug 2021 10:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/10] LAN7800 driver improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988561347.31154.16868294892793404021.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:00:13 +0000
References: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
In-Reply-To: <20210824185613.49545-1-john.efstathiades@pebblebay.com>
To:     John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 19:56:03 +0100 you wrote:
> This patch set introduces a number of improvements and fixes for
> problems found during testing of a modification to add a NAPI-style
> approach to packet handling to improve performance.
> 
> NOTE: the NAPI changes are not part of this patch set and the issues
>       fixed by this patch set are not coupled to the NAPI changes.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/10] lan78xx: Fix white space and style issues
    https://git.kernel.org/netdev/net-next/c/9ceec7d33adf
  - [net-next,v2,02/10] lan78xx: Remove unused timer
    https://git.kernel.org/netdev/net-next/c/3bef6b9e9888
  - [net-next,v2,03/10] lan78xx: Set flow control threshold to prevent packet loss
    https://git.kernel.org/netdev/net-next/c/dc35f8548e00
  - [net-next,v2,04/10] lan78xx: Remove unused pause frame queue
    https://git.kernel.org/netdev/net-next/c/40b8452fa8b4
  - [net-next,v2,05/10] lan78xx: Add missing return code checks
    https://git.kernel.org/netdev/net-next/c/3415f6baaddb
  - [net-next,v2,06/10] lan78xx: Fix exception on link speed change
    https://git.kernel.org/netdev/net-next/c/b1f6696daafe
  - [net-next,v2,07/10] lan78xx: Fix partial packet errors on suspend/resume
    https://git.kernel.org/netdev/net-next/c/e1210fe63bf8
  - [net-next,v2,08/10] lan78xx: Fix race conditions in suspend/resume handling
    https://git.kernel.org/netdev/net-next/c/5f4cc6e25148
  - [net-next,v2,09/10] lan78xx: Fix race condition in disconnect handling
    https://git.kernel.org/netdev/net-next/c/77dfff5bb7e2
  - [net-next,v2,10/10] lan78xx: Limit number of driver warning messages
    https://git.kernel.org/netdev/net-next/c/df0d6f7a342c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


