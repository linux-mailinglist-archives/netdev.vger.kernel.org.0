Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C2A3A7021
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 22:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234831AbhFNUWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 16:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:35262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234356AbhFNUWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 16:22:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C1B6613B1;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623702006;
        bh=5BkbwA+kVGe4v95t8EiwJewdACuuAGeX+tbtyQJbY3o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jcKTdA/Mu1a9MtxEryElRHcWsg8FpZLJeSPyF9BQVae/kvKJlPXqs4QSEFenSr+fE
         iDR6pus3uaksmCgKCnBJ2Vpufa1VqvZMloPepELq5TFWs9irUiLAI+/vvROCheMSxc
         QJJf8a5QxJsimoz9WOvFJs3OWwbDoHGut1bV7gQv7OP2ANyJS8BBZhtpOggUfpx6BC
         00IQQ74yc4nh9lGfnnLZHY3O2PVnd3JF2kvt7ISVwvOSGHLdwvOqU1FqQ3bvbJ5DRf
         /ENLAyP8Wl3ZptxQIC/TSTyPxy6GgGaysD+iBaIzicmumPkbrcHlbD2AAyQYaahjxK
         zs5Xy0LiD7ntw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 53D8E60C29;
        Mon, 14 Jun 2021 20:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: sja1105: constify the sja1105_regs
 structures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162370200633.25455.14308040955406501112.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Jun 2021 20:20:06 +0000
References: <20210614135050.500826-1-olteanv@gmail.com>
In-Reply-To: <20210614135050.500826-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 14 Jun 2021 16:50:50 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The struct sja1105_regs tables are not modified during the runtime of
> the driver, so they can be made constant. In fact, struct sja1105_info
> already holds a const pointer to these.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: sja1105: constify the sja1105_regs structures
    https://git.kernel.org/netdev/net-next/c/3009e8aa85af

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


