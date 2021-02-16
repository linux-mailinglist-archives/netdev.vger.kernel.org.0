Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9186E31D2F8
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 00:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbhBPXKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 18:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhBPXKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 18:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 82B2464E65;
        Tue, 16 Feb 2021 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613517007;
        bh=jZAs+2h5wi/W2iPNKNDXl/MWAQcFnAkrzMGk33FmoQM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IhEtqHg8I+x3VaiBtMZn0DJKWxyfzsZeD6tAhjgYypOnjhCN/2JqUyRUe+0qlUQA3
         p7cs9KgTbLsjVL++zAz2aWvEFKmMuND2MWyUimtmZi5AR3xMf6kFDuz4lFE8HbKZQo
         /GsB7Gdnp1OVgAxYa7tKSbzYKraupxxL3kv7EeaAcW9xG2JBimLGmz/UbLoGdnwfm6
         msFSF6V3qOXCBp5A2TQpwcFLolF+MpZk9EaxZ3idWk0/tHRVSnpe+OT6Th9zD5UpsA
         vIyU2L7go7gncYN/xeSzZK/BpSNuHwHNwCMrzh3hH95B4iafRKGStSWx5Ik/K0M1UK
         FrHeGCWweyDFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7123960A0D;
        Tue, 16 Feb 2021 23:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enetc: fix destroyed phylink dereference during
 unbind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351700745.13890.5593417078904769884.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 23:10:07 +0000
References: <20210216101628.2818524-1-olteanv@gmail.com>
In-Reply-To: <20210216101628.2818524-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        michael@walle.cc, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 16 Feb 2021 12:16:28 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The following call path suggests that calling unregister_netdev on an
> interface that is up will first bring it down.
> 
> enetc_pf_remove
> -> unregister_netdev
>    -> unregister_netdevice_queue
>       -> unregister_netdevice_many
>          -> dev_close_many
>             -> __dev_close_many
>                -> enetc_close
>                   -> enetc_stop
>                      -> phylink_stop
> 
> [...]

Here is the summary with links:
  - [net] net: enetc: fix destroyed phylink dereference during unbind
    https://git.kernel.org/netdev/net/c/3af409ca278d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


