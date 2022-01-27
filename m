Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EB949E400
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241923AbiA0OA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241049AbiA0OAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B75C06173B
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 06:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25D59B8218D
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 14:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD64AC340EE;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643292010;
        bh=7Rg2hcargJvycbxELEPcbq6dAdY66WnNNVKqyGeP5T4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bGOjUc/dr09OPPW6Yf7MVJQEgHiwIe/xKSIZZi9FQI7/VOJ664HPchkH9aoJj1nqj
         GmREqth6mdlcZkZWb4vuu6tdyFgxR1PxpLw+hxdJjyBa8he0LfnlYnZjdcTRjHD0Vy
         S9ov5oZ3HrxyXtKs7buM4JqgLnwsy7ndjOBhM3zEJm4nUL+8Pj82J96Jh1Cf3a+d/Z
         RFLUBuojikT4Dfkc4mKRhJWrplYhB3TkV/q4RVDo7ZfVpiHDd129BpKpIGpMWxf8BG
         NoRqBoy++5j4JEUU2WrFV+d87bpbf0jmySxXCOcuHlaJizR2EZal/LdA00JB+8Wbu+
         4hGFuKhF5dnFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8385E5D08C;
        Thu, 27 Jan 2022 14:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] MAINTAINERS: add missing IPv4/IPv6 header paths
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329201081.13469.15227885151083535127.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 14:00:10 +0000
References: <20220126225535.3328169-1-kuba@kernel.org>
In-Reply-To: <20220126225535.3328169-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 26 Jan 2022 14:55:35 -0800 you wrote:
> Add missing headers to the IP entry.
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: include/net/fib* and include/net/route.h as well
> 
> [...]

Here is the summary with links:
  - [net,v2] MAINTAINERS: add missing IPv4/IPv6 header paths
    https://git.kernel.org/netdev/net/c/966f435add48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


