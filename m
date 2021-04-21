Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BBC3662BA
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234544AbhDUAAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234507AbhDUAAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E67D561421;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963210;
        bh=9BRQZleX08LWHaXMrHIKZdNkRK5FFULAGdT7s3gYR2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OOhUoedEHenTSCXa37/xR0MyhCwK4QWNmW4Iu38rZ57vue9GnqWWOH71v5v9CqL7e
         PMKm8AtPgttIjakQAWD+OpBMOLmXDHfVfQeyHDDX0uBJKhHbOXChg95gT7Rcu9WrGo
         BM6UvSwW+23goCaIDHh/9h8b87lfv9mlPLeaq+iRdJiihyZitLZPljvLpSEMX+4iAk
         ORXD711JJt0/CVFvRtYqpCH4yCnnamT51RCLFBG/KZsYekqG2LWZWjf3tvz0qIzf3J
         7wzx0dQc0R8GEYayJYAdJD/gGoL1PWBi+wvmqr2Ta5Z7JCg8AzF2TfNfSwM6JO0Cp1
         RJR2BnmHHN0Bw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E0D0560A39;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enetc: automatically select IERB module
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896321091.2554.18039608241938326079.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:00:10 +0000
References: <20210420142821.22645-1-michael@walle.cc>
In-Reply-To: <20210420142821.22645-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 16:28:21 +0200 you wrote:
> Now that enetc supports flow control we have to make sure the settings in
> the IERB are correct. Therefore, we actually depend on the enetc-ierb
> module. Previously it was possible that this module was disabled while the
> enetc was enabled. Fix it by automatically select the enetc-ierb module.
> 
> Fixes: e7d48e5fbf30 ("net: enetc: add a mini driver for the Integrated Endpoint Register Block")
> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> [...]

Here is the summary with links:
  - [net-next] net: enetc: automatically select IERB module
    https://git.kernel.org/netdev/net-next/c/1b8caefaf4f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


