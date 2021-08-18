Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD873F00C1
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 11:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhHRJlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 05:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231910AbhHRJkm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 05:40:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD94061029;
        Wed, 18 Aug 2021 09:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629279607;
        bh=ypQpzTrDSu7JuOhVXYNDX4QxbJsogPc3pzWHIhOOlQc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nYwNCrZbCnQWsnYXbSig5Y0tX7bW0cwWiviJReKjaGSsAIHXXSoWF5yRDSO9s/p1h
         kwXucHXN8dzpcQikMY6biJ7KOD0mVzJtqkO8w40La2X25iFAupjHfeiAM/ikGD49KG
         OB8LF/J8BdI/A6tdJCo5bG6Yav5IdK/GaFR9OIQgojWy2o0/IJr9VAH7sWdvneUOYx
         CbuvqPQZuRcGukC4QYXwO7mZpOz18JZWenf1q+kC22sD1p4SJY49K8wwG4cUBgMXqL
         FMzi/8ToyGd62bLW7/P3bAmvRVZ5zmGGAsmEdkn3YGhjnjdzCQGF6jcHhCRGBElvjf
         Xjn/jb4zxzZ+A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D3B0660A2E;
        Wed, 18 Aug 2021 09:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dsa: tag_sja1105: be dsa_loop-safe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162927960786.17257.6062937333117961457.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 09:40:07 +0000
References: <20210817145847.3557963-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210817145847.3557963-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 17:58:47 +0300 you wrote:
> Add support for tag_sja1105 running on non-sja1105 DSA ports, by making
> sure that every time we dereference dp->priv, we check the switch's
> dsa_switch_ops (otherwise we access a struct sja1105_port structure that
> is in fact something else).
> 
> This adds an unconditional build-time dependency between sja1105 being
> built as module => tag_sja1105 must also be built as module. This was
> there only for PTP before.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dsa: tag_sja1105: be dsa_loop-safe
    https://git.kernel.org/netdev/net-next/c/994d2cbb08ca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


