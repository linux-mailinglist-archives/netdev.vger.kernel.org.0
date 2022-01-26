Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1779349C295
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiAZEUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:20:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:33736 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiAZEUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A28F617BD
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 04:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF30AC340E9;
        Wed, 26 Jan 2022 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643170809;
        bh=q6elgHD0sJI3YMWfdPeGGr/WMUDFymEtM1aqSvTkPu8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Eu7dynXeVhrcOQBnb2F8RNCDzdb3F4CE1+1hXJqXYaDfUpfiiLCtXVVajguToaM/+
         1hdY7g+zI043r7xofRqZDR1HrVVmr7FgST2jd41YPqz4wk7pQg5ZQpx9fFnO97Dsc3
         3DBSmYYcthgZyzMZmbHFFqRocjeoAys8vfjeuVsOUYkDqLo3dO/eQarqraMyZmzcWz
         SABi6nrJXTQFaeOjvggbQ26N+OLSYQsdLUIarGXfKiWGQXS43l2flN/2SlRxXfaL4V
         dEbfIGPWsCGdph9KxV3ewHxGRtQB8DG5Pwb+CFtypcsbT46Q3YC9N2YyC/heTK/Lpe
         QS6mNbomCG5vQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8B2FE5D084;
        Wed, 26 Jan 2022 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sch_htb: Fail on unsupported parameters when offload is
 requested
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164317080968.16314.15073917636134293917.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 04:20:09 +0000
References: <20220125100654.424570-1-maximmi@nvidia.com>
In-Reply-To: <20220125100654.424570-1-maximmi@nvidia.com>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 25 Jan 2022 12:06:54 +0200 you wrote:
> The current implementation of HTB offload doesn't support some
> parameters. Instead of ignoring them, actively return the EINVAL error
> when they are set to non-defaults.
> 
> As this patch goes to stable, the driver API is not changed here. If
> future drivers support more offload parameters, the checks can be moved
> to the driver side.
> 
> [...]

Here is the summary with links:
  - [net] sch_htb: Fail on unsupported parameters when offload is requested
    https://git.kernel.org/netdev/net/c/429c3be8a5e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


