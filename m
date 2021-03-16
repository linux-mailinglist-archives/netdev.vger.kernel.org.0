Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 282D733E14B
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 23:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231156AbhCPWUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 18:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230391AbhCPWUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 18:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2575964EFC;
        Tue, 16 Mar 2021 22:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615933209;
        bh=T7udp+DC6TQ72coUJHBdzDnvR+vArL1j+aXLZOw5oQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qCj0gQ0kxNihrdW0qM/HsnjxJJi5TRCofo2L2tu+uIWaCYLwmWftM6Lq9Hv17DSq8
         GiGzI/3anVPOlw9LVyc+TsuRMALLwhp2T9w3neZljvu+NRVAwCciqTiR0TAeFvPK/3
         OlRsCji4jcF08ngkXN/U8NT9g/f9F14pcQWIHjmiCGMbcceqUwpUXNLMnapeLzTFkX
         VvEGPyyA1Gd2AGL7+m6LgzK9kFuuBEAw1Kh4NpDXqvmZgOs15dOicvALgfM7A7kTqD
         DGyyg0rXheqb5pOGsFn/k9YjP/UWMyrnqFwG8Lj/1tup7bfGqu6q6xIvtGyxgAWJko
         eifdbNtnpQEMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1513460A45;
        Tue, 16 Mar 2021 22:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 00/12] Documentation updates for switchdev and DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161593320908.2396.13181442419100610776.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 22:20:09 +0000
References: <20210316112419.1304230-1-olteanv@gmail.com>
In-Reply-To: <20210316112419.1304230-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jiri@resnulli.us, idosch@idosch.org,
        tobias@waldekranz.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Mar 2021 13:24:07 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Many changes were made to the code but of course the documentation was
> not kept up to date. This is an attempt to update some of the verbiage.
> 
> The documentation is still not complete, but it's time to make some more
> changes to the code first, before documenting the rest.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/12] Documentation: networking: update the graphical representation
    https://git.kernel.org/netdev/net-next/c/0f455371054b
  - [v2,net-next,02/12] Documentation: networking: dsa: rewrite chapter about tagging protocol
    https://git.kernel.org/netdev/net-next/c/7714ee152cd4
  - [v2,net-next,03/12] Documentation: networking: dsa: remove static port count from limitations
    https://git.kernel.org/netdev/net-next/c/f23f1404ebd3
  - [v2,net-next,04/12] Documentation: networking: dsa: remove references to switchdev prepare/commit
    https://git.kernel.org/netdev/net-next/c/f88439918589
  - [v2,net-next,05/12] Documentation: networking: dsa: remove TODO about porting more vendor drivers
    https://git.kernel.org/netdev/net-next/c/f4b5c53a03ea
  - [v2,net-next,06/12] Documentation: networking: dsa: document the port_bridge_flags method
    https://git.kernel.org/netdev/net-next/c/5a275f4c2989
  - [v2,net-next,07/12] Documentation: networking: dsa: mention integration with devlink
    https://git.kernel.org/netdev/net-next/c/8411abbcad8e
  - [v2,net-next,08/12] Documentation: networking: dsa: add paragraph for the LAG offload
    https://git.kernel.org/netdev/net-next/c/a9985444f2b5
  - [v2,net-next,09/12] Documentation: networking: dsa: add paragraph for the MRP offload
    https://git.kernel.org/netdev/net-next/c/f8f3c20af1ea
  - [v2,net-next,10/12] Documentation: networking: dsa: add paragraph for the HSR/PRP offload
    https://git.kernel.org/netdev/net-next/c/6e9530f4c042
  - [v2,net-next,11/12] Documentation: networking: switchdev: clarify device driver behavior
    https://git.kernel.org/netdev/net-next/c/0f22ad45f47c
  - [v2,net-next,12/12] Documentation: networking: switchdev: fix command for static FDB entries
    https://git.kernel.org/netdev/net-next/c/787a4109f468

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


