Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDE049B94F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586294AbiAYQvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:51:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59724 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586023AbiAYQqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:46:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9643EB8187C;
        Tue, 25 Jan 2022 16:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40CD2C340E0;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643129174;
        bh=a+RiddEH06Ow3Nadq6UQ91Jd91WUYLVCAJtqpiA/IxU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e5d4AbA/jauwAAxQhOOp3ffiuYRgTLmGxWafdbGveTcFTvMXVxNt8/jmv74vLohYD
         UKK/nCP77fL5QHMf4Q2X5Z8JYKlWWyEBgae/nLz0nf0eCr3nkuqs1+pqH8WRqKCpn8
         7xNu7LcAo6guEUD+1y4Id0ex8MZbkAaPPidfUMfCedl9ogIHNxFjiCl9x7DDPF34/w
         3Sw0Rk/pb5EHyknoRlIOYQVJ1dIb+o4KF4Cxx+Ohq7p3HIwbwfdM+fJCqqLM0p3Mwk
         kDaFM50jpOchWvFrNunUf0WsWQzzM5F2kSpC0QHEiWjYhDu6kUMJFovJiSJZ0tYqex
         eg4YZmw6y8G9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27D12E5D089;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: cpsw: Properly initialise struct page_pool_params
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164312917415.15904.320238953994313233.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Jan 2022 16:46:14 +0000
References: <20220124143531.361005-1-toke@redhat.com>
In-Reply-To: <20220124143531.361005-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     grygorii.strashko@ti.com, ilias.apalodimas@linaro.org,
        m-karicheri2@ti.com, davem@davemloft.net, brouer@redhat.com,
        ivan.khoronzhuk@linaro.org, alexei.starovoitov@gmail.com,
        colin.foster@in-advantage.com, kuba@kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 24 Jan 2022 15:35:29 +0100 you wrote:
> The cpsw driver didn't properly initialise the struct page_pool_params
> before calling page_pool_create(), which leads to crashes after the struct
> has been expanded with new parameters.
> 
> The second Fixes tag below is where the buggy code was introduced, but
> because the code was moved around this patch will only apply on top of the
> commit in the first Fixes tag.
> 
> [...]

Here is the summary with links:
  - [net] net: cpsw: Properly initialise struct page_pool_params
    https://git.kernel.org/netdev/net/c/c63003e3d997

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


