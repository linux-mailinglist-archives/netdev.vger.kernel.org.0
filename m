Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E6A453ED2
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbhKQDNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:13:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhKQDNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:13:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4F82C61BF9;
        Wed, 17 Nov 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637118609;
        bh=KeKZK4NfFw+XeRWvxZTjeXhn5HYOELRMB9po1qn1lMM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J+fTHaItsvbom3Nj+/6L/2oTw/0giXjhkVGSYDxVhYVJ8DZ2nhJ+6a7nM2ZOS0nQx
         fSkh9U7v4VnstEYArtTWDGDfqupwOmIuZc7WsrFcnuhkzo5zeIzstdfpdbFE5zTCgu
         Bbv5/wX+dFfSZNUEd1rGclc++KgitOL6+OW+g8Y9z/e0WISs4eh5QFvZHsF+1ck5h6
         ioesIAiI7kjFr3KzpNYifJb2ohhvWvJ9dvwanzGnDnG4UjBvI/FogFFD3xVYlip8pN
         0mClcaZ60Wo7L3PzSBAbU9yH8V6W2bV6DueYqa5UBp6ZUn0Ivi+PbHpXBD32GdkAtT
         jjsXHKG7iUK8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40F3660A0C;
        Wed, 17 Nov 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net: PATCH] net: mvmdio: fix compilation warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163711860926.28737.8115206647292837561.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 03:10:09 +0000
References: <20211115153024.209083-1-mw@semihalf.com>
In-Reply-To: <20211115153024.209083-1-mw@semihalf.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, upstream@semihalf.com,
        lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 15 Nov 2021 16:30:24 +0100 you wrote:
> The kernel test robot reported a following issue:
> 
> >> drivers/net/ethernet/marvell/mvmdio.c:426:36: warning:
> unused variable 'orion_mdio_acpi_match' [-Wunused-const-variable]
>    static const struct acpi_device_id orion_mdio_acpi_match[] = {
>                                       ^
>    1 warning generated.
> 
> [...]

Here is the summary with links:
  - [net:] net: mvmdio: fix compilation warning
    https://git.kernel.org/netdev/net/c/2460386bef0b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


