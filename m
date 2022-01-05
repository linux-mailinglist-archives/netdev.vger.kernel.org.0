Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED635485717
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 18:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242162AbiAERKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 12:10:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51966 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242157AbiAERKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 12:10:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBC20B81A88;
        Wed,  5 Jan 2022 17:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B86A4C36AE9;
        Wed,  5 Jan 2022 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641402611;
        bh=0+7jAeT7eLb75NzaqVossLjW10fIz9vo2PdB2I5VB5E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aA1yJkl+GZVvXnAUfXMDIvlBEFFSCcfybDweD9qTASFD0UuyIj0ULLhd++6ltFlom
         90op36G1g/dKf+LGhQPZq8ZfJEdARJMWM6Vq4ii5RWtCFOy1MrcG0OZSFwtiWCnugv
         1i8Y6lsYDyc3UKyJZ3PfT7LFOMs8moAGVvYX8CfOwvW2hrFJCOgbJQLTDoxd128mwM
         WModrgWeMZB1TmjIpc66RGTO0G/gng4ihQdt3gpyQNIteX7mT+Ha3696vTrPZ516H5
         bBbKQQtR0tdncpn3zz+CrTovjvdtjhGUJ6dTPrPnkE23/Hszm3SFDG6XHPEhvgEvcw
         4oT2mSvs/u8/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E755F79401;
        Wed,  5 Jan 2022 17:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2022-01-05
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164140261164.10107.11009091878573559432.git-patchwork-notify@kernel.org>
Date:   Wed, 05 Jan 2022 17:10:11 +0000
References: <20220105153914.512305-1-stefan@datenfreihafen.org>
In-Reply-To: <20220105153914.512305-1-stefan@datenfreihafen.org>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-wpan@vger.kernel.org,
        alex.aring@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  5 Jan 2022 16:39:14 +0100 you wrote:
> Hello Dave, Jakub.
> 
> An update from ieee802154 for your *net* tree.
> 
> Below I have a last minute fix for the atusb driver.
> 
> Pavel fixes a KASAN uninit report for the driver. This version is the
> minimal impact fix to ease backporting. A bigger rework of the driver to
> avoid potential similar problems is ongoing and will come through net-next
> when ready.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2022-01-05
    https://git.kernel.org/netdev/net/c/af872b691926

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


