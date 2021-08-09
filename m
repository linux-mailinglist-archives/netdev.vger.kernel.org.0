Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505023E41EF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234130AbhHIJA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:55574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233940AbhHIJAZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:00:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B2EC16103B;
        Mon,  9 Aug 2021 09:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628499605;
        bh=KKv7G4fDgLDFNaIKOOoD6/9TrW9VonLPRZmzTKuV2tA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=du8rIWIev09do26u7edQu0Tm40V0vENlNz9mvUaGSQaDYQR9e6mSNaOrKgIzWusPG
         sr0FUaq43nw9a3X/x1Au+j3jgye8Kvg2obGqEQ6fK8nyaYcLgnWhPl1mjmbcc7S2K7
         tl6gpDODDOaZj6WIlO4SJqazBFJhWBrf+th3makJg+sX8qQ32FEY1JG+QNDrZNWyRD
         kDlH6s1uGsaC40Zn11ggv0//XMNEJM5H2QAPP9XoFgEpeJBRJd1WwlyxQlemDun7cn
         8ETh0qwfRl5j9UJjWL61b+MZZLHcNX5Uql9PyCYVYtq/pIxnKmFhCZLHUIHxx8Geve
         qt7zITBaIRH8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A702760A14;
        Mon,  9 Aug 2021 09:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] DSA fast ageing fixes/improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162849960567.18255.3662360381950702204.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 09:00:05 +0000
References: <20210808225649.62195-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210808225649.62195-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon,  9 Aug 2021 01:56:47 +0300 you wrote:
> These are 2 small improvements brought to the DSA fast ageing changes
> merged earlier today.
> 
> Patch 1 restores the behavior for DSA drivers that don't implement the
> .port_bridge_flags function (I don't think there is any breakage due
> to the new behavior, but just to be sure). This came as a result of
> Andrew's review.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: dsa: still fast-age ports joining a bridge if they can't configure learning
    https://git.kernel.org/netdev/net-next/c/a4ffe09fc2d7
  - [net-next,2/2] net: dsa: avoid fast ageing twice when port leaves a bridge
    https://git.kernel.org/netdev/net-next/c/bee7c577e6d7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


