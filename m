Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7BF408A9A
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 14:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239781AbhIMMBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 08:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239414AbhIMMBW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 08:01:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B155360F9B;
        Mon, 13 Sep 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631534406;
        bh=MR6d5hciYFoDzGmjgFuB4STOwfZWwsc8CkeHpBD0ljs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W6lmTJ8mkejWFcHDfBV4iTTx0jBNj0fELcJpVmyZVH+Zp9qewGNrspYZhq2/Ncq3/
         AnsUzEVfSRxfBuUjzqoj10NlGSSKv5iKfM8t8FFRTkdVv3RAg3sjie5JYUlAM/jL4e
         CszBDiM1oZFqRPBatU+wiN/+SdM0LYwl/mUOSVnfek2A+PjGHeGU7obsnjksFS6h5t
         HH7XEJ5qMEWsJ9T7gwIbTIbySIU+JFRvc0ptO+lCA2VXGDXYC8Zpy5xu4GTFkQb4Yp
         rGADRBxldTQuE6mxoporOZXyymZPtQZJ2fe5CglGgJlY51RgiJodaqUqL7WpB1PMMT
         boyXoaO5OFpLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A219E60A6F;
        Mon, 13 Sep 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] qed: Improve the stack space of filter_config()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163153440665.4538.18206948099975645142.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Sep 2021 12:00:06 +0000
References: <20210913075024.17571-1-smalin@marvell.com>
In-Reply-To: <20210913075024.17571-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        naresh.kamboju@linaro.org, aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 13 Sep 2021 10:50:24 +0300 you wrote:
> As it was reported and discussed in: https://lore.kernel.org/lkml/CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com/
> This patch improves the stack space of qede_config_rx_mode() by
> splitting filter_config() to 3 functions and removing the
> union qed_filter_type_params.
> 
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next] qed: Improve the stack space of filter_config()
    https://git.kernel.org/netdev/net-next/c/f55e36d5ab76

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


