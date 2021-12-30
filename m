Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B58D481C86
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239577AbhL3Nac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:32 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47162 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239544AbhL3NaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26509616E8;
        Thu, 30 Dec 2021 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D42FC36AF9;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871013;
        bh=Hkfa2XCEB5vC8j15H2bEiskJ7X9PBtlLYYgFAxuRrgU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PlvKt+i2PbVzBc17vm63tBMn5QKgMdML2+i0pRPSxGfc4sV1MnG0o9dAts0M+X0vS
         BYce/C9Jzreji/eiE74azUOgEu2JzBOT8GSpluy6IMKikunqzjo/IR7od3pRaX4yBf
         GbfVuJ17d8MGq2LQJtDL0bP2lmTQiAX1RsyS3in64nSDHRs5sApVSYsIwEiZGuMFGq
         SIZAuaUV0mUEovFRoO6MJTDCvt3xplzgm8NJ0QxGXxm/3bn1tAi+LAxYqEHlXc7xDq
         k95DMhA8M4k68ByTyhd1TfYeJ4V2olH1HiVBVbgLL4Lr0eqruyb5nE/hHBrOCcKX10
         zYWWO96Zp72Yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 14963C395E7;
        Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lantiq_etop: replace strlcpy with strscpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101307.9335.10460578821915297757.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:13 +0000
References: <20211229232257.3525-1-olek2@wp.pl>
In-Reply-To: <20211229232257.3525-1-olek2@wp.pl>
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

On Thu, 30 Dec 2021 00:22:57 +0100 you wrote:
> strlcpy is marked as deprecated in Documentation/process/deprecated.rst,
> and there is no functional difference when the caller expects truncation
> (when not checking the return value). strscpy is relatively better as it
> also avoids scanning the whole source string.
> 
> This silences the related checkpatch warnings from:
> commit 5dbdb2d87c29 ("checkpatch: prefer strscpy to strlcpy")
> 
> [...]

Here is the summary with links:
  - [net-next] net: lantiq_etop: replace strlcpy with strscpy
    https://git.kernel.org/netdev/net-next/c/7b1cd6a644f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


