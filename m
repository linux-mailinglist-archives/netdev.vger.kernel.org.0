Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80AB73F7353
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 12:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240080AbhHYKbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 06:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239832AbhHYKaz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 06:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D0BDD613E8;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629887409;
        bh=QxNPND8whzJZmLWkGIhNxzjS74KIwRCbePGXSXtZ9rA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NJdk/ZIyx/KVVtKNSY5FtyKDN8uYaDVg97f/ZH11MqEMH52akXhcTog4Gwg+ok7h4
         mUn1hBro2hPnBJHAZxze22761fvidfZslHsXDPg4atOp4jdgVTs8MyN0gTqsLzgaYb
         m/BnUDlJLflLP9juNFKlAwHBug95gKfwLDRZF4Ozx+X5UDJqNYginVwCF2ivbmuOgH
         y7kz4YB31GtCvvOV8/9Fz2yESl/FTXG3X9ePHzk4xqioXAn83kTSOVslRecAy/ScnO
         jGrN5BkYO1XdsApmEdHbaMmVUKYncssTh/wvt6MzMRM5QHnAPbsewF3OFFVASAChMT
         acB5yg7dBhHYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7BBF6097B;
        Wed, 25 Aug 2021 10:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] can: mscan: mpc5xxx_can: Remove useless BUG_ON()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162988740981.13655.329309070918965320.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Aug 2021 10:30:09 +0000
References: <20210825070752.18724-1-tangbin@cmss.chinamobile.com>
In-Reply-To: <20210825070752.18724-1-tangbin@cmss.chinamobile.com>
To:     Tang Bin <tangbin@cmss.chinamobile.com>
Cc:     mkl@pengutronix.de, wg@grandegger.com, davem@davemloft.net,
        kuba@kernel.org, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 25 Aug 2021 15:07:52 +0800 you wrote:
> In the function mpc5xxx_can_probe(), the variable 'data'
> has already been determined in the above code, so the
> BUG_ON() in this place is useless, remove it.
> 
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
> Changes to v1
>  - Fix the commit message for typo
> 
> [...]

Here is the summary with links:
  - [v2] can: mscan: mpc5xxx_can: Remove useless BUG_ON()
    https://git.kernel.org/netdev/net-next/c/cbe8cd7d83e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


