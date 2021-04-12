Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4A735B7A9
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 02:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235933AbhDLAKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 20:10:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235746AbhDLAKc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 20:10:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1CF9861206;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618186211;
        bh=pHMRg3IxL935Ply/W4Z/4Czg0CC3Klo++Y3nPbfC3OU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PjFNKxdirQlI0FjWuEZFE1GiwozWaSro3e5XwSdjMD028gnae19C3UU5pzxJ+MRBT
         xxa1LjqJOh04vJmg4XLdXHNDak4p2ypuIxJE9ke+mc2d2he3eRpHnBdzGOO+Ki8TsX
         2yT1eLfFPGTHoocd9gRJeadCqKwjcZKMKWhILJboYeuSvf/XJKY1s6oQhrVmWrzers
         HEebKZ7XDmp5whg/mB7eoVGplyA0mkK7hMOc5gU4XY/+qv7jUvavsBzvRZqAV13saZ
         FQiZOxkKC52MDG1lSNy3W1dR9PVFCTOhwVGXINb99ayrETExn7bZPKxSDVOjvuxdcg
         N1K/0QBCMLGDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 12E9860A2C;
        Mon, 12 Apr 2021 00:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] veth: allow GRO even without XDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161818621107.2274.8996043815250457698.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 00:10:11 +0000
References: <cover.1617965243.git.pabeni@redhat.com>
In-Reply-To: <cover.1617965243.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        toshiaki.makita1@gmail.com, lorenzo@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri,  9 Apr 2021 13:04:36 +0200 you wrote:
> This series allows the user-space to enable GRO/NAPI on a veth
> device even without attaching an XDP program.
> 
> It does not change the default veth behavior (no NAPI, no GRO),
> except that the GRO feature bit on top of this series will be
> effectively off by default on veth devices. Note that currently
> the GRO bit is on by default, but GRO never takes place in
> absence of XDP.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] veth: use skb_orphan_partial instead of skb_orphan
    https://git.kernel.org/netdev/net-next/c/c75fb320d482
  - [net-next,2/4] veth: allow enabling NAPI even without XDP
    https://git.kernel.org/netdev/net-next/c/d3256efd8e8b
  - [net-next,3/4] veth: refine napi usage
    https://git.kernel.org/netdev/net-next/c/47e550e0105b
  - [net-next,4/4] self-tests: add veth tests
    https://git.kernel.org/netdev/net-next/c/1c3cadbe0242

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


