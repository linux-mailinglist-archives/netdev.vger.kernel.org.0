Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B304C417570
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 15:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345412AbhIXNXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 09:23:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346451AbhIXNVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 09:21:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D21C961107;
        Fri, 24 Sep 2021 13:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632489606;
        bh=OJiGffHgoVuTd+AUlYyCxgMQfbVbKgqIcfwchnuPCcE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UywI/67MN8ruA8YHxh5YQ8Qd7XdXqkQbb2PLe69tJdrUYWk+sGxu45Kek16CBihei
         XX7PWq1o+WKokWvzyCef/LfUrFNfT1U1lKhZpCAcG1EATk7f7ShEVv437IjNRXg7qk
         5K+goOKxuUOqf2cCvldhF3iPO0/I/1eGKZQp6Mhjvnm+K78ZyPSUTZaaaNsubLkERz
         ivMhhjx9vZ/ydRvwhK+EtC26mtnnRFNMFqPdWnUxvf/LlruSQ/iKOOGZI6jkzatW3D
         FQ1/LHqo0P9x7E2xYi1W6FV7ZbL+W71y3q85jl/vOHbwhmInhmqPfbRENwsZAJyx26
         pNSmtpmSvPIgA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C54C160973;
        Fri, 24 Sep 2021 13:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] smsc95xx: fix stalled rx after link change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163248960680.28971.7197308851510889411.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 13:20:06 +0000
References: <20210923220016.18221-1-aaro.koskinen@iki.fi>
In-Reply-To: <20210923220016.18221-1-aaro.koskinen@iki.fi>
To:     Aaro Koskinen <aaro.koskinen@iki.fi>
Cc:     steve.glendinning@shawell.net, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, andre.edich@microchip.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 24 Sep 2021 01:00:16 +0300 you wrote:
> After commit 05b35e7eb9a1 ("smsc95xx: add phylib support"), link changes
> are no longer propagated to usbnet. As a result, rx URB allocation won't
> happen until there is a packet sent out first (this might never happen,
> e.g. running just ssh server with a static IP). Fix by triggering usbnet
> EVENT_LINK_CHANGE.
> 
> Fixes: 05b35e7eb9a1 ("smsc95xx: add phylib support")
> Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> 
> [...]

Here is the summary with links:
  - smsc95xx: fix stalled rx after link change
    https://git.kernel.org/netdev/net/c/5ab8a447bcfe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


