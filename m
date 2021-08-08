Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82ACB3E39EB
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 13:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhHHLKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 07:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229473AbhHHLKY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 07:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B30316101E;
        Sun,  8 Aug 2021 11:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628421005;
        bh=0f56xpiVXt+VAbohAJHX35HCvdKAVptLGU8kId2ZMIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MDaMaCrnn4lcC+4pBUQeAPV/RBglU8SIlFj3EGX6b6WZR/UY6uiWf+6WkaFqpuUn2
         xE6deNdj5+83MP2HGRiZv9ytVcxWiTZ0/iM8jN5GvGr4Xa8GhUON8VhwHSEN2Y8Qcr
         3krfPqiBsonQ/nfeZIvPGqDKOUNnJ4yC+IqZ0hO+BPpSWChPzgF4N0yt/V4mx/rIDf
         qXIaUfD+UVt0Qwy4kpHvu36XivtUvvdCukg1hHueAi8Co4vK0bhW7vsg4+FaIl97AL
         BdEioljKBZw1cTr6MDPQ0cJVneVusihRSui8cW3NUBEjWcOhzmVa6ktOLQLgdoeuki
         KJXp0pf0p7Prg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A52DB60985;
        Sun,  8 Aug 2021 11:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: micrel: Fix link detection on ksz87xx switch"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842100567.27537.2856135053086059450.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 11:10:05 +0000
References: <20210807000618.GB4898@cephalopod>
In-Reply-To: <20210807000618.GB4898@cephalopod>
To:     Ben Hutchings <ben.hutchings@mind.be>
Cc:     steveb@workware.net.au, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 7 Aug 2021 02:06:18 +0200 you wrote:
> Commit a5e63c7d38d5 "net: phy: micrel: Fix detection of ksz87xx
> switch" broke link detection on the external ports of the KSZ8795.
> 
> The previously unused phy_driver structure for these devices specifies
> config_aneg and read_status functions that appear to be designed for a
> fixed link and do not work with the embedded PHYs in the KSZ8795.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: micrel: Fix link detection on ksz87xx switch"
    https://git.kernel.org/netdev/net/c/2383cb9497d1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


