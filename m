Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744AB49D99F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 05:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236034AbiA0EaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 23:30:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46166 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbiA0EaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 23:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4836B82150
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 04:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83D8BC340E9;
        Thu, 27 Jan 2022 04:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643257810;
        bh=H6es6dNoLOO7ekNEEEgC4b98+5SJFJsimGYbsqjSRng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KWRYEH5g4xsQU3obw73BZG4WY4OxeInDTMmWmlr6F31XDaRvWoQibhETTdEZLxjly
         SzVpnDswaeKY7BOx7Seb2YH6oMJg5+7J7EmcWUQOuaXV3NqIxa3z1CKUUD8X1acBXI
         6o3Em8mJGTTztVvFGNKsi9mkMuE4cCokm0dx/paGI8M5gvGM+AgFYY7/b699EehCts
         tgJSuQk8iika/XP1Ugh8e4K3iPyacmqpyjM9fTUig8kwqqZqPSZuNPV5yv1XRkcU3K
         As8bxvZjLm2/h00WT3BFCqBw2WQdYyxbNImdbXWJDESm2bMiaQ4sL3g4UkOLCpehL6
         Y+frw1c9EHqLA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C203E5D084;
        Thu, 27 Jan 2022 04:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v2] dcb: app: Add missing "dcb app show dev X
 default-prio"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164325781043.10851.1475698773516083038.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 04:30:10 +0000
References: <f83e5480816bb050ff9005409ae2ae64b44d52de.1642668290.git.petrm@nvidia.com>
In-Reply-To: <f83e5480816bb050ff9005409ae2ae64b44d52de.1642668290.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, maksymy@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 20 Jan 2022 09:57:54 +0100 you wrote:
> All the actual code exists, but we neglect to recognize "default-prio" as a
> CLI key for selection of what to show.
> 
> Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
>  dcb/dcb_app.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [iproute2,v2] dcb: app: Add missing "dcb app show dev X default-prio"
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=924f6b4a5d2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


