Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E36340AF66
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 15:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233690AbhINNmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 09:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233748AbhINNlZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 09:41:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 91D8360FD7;
        Tue, 14 Sep 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631626808;
        bh=r+BheNAAeuDGbMAMWTyJfHRJ2J1W3BnBWAD2phBTvio=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=srKENhTHY5U9hqSBjfr31jpzUNlhQM9jSEWEyooydDJl6e86UhpxZBTQ/oHfpIR6/
         zEPOvFU9jl8bpaOQRQ7zWQeSJWvdYhHo0rzFOtu0kWmsRKLXlp4Wh6EICFyUh049AY
         XN3TQ7Qg98LwkP0P5erdMMWl9OiTmf4PLTKMXAHo3A+9kbw/U+8E9ZKtaedcMAUiCo
         AaAKF/jn1mUC8MWS4SpJ1xlvjQ/B7+nwiD7jU5qT2//IXzPcAe6SIPfjqWCaPMWLep
         rEgWQcigz50fraXKS9FYRlmNdythvy5mmP1Be2jaxYEUWbBqUfD/nhRDzhz8PBi+Kv
         iKREfAjyCyqIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 85BD860A9C;
        Tue, 14 Sep 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: phy: at803x: add support for qca 8327
 internal phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163162680854.2816.673162311961277664.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Sep 2021 13:40:08 +0000
References: <20210914123345.6321-1-ansuelsmth@gmail.com>
In-Reply-To: <20210914123345.6321-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rosenp@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 14 Sep 2021 14:33:45 +0200 you wrote:
> Add support for qca8327 internal phy needed for correct init of the
> switch port. It does use the same qca8337 function and reg just with a
> different id.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Tested-by: Rosen Penev <rosenp@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: phy: at803x: add support for qca 8327 internal phy
    https://git.kernel.org/netdev/net-next/c/0ccf85111824

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


