Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB6F3050BD
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234611AbhA0EYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:24:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388261AbhAZXUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 18:20:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8907264D7A;
        Tue, 26 Jan 2021 23:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611703212;
        bh=zp9CpCikTkrKgUNLhsZAw69V5Jd+59X2HEzhbxUNYk0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pszYXfAPj4wwl1USetPju/ENSdd5Lq1ZpZRZs5I2mV/QE3VOZc3T/XXQXYgyPL9Mi
         HSWD1yTd8eQwMdr8zGuflYGPCa97Gz5cz2nWO1W5z99FtskJTf8WltyWHLMDIbwS3w
         e9EqjsZFTpu0tbpD2IQ7CFZA5AEvF+AbNcrTHf9yzYTH2vSC2uJq+K/mv+2C/EMTsZ
         vovwrWd6B03GwET53ytNw+zc5ugD/jpRHbzScROXuB5/h99+MMPuURPLnAqFvhdt3f
         H1d5n2roreDP4wBRAt0lsqLol4DbsjueTkEx82fJZxw3sirt6JVhP5EFmEptMAtkJ+
         6gH4WKHdZ/SVg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 81BDD652DA;
        Tue, 26 Jan 2021 23:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] iwlwifi: provide gso_type to GSO packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161170321252.26028.13767129342012102952.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 23:20:12 +0000
References: <20210125150949.619309-1-eric.dumazet@gmail.com>
In-Reply-To: <20210125150949.619309-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, greearb@candelatech.com,
        luciano.coelho@intel.com, linux-wireless@vger.kernel.org,
        johannes@sipsolutions.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 25 Jan 2021 07:09:49 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> net/core/tso.c got recent support for USO, and this broke iwlfifi
> because the driver implemented a limited form of GSO.
> 
> Providing ->gso_type allows for skb_is_gso_tcp() to provide
> a correct result.
> 
> [...]

Here is the summary with links:
  - [net] iwlwifi: provide gso_type to GSO packets
    https://git.kernel.org/netdev/net/c/81a86e1bd8e7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


