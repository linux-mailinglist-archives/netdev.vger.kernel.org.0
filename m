Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7873733F92E
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbhCQTag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:30:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:55590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233239AbhCQTaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 15:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8F78664E98;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616009410;
        bh=DgavD9Lvmo+7ZEafLvib4HBvFr9c4p9GaVdV+TTLNqM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lnw/4RGNa+hAm9VO7kPuF56EnfnOEw/bRHkx2Ka6sz8i0+nXJWC4A+blMYJndWQpZ
         X9NUuqL3C9XIDRvFPQzgLUhhkOCodM6IVN/wLKDuVn5RZSVpj4UTq5SWEaSIbYUkee
         RgsO1T8ubQDhOs6eKR0+Ug5PnanpD/Ie13WVVaQLLpFGnCj6EqWKUNGouWLD6d5MrF
         xYH7GYasmAApO1FfeToLXPdcmGiiAKIyXTOChD+0uyDq/2xEr2UeZjzTRGJnXSimol
         bynSda3/eI/5CWuEAdgdUFhux+FGCvMqJhvqRJwptVmXqYITgHSOAZZV6ncr+50KbR
         J5nk4MMWt12DQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D55F60A60;
        Wed, 17 Mar 2021 19:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] net: dsa: b53: support legacy tags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161600941050.18835.372070166540076281.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Mar 2021 19:30:10 +0000
References: <20210317102927.25605-1-noltari@gmail.com>
In-Reply-To: <20210317102927.25605-1-noltari@gmail.com>
To:     =?utf-8?q?=C3=81lvaro_Fern=C3=A1ndez_Rojas_=3Cnoltari=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     jonas.gorski@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Mar 2021 11:29:25 +0100 you wrote:
> Legacy Broadcom tags are needed for older switches.
> 
> Álvaro Fernández Rojas (2):
>   net: dsa: tag_brcm: add support for legacy tags
>   net: dsa: b53: support legacy tags
> 
>  drivers/net/dsa/b53/Kconfig      |   1 +
>  drivers/net/dsa/b53/b53_common.c |  12 ++--
>  include/net/dsa.h                |   2 +
>  net/dsa/Kconfig                  |   7 ++
>  net/dsa/tag_brcm.c               | 107 ++++++++++++++++++++++++++++++-
>  5 files changed, 121 insertions(+), 8 deletions(-)

Here is the summary with links:
  - [v2,net-next,1/2] net: dsa: tag_brcm: add support for legacy tags
    https://git.kernel.org/netdev/net-next/c/964dbf186eaa
  - [v2,net-next,2/2] net: dsa: b53: support legacy tags
    https://git.kernel.org/netdev/net-next/c/46c5176c586c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


