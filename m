Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EB4443AD2
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 02:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhKCBWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 21:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231201AbhKCBWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 21:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 35DD261058;
        Wed,  3 Nov 2021 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635902408;
        bh=xz2g5JfZDyK0IGAbEqFOWxKl2xmn0KhYbX1nfqF7FF4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lDG1HNhb6SSlAetWs+av0HkaG5FhhLpYVVY4VSBVSswyqB1zanN6rROy0WzIvuISd
         0XV1tdxcKJ6aK2ebZJA8TK9KsIMDnvEB8op3lylFAW8vdM/xawpOows1GRZtMkIgGj
         xZRlDJJS0KxF7rZyb+TicbN4VUDU+baHbwL1tjL/upVtMinTezCwhSSJvVAs+p2YUk
         8EjcBhK2mEUPzU36xbZfOfw5It6Aa0ZDM7gjphZORVaozn657KXSjgx2+wnaUXR6oi
         iHlZnQDXpb+QNas64vAt55mVqG1TC6u+BdEGlaC6PDb5iNDyD/9LA3GYDnhkDl7NkL
         zbvnI9gjIHQJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2861260AA2;
        Wed,  3 Nov 2021 01:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [-next] net: marvell: prestera: Add explicit padding
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590240815.27381.18274139926470916767.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 01:20:08 +0000
References: <20211102082433.3820514-1-geert@linux-m68k.org>
In-Reply-To: <20211102082433.3820514-1-geert@linux-m68k.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     tchornyi@marvell.com, davem@davemloft.net, kuba@kernel.org,
        vmytnyk@marvell.com, yevhen.orlov@plvision.eu, vkochan@marvell.com,
        arnd@arndb.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  2 Nov 2021 09:24:33 +0100 you wrote:
> On m68k:
> 
>     In function ‘prestera_hw_build_tests’,
> 	inlined from ‘prestera_hw_switch_init’ at drivers/net/ethernet/marvell/prestera/prestera_hw.c:788:2:
>     ././include/linux/compiler_types.h:335:38: error: call to ‘__compiletime_assert_345’ declared with attribute error: BUILD_BUG_ON failed: sizeof(struct prestera_msg_switch_attr_req) != 16
>     ...
> 
> [...]

Here is the summary with links:
  - [-next] net: marvell: prestera: Add explicit padding
    https://git.kernel.org/netdev/net/c/236f57fe1b88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


