Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026474A85D4
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243066AbiBCOKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351019AbiBCOKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 394C8C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 06:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05B85B8342E
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 14:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C80FEC340E8;
        Thu,  3 Feb 2022 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643897410;
        bh=IjQbB4QnD4eq/saEAJcKFLks/TfV/ONK7CcsYKgpFBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LOxfOpcrSUIP0CD3/fvi1GfXkYcR5foe7QCnIKMBEdOMcDkjmDu/eLEm80pKSugN2
         sWbI2Xi3IGb7VO5wj06+na1WJhnSl9k7QzaMGlQYH/yxVOUgUTJwzLI9D9SRjpeJOs
         /sOwJLMEocViYAQ2LR/xrwyz5EK3nm8EBulLZCbTcOAiaDhweBAw0nTag3nt5GOedw
         Ijy0sBv0gEgb3DhIqHtnoYXLPa7WgAEFA5GnzDNKpDeAJYgyyl67NVcF0iaFY+e19P
         a5zK71Y0N2vrh4ogOCtaMhLm5silucFdH0FMCDVCaIOYqUHftSXkoVzLxJwb5C02DA
         btePF+egtI28w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2452E6BB30;
        Thu,  3 Feb 2022 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/5] net: dsa: mv88e6xxx: Improve standalone port
 isolation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164389741072.16432.10654180357158986861.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 14:10:10 +0000
References: <20220203101657.990241-1-tobias@waldekranz.com>
In-Reply-To: <20220203101657.990241-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  3 Feb 2022 11:16:52 +0100 you wrote:
> The ideal isolation between standalone ports satisfies two properties:
> 1. Packets from one standalone port must not be forwarded to any other
>    port.
> 2. Packets from a standalone port must be sent to the CPU port.
> 
> mv88e6xxx solves (1) by isolating standalone ports using the PVT. Up
> to this point though, (2) has not guaranteed; as the ATU is still
> consulted, there is a chance that incoming packets never reach the CPU
> if its DA has previously been used as the SA of an earlier packet (see
> 1/5 for more details). This is typically not a problem, except for one
> very useful setup in which switch ports are looped in order to run the
> bridge kselftests in tools/testing/selftests/net/forwarding. This
> series attempts to solve (2).
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/5] net: dsa: mv88e6xxx: Improve isolation of standalone ports
    https://git.kernel.org/netdev/net-next/c/7af4a361a62f
  - [v2,net-next,2/5] net: dsa: mv88e6xxx: Support policy entries in the VTU
    https://git.kernel.org/netdev/net-next/c/bb03b280e0c3
  - [v2,net-next,3/5] net: dsa: mv88e6xxx: Enable port policy support on 6097
    https://git.kernel.org/netdev/net-next/c/585d42bb57bb
  - [v2,net-next,4/5] net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
    https://git.kernel.org/netdev/net-next/c/d352b20f4174
  - [v2,net-next,5/5] selftests: net: bridge: Parameterize ageing timeout
    https://git.kernel.org/netdev/net-next/c/081197591769

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


