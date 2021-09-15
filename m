Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DCE40BE04
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 05:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhIODL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 23:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhIODLZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 23:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D0AC4611ED;
        Wed, 15 Sep 2021 03:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631675406;
        bh=lf57Nvopw7ePrHp9LN5rP+Ur4wXJOevf6d91CwjDeik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=leiN7EjXoAjLARUFl3FIJkU6lxUZLce1MVD7byUNZD9fIEp+BBqpYMh1D30jPChiL
         5zhsBcqM+F7ETTYm55iF4jEDzOTtp2lo8w4K56avmuW7TyQwEEh7ymKZ/6Lsw4iXJD
         TDphl8QmvNi6BOZYB8rxgwSNI74YrCH4blIvIsD1PFONvSt0eL8OEDaqO1njMK0L27
         zJR4Qy48OwzgojDxv0KsYI1lHeeBHUV1Bq6CGPrHlXVkdEzxApqrhtQw155qWZPUcs
         NRUGTpZQd7CM6Ln3TTEQh7Y8kFb6vlcfUIhYvzas+0M6OqrgoPB3y4DPwE59iYRhzT
         wDjJ1nEHyphNg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B683760A8F;
        Wed, 15 Sep 2021 03:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -net] ptp: dp83640: don't define PAGE0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163167540674.9269.1991816632448031713.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Sep 2021 03:10:06 +0000
References: <20210913220605.19682-1-rdunlap@infradead.org>
In-Reply-To: <20210913220605.19682-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, geert@linux-m68k.org,
        richard.cochran@omicron.at, john.stultz@linaro.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 13 Sep 2021 15:06:05 -0700 you wrote:
> Building dp83640.c on arch/parisc/ produces a build warning for
> PAGE0 being redefined. Since the macro is not used in the dp83640
> driver, just make it a comment for documentation purposes.
> 
> In file included from ../drivers/net/phy/dp83640.c:23:
> ../drivers/net/phy/dp83640_reg.h:8: warning: "PAGE0" redefined
>     8 | #define PAGE0                     0x0000
>                  from ../drivers/net/phy/dp83640.c:11:
> ../arch/parisc/include/asm/page.h:187: note: this is the location of the previous definition
>   187 | #define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
> 
> [...]

Here is the summary with links:
  - [-net] ptp: dp83640: don't define PAGE0
    https://git.kernel.org/netdev/net/c/7366c23ff492

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


