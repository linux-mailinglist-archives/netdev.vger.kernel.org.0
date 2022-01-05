Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87F64485580
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:10:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236671AbiAEPKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:10:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbiAEPKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 10:10:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B999EC061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 07:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 62B956179D
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 15:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEF29C36AF6;
        Wed,  5 Jan 2022 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641395413;
        bh=pWIexLy76v2Ra6YYcfv+bDu4Gmk4aQWfre2j997NPW0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rnb5piFuVInE8ZA5Fv2FfPN+BK3ExHa5AkI7Kov2Rg6tegCEFAR6ewUsXfG5ghmjs
         hpyWZGmj5Cq21hp6aR2prgPPXybzlhcpxNgwBVw+3sSlCZban9Q+IcjV90hCe6voq1
         ftW6trpoLBk+YJobqn86E02e8+mYeuXbUMOU82GsI7HvnrYnqLb7ekNQ9s8TyPExD2
         6tNEpp7Gme+gwZJ4GC/j+vjUWbUpcpf6KR700042GBdlLvriPP+tXzYrChwbgMjsHw
         N9yLPxXa/oVcZKufrKvUtmSARdyue9ktUNejRkdVHnuvipB2ULidJbKAIKQYsGqSuP
         VuMXwM+GHhjRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9C48AF7940C;
        Wed,  5 Jan 2022 15:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: pci: Avoid flow control for EMAD packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164139541363.14483.4753955495210695504.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 15:10:13 +0000
References: <20220105102227.733612-1-idosch@nvidia.com>
In-Reply-To: <20220105102227.733612-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  5 Jan 2022 12:22:27 +0200 you wrote:
> From: Danielle Ratson <danieller@nvidia.com>
> 
> Locally generated packets ingress the device through its CPU port. When
> the CPU port is congested and there are not enough credits in its
> headroom buffer, packets can be dropped.
> 
> While this might be acceptable for data packets that traverse the
> network, configuration packets exchanged between the host and the device
> (EMADs) should not be subjected to this flow control.
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: pci: Avoid flow control for EMAD packets
    https://git.kernel.org/netdev/net-next/c/d43e4271747a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


