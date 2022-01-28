Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D5449FCB4
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344794AbiA1PUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245094AbiA1PUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:20:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE3CC061714;
        Fri, 28 Jan 2022 07:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8739960DF1;
        Fri, 28 Jan 2022 15:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D903AC36AE3;
        Fri, 28 Jan 2022 15:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643383210;
        bh=LlkLYQSxtmWebL1rmSOzh/IBRSHYSJJCW7xBFL9ZrIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ABcElZPUVv0ZRKEMDHlFEAwAKWW/k9MzfKX+jEOjKoVrVtIwtvPYUgOPsYy95PAmU
         xVtHuWttmEO/ImorHKyw/g8ivh80550PedWfYLiPrxugONRG+452PhsD1PHiAxs67Z
         PAK3oaL5iZXaSRuOFKXxjFPrU0LpC3GjPZoZG0amHBURFo6gocSLOxOuq3zthCsE/p
         gJLFu6oBpq2xkV5BKhYGFf7V9Fbb+qetETam6X3HYeHyWqkcANpL9AyINVIYDunrFs
         h72dHwaogxvrhCOzvZpghO+GjRD/jg2otV4V+EX8O6ISCZ9BI2a1aX3SmXaKjQUdi6
         579ZE0yYCvuZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BFFD7F60799;
        Fri, 28 Jan 2022 15:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2022-01-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338321078.8810.12114883405236915786.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:20:10 +0000
References: <20220128114501.2732329-1-stefan@datenfreihafen.org>
In-Reply-To: <20220128114501.2732329-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 12:45:01 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree.
> 
> A bunch of fixes in drivers, all from Miquel Raynal.
> Clarifying the default channel in hwsim, leak fixes in at86rf230 and ca8210 as
> well as a symbol duration fix for mcr20a. Topping up the driver fixes with
> better error codes in nl802154 and a cleanup in MAINTAINERS for an orphaned
> driver.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2022-01-28
    https://git.kernel.org/netdev/net/c/010a2a662331

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


