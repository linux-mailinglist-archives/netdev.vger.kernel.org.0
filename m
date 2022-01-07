Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1145E4878AF
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 15:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347508AbiAGOKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 09:10:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59550 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238405AbiAGOKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 09:10:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 861B0B82629
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 14:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3026CC36AE0;
        Fri,  7 Jan 2022 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641564611;
        bh=9oFOWYSLKUXCMji6YWTtoct3oYozxR4QWZtCkhZu1r8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CPFMt+eUhtni075g/lTFHr/zaQ889Me2cGExDlBsIPWHm05V9dH6+c3NjCFlxfamX
         uO4hPNleRuDvpjCWsEJNSfSAbbfld0OhNf8MasoouNM6Uo70F9OpUXMR8O+n0q0jV9
         IHcwac9vv4sjE5fFzzfqbDyF9xdfQF8yRVcNQGw6eWMYCdMJwFmHulIoXycwGC77a8
         1OobcjxnJ8ShOlKRHn8EKwkGumX8YmQEqOzhkFXXAX7JafSnZ4mbT76ePQyIi4fNKT
         wONCvVTqdch7e6NGp4n0tE3c0PhQJta7uasjGws9AG5eJ6/4jjvvRJ/ZqNvIKIEfuv
         25dzSvel7O2rQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B68DF7940A;
        Fri,  7 Jan 2022 14:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH 0/2] octeontx2: Fix PTP bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164156461103.16670.4345569899865152234.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 14:10:11 +0000
References: <1641537030-27911-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1641537030-27911-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        hkelam@marvell.com, gakula@marvell.com, sgoutham@marvell.com,
        rsaladi2@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 7 Jan 2022 12:00:28 +0530 you wrote:
> This patchset addresses two problems found when using
> ptp.
> Patch 1 - Increases the refcount of ptp device before use
> which was missing and it lead to refcount increment after use
> bug when module is loaded and unloaded couple of times.
> Patch 2 - PTP resources allocated by VF are not being freed
> during VF teardown. This patch fixes that.
> 
> [...]

Here is the summary with links:
  - [net,1/2] octeontx2-af: Increment ptp refcount before use
    https://git.kernel.org/netdev/net/c/93440f4888cf
  - [net,2/2] octeontx2-nicvf: Free VF PTP resources.
    https://git.kernel.org/netdev/net/c/eabd0f88b0d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


