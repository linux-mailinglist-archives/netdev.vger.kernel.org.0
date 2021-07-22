Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35203D1F49
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 09:50:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhGVHJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:09:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230144AbhGVHJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 03:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B47FA6128C;
        Thu, 22 Jul 2021 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626940204;
        bh=0Pch2NHes7PJ3oRYQUDkZn5NQLnIjBv9eKYjA+g7WnA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B/d5HmGWitg1uYfaNvwPWOq7xu4bSEHQsUxE4F6ECLcNrqF+GHBTwdF8xQAWul0K8
         P8etUTfMqMPP3JtTiVAhwq/b4QSmtKmiIRDNWyGtyYJcowsboloE4lHzcpKL+mV0El
         H9P1XqgYdf+jpJ+rWW3XMj98nofjbdy2jywbkgg8cghAWxLmbEvYWWSQksAJa59UC+
         wYuH3hOYIDxy9BV6IvS6FkZR489NrnjeJgWgb+P9L+kpq/nEuQanSfBRkojBMZ9gQu
         TVS0mcAjZkC4KkhCSy15mNikOgwedGz4+gMR0Aeeu8Eiw+3+dTEKhoQNACQwN6u2Rt
         YJtBO9DEop+jg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADE7860ACA;
        Thu, 22 Jul 2021 07:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: switchdev: fix FDB entries towards foreign
 ports not getting propagated to us
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162694020470.16794.15498523906664334643.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 07:50:04 +0000
References: <20210721230555.2207542-1-vladimir.oltean@nxp.com>
In-Reply-To: <20210721230555.2207542-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        jiri@resnulli.us, idosch@idosch.org, tobias@waldekranz.com,
        roopa@nvidia.com, nikolay@nvidia.com, stephen@networkplumber.org,
        bridge@lists.linux-foundation.org, dqfext@gmail.com,
        ericwouds@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 22 Jul 2021 02:05:55 +0300 you wrote:
> The newly introduced switchdev_handle_fdb_{add,del}_to_device helpers
> solved a problem but introduced another one. They have a severe design
> bug: they do not propagate FDB events on foreign interfaces to us, i.e.
> this use case:
> 
>          br0
>         /   \
>        /     \
>       /       \
>      /         \
>    swp0       eno0
> (switchdev)  (foreign)
> 
> [...]

Here is the summary with links:
  - [net-next] net: switchdev: fix FDB entries towards foreign ports not getting propagated to us
    https://git.kernel.org/netdev/net-next/c/2b0a5688493a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


