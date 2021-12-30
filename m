Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9772481C7A
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239514AbhL3NaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:17 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47120 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239533AbhL3NaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 70CA9616E8;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5EA2C36AE9;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871012;
        bh=IAlqsNOax/SzsiVazVVX7hdl0papDTMv2Z1zhWf3LjU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JwvHTjwRXNdaowS2fgG9CLAuXiSWUH9VbgM2CJ2qtj/AjI+3GG5hzNJmdNANlAQeD
         p9htl41KgFC0/czwTAvQV5EFm1OeDs9QBVBHECF/pBtAyxKCziqXLl5uYBvjxOd/PK
         QIEKyd70FJqsu+5LordWopFKRS8po/XiOnCo3kzYpKPLP12cK7urufODOu+PDCkaNl
         Jgg3LJbb9lLSNeiJa2pIpk01RnDKF23yzFWAANci8APQWpa8zVUsabZCHhxyXyeI9k
         Z2KHVvnTj4Ds54YieuqKSPAn9wTgcTntia+Whq7e+sKM82k6my1aXiB8xIl9ItWebH
         bbgGrLJ5PVT5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C60F7C395E3;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lantiq_etop: remove multiple assignments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101280.9335.16439928180870761943.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:12 +0000
References: <20211229233626.4952-1-olek2@wp.pl>
In-Reply-To: <20211229233626.4952-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     davem@davemloft.net, kuba@kernel.org, jgg@ziepe.ca,
        rdunlap@infradead.org, arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 00:36:26 +0100 you wrote:
> Documentation/process/coding-style.rst says (in line 88)
> "Don't put multiple assignments on a single line either."
> 
> This patch fixes the coding style issue reported by checkpatch.pl.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> 
> [...]

Here is the summary with links:
  - [net-next] net: lantiq_etop: remove multiple assignments
    https://git.kernel.org/netdev/net-next/c/370509b267fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


