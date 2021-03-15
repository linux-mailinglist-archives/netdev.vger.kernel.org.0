Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC5833C6F8
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhCOTkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:40:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:41588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232362AbhCOTkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 884EB64F51;
        Mon, 15 Mar 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615837208;
        bh=1tQMRp4DJ4sH3iJ0QaPCl00RrDdhXenpD1XZIsz4Q7U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uwoGZKeBJLnMxf/XyLRvwiTYK7I+RXlMVgP7DlUYJFKmkHzAcWMbRopdtBgGSpQfd
         8RY/qO5kMYH1O45g3wgTEvIVuaQdF5m3YSYxTws/DGQZhOLIHIX2X7Kb2KouN13BAx
         Uo+ASToT10v6VS7hDiAJ/1YFv2w3LyKvv8zyF4tXNQ9aGNTl05P7pG01MMZvm+7WHy
         S8mzbJApzvUtZ9QbI7ACl0rY2enHKNIRo9bhavPiIkcgFAHH4YKWgBGHDp2Xtzo+04
         MH0pH4tWlQoOpWnRoBiIZnfTXk06RZVkAOqRw4LvkEWisr65C+0bx5c4uVIgO57wwh
         fdq2tscJSlX0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8398660A1A;
        Mon, 15 Mar 2021 19:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Offload bridge port flags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161583720853.23197.10913958468419979024.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Mar 2021 19:40:08 +0000
References: <20210314125208.17378-1-kurt@kmk-computers.de>
In-Reply-To: <20210314125208.17378-1-kurt@kmk-computers.de>
To:     Kurt Kanzenbach <kurt@kmk-computers.de>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 14 Mar 2021 13:52:08 +0100 you wrote:
> The switch implements unicast and multicast filtering per port.
> Add support for it. By default filtering is disabled.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
> ---
>  drivers/net/dsa/hirschmann/hellcreek.c | 129 ++++++++++++++++++++-----
>  1 file changed, 104 insertions(+), 25 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: hellcreek: Offload bridge port flags
    https://git.kernel.org/netdev/net-next/c/db7284a6ccc4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


