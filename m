Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4B330924B
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 06:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233861AbhA3FnY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 00:43:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233867AbhA3Fkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 00:40:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F2EC664E0A;
        Sat, 30 Jan 2021 05:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611985209;
        bh=6F7FIXimG4zmA35PE+D7+qaBf3EwhHzCSW/aRnJv4z0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SotShaENMRKqmkGAwq2Wcf2EMiFbXLWqhwctYGho/cxl2jojoMeWoB4kZzeEQNjBJ
         g2OTfsXSQKyi7BOvUJrW54zOcbOogEGOb3yTH1LpPL38pGKivXleajt0v8Z4Nw3LxE
         tkO3XYPulIws8j5cMc025OY2tVkplad+7/yoUrt1dOlumvAZnR2Cfjt9M/waohYDDi
         SzWzOO9EXLIMTkq8FcUo6tT5/sHmWCXhQCs/Lzk0hL+zrRVMn/fS7dpq9/jlVaoK8b
         BwiqyYA/coC1MLM25UMKLTf6ePJFOh4rsmu4fJH834pGdxSST/ILLfTwz1B1j0QXG8
         OPw5UPKHfRrqQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E2E6060984;
        Sat, 30 Jan 2021 05:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v8 net-next 00/11] tag_8021q for Ocelot switches
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161198520892.32450.6766671652860964260.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 05:40:08 +0000
References: <20210129010009.3959398-1-olteanv@gmail.com>
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        vladimir.oltean@nxp.com, UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 29 Jan 2021 02:59:58 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Changes in v8:
> - Make tagging driver module reference counting work per DSA switch tree
>   instead of per CPU port, to be compatible with the tag protocol changing
>   through sysfs.
> - Refactor ocelot_apply_bridge_fwd_mask and call it immediately after
>   the is_dsa_8021q_cpu variable changes, i.e. in
>   felix_8021q_cpu_port_init and felix_8021q_cpu_port_deinit.
> - Take reference on tagging driver module in dsa_find_tagger_by_name.
> - Replaced DSA_NOTIFIER_TAG_PROTO_SET and DSA_NOTIFIER_TAG_PROTO_DEL
>   with a single DSA_NOTIFIER_TAG_PROTO.
> - Combined .set_tag_protocol and .del_tag_protocol into a single
>   .change_tag_protocol, and we're no longer calling those 2 functions at
>   probe and unbind time.
> - Adapted Felix to .change_tag_protocol. Kept felix_set_tag_protocol and
>   felix_del_tag_protocol, but now calling them privately from
>   felix_setup and felix_teardown.
> - Used -EPROTONOSUPPORT instead of -EOPNOTSUPP as return code.
> - Dropped some review tags due to amount of changes.
> 
> [...]

Here is the summary with links:
  - [v8,net-next,01/11] net: dsa: tag_8021q: add helpers to deduce whether a VLAN ID is RX or TX VLAN
    https://git.kernel.org/netdev/net-next/c/9c7caf280684
  - [v8,net-next,02/11] net: mscc: ocelot: export VCAP structures to include/soc/mscc
    https://git.kernel.org/netdev/net-next/c/0e9bb4e9d93f
  - [v8,net-next,03/11] net: mscc: ocelot: store a namespaced VCAP filter ID
    https://git.kernel.org/netdev/net-next/c/50c6cc5b9283
  - [v8,net-next,04/11] net: mscc: ocelot: reapply bridge forwarding mask on bonding join/leave
    https://git.kernel.org/netdev/net-next/c/9b521250bff4
  - [v8,net-next,05/11] net: mscc: ocelot: don't use NPI tag prefix for the CPU port module
    https://git.kernel.org/netdev/net-next/c/cacea62fcdda
  - [v8,net-next,06/11] net: dsa: document the existing switch tree notifiers and add a new one
    https://git.kernel.org/netdev/net-next/c/886f8e26f539
  - [v8,net-next,07/11] net: dsa: keep a copy of the tagging protocol in the DSA switch tree
    https://git.kernel.org/netdev/net-next/c/357f203bb3b5
  - [v8,net-next,08/11] net: dsa: allow changing the tag protocol via the "tagging" device attribute
    https://git.kernel.org/netdev/net-next/c/53da0ebaad10
  - [v8,net-next,09/11] net: dsa: felix: convert to the new .change_tag_protocol DSA API
    https://git.kernel.org/netdev/net-next/c/adb3dccf090b
  - [v8,net-next,10/11] net: dsa: add a second tagger for Ocelot switches based on tag_8021q
    https://git.kernel.org/netdev/net-next/c/7c83a7c539ab
  - [v8,net-next,11/11] net: dsa: felix: perform switch setup for tag_8021q
    https://git.kernel.org/netdev/net-next/c/e21268efbe26

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


