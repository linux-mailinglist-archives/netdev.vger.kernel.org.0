Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C5E2F2444
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 01:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405443AbhALAZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:35284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404159AbhAKXks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 18:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F0BD822D6D;
        Mon, 11 Jan 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610408408;
        bh=mOhymoQvBAb5qRim9J45IL+qy8FNGc5x4Qcn8IGXtto=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MFOaVvmYrLj+5tB+gQi2UZUZxyXlArlmuGsUyH9UXFnmNjICs83yx0AzI81sW4BiC
         BseG2GhyFMxerISq7ID+78TXfCNeSEIvfhz+vtGx3BKaOvtsfpIh6fdYks9zD3c6rw
         4uRbqbD22AwYesgk1pnsQXZyXYi/6CK8aO/RbStL+8p4J/qsV5lTxlBACGdmNddNcn
         fhy0/2fq/q2MAnHJ/84wXhpvwj+cISKsQInz+UqUFyMVx87u39kg2PAyUOQQTWYX66
         NTSBJHQSbYr2D0wybO+7DvwqbYF4GsScsGUPvU24+yFaVr/l2pHY4W2YhKJDxgO8t2
         fFo6kIA39+SgQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id EC9CA6025A;
        Mon, 11 Jan 2021 23:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] r8169: deprecate support for RTL_GIGA_MAC_VER_27
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161040840796.14828.16103953195856421926.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jan 2021 23:40:07 +0000
References: <ca98f018-a0e1-8762-e95c-f0ad773a0271@gmail.com>
In-Reply-To: <ca98f018-a0e1-8762-e95c-f0ad773a0271@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 10 Jan 2021 13:17:52 +0100 you wrote:
> RTL8168dp is ancient anyway, and I haven't seen any trace of its early
> version 27 yet. This chip versions needs quite some special handling,
> therefore it would facilitate driver maintenance if support for it
> could be dropped. For now just disable detection of this chip version.
> If nobody complains we can remove support for it in the near future.
> 
> v2:
> - extend unknown chip version error message
> 
> [...]

Here is the summary with links:
  - [v2,net-next] r8169: deprecate support for RTL_GIGA_MAC_VER_27
    https://git.kernel.org/netdev/net-next/c/beb401ec5006

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


