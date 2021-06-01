Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1576397C71
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbhFAWcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235025AbhFAWbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA72E613D0;
        Tue,  1 Jun 2021 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622586604;
        bh=2rj5jU+vp+4LP/aYOfB4WlwrY2qxKktHVYHjCSZEuHA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hvSU90Zl9Un4jdScYE0HcunmJu45QWVeo7hlM04HWygmwm0UkJFE366I6+2HPfbjj
         2SrqAVsh+ft0jQi2ttAxudzA5ccatGT5rQjYspJj7t5Zvd+bfJS71j7zZTOSOD+bgU
         5/nR3BAc0pwR2qIyrPmdywpy95TRqdm1Jw1Es3hxYPquxYNBa2evrTPyB418QZEElC
         v5DwalEBKvHiY7FUqAh9AQfqUvTRaWY+0+E/5rru2aOjkRinUyiEekAaOewB7stSNj
         Em+RYZva6M+VJ8GsDjQkasD2P7CmBIVgm6G3pf5lZ7o02c/5BzanSQBgsb5CKqo+D/
         r8ehNZlDCl8HQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A58C0609F8;
        Tue,  1 Jun 2021 22:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8152: support pauseparam of ethtool_ops
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258660467.12532.6997577324265829721.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:30:04 +0000
References: <1394712342-15778-366-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-366-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 15:37:12 +0800 you wrote:
> Support get_pauseparam and set_pauseparam of ethtool_ops.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 75 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)

Here is the summary with links:
  - [net-next] r8152: support pauseparam of ethtool_ops
    https://git.kernel.org/netdev/net-next/c/163d01c56e80

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


