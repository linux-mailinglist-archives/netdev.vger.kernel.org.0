Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC7722B31BC
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 02:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKOBKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 20:10:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:43620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbgKOBKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 20:10:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605402605;
        bh=EzXCCOKx/K64UV8aLxlUnZdkiFg1Af/VJFoKOrThN5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hROtEhhRODBT9yWACvFbZ09+VTAWBr4dfP+7EIDFvwDqAgMN8kSJSQwOkT4kPXwAB
         KY19QQ9zLk1eB4529YOdD1/fiBYqhF7I+U2FX8sO6VRWgW1P1rGr4IpsAiqLE6v+Vw
         D88S9ywK32n7AD/kHhZA8+bE1XkPxXczg+B3mkqE=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: openvswitch: use core API to update/provide stats
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160540260552.16667.13161218956670847724.git-patchwork-notify@kernel.org>
Date:   Sun, 15 Nov 2020 01:10:05 +0000
References: <20201113215336.145998-1-lev@openvpn.net>
In-Reply-To: <20201113215336.145998-1-lev@openvpn.net>
To:     Lev Stipakov <lstipakov@gmail.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com, lev@openvpn.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Nov 2020 23:53:36 +0200 you wrote:
> Commit d3fd65484c781 ("net: core: add dev_sw_netstats_tx_add") has added
> function "dev_sw_netstats_tx_add()" to update net device per-cpu TX
> stats.
> 
> Use this function instead of own code.
> 
> While on it, remove internal_get_stats() and replace it
> with dev_get_tstats64().
> 
> [...]

Here is the summary with links:
  - [v3] net: openvswitch: use core API to update/provide stats
    https://git.kernel.org/netdev/net-next/c/865e6ae02dd7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


