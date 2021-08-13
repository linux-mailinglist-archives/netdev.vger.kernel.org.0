Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CA43EBE66
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235256AbhHMW4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:56:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhHMW4A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 576206109E;
        Fri, 13 Aug 2021 22:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628895333;
        bh=6Kk3XSZO5zzzqgw4D1S1W5HVrfLIgqrvSPZxHndEEfU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JXiDP9Mgb64VfccxgKvdZbMBocaRjNmwY5LUk6owk2Gp/TD/iHUeIrZFOVwj4vPCY
         v2AFQLA3sIVw6jApij/FxvzbX0Fp8Jk4yhT4+Sn90cASGJfmlUPPjyX6IDDZ69cdeX
         cnYYLUSbJW3sMzOkAH7LAfglg3ztyMhJAwrB22KAyyDHh1XwTiV1zD6y02iDOj4j9w
         QlnRIqfLRx6dnkEgydPcQ1JiOPObYPMtfg3yAIDrSnhJnMT10EpdTjhrkdLO2I/EkY
         Rw9BTm7sAbUvhqWYiP38Mx6A4CNrdAepvgyK/oJVxp5MxNuGadsu+k9BOAAkMlprmi
         ayYv+hMFkQSmg==
Date:   Fri, 13 Aug 2021 15:55:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next 3/6 v2] ixp4xx_eth: enable compile testing
Message-ID: <20210813155532.4e3f9a20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813220011.921211-4-linus.walleij@linaro.org>
References: <20210813220011.921211-1-linus.walleij@linaro.org>
        <20210813220011.921211-4-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Aug 2021 00:00:08 +0200 Linus Walleij wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver is now independent of machine specific header
> files and should build on all architectures, so enable
> building with CONFIG_COMPILE_TEST.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

does not build on x86 allmodconfig?

drivers/net/ethernet/xscale/ptp_ixp46x.c:20:10: fatal error: mach/ixp4xx-regs.h: No such file or directory
   20 | #include <mach/ixp4xx-regs.h>
      |          ^~~~~~~~~~~~~~~~~~~~
