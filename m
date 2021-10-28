Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187C343D869
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhJ1BMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:53892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhJ1BMe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 21:12:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E288C60F6F;
        Thu, 28 Oct 2021 01:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635383408;
        bh=mDp1GwgekEy6ztl0VIl6cxvMpngpMPhc8/fK8g+I0Qs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TM9Fuegk/I3Z5IdkU8krvqaBC0HldYZR+y/f6JjYKdoLixsq5sx1o8tZp6ES8ACBl
         4xltjn2kc7DaSbVo9Mac9AhnWfm/+A3/87MZw0g1ikN1FPwlQV/Bj4HG1bjwXoEbNF
         deL2Y6Ty9qZQeljiD5B7fhDj3lPZMWecOdMDvDs2/om77hsVphfYs0k0pX7jyukvAx
         ZCWMTK8htlgCC2gUwDbyoPkQqmS7DT2UwXnIZZj1CFaVDLt6w20kRuKfmF/lephBjr
         VaSm7xW5V/tBYIIOud6wzKfZl82FjKFmHU8l5ZaXepsf0TA7EHknUcp/HMTch1iBHU
         lu0e0Fta0yg8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CAE4160972;
        Thu, 28 Oct 2021 01:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: Fix mdio child node detection
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163538340782.2556.11605372054075793094.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 01:10:07 +0000
References: <20211026173950.353636-1-linux@roeck-us.net>
In-Reply-To: <20211026173950.353636-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sean.anderson@seco.com,
        andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 10:39:50 -0700 you wrote:
> Commit 4d98bb0d7ec2 ("net: macb: Use mdio child node for MDIO bus if it
> exists") added code to detect if a 'mdio' child node exists to the macb
> driver. Ths added code does, however, not actually check if the child node
> exists, but if the parent node exists. This results in errors such as
> 
> macb 10090000.ethernet eth0: Could not attach PHY (-19)
> 
> [...]

Here is the summary with links:
  - net: macb: Fix mdio child node detection
    https://git.kernel.org/netdev/net-next/c/8db3cbc50748

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


