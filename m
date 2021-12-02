Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599FE465CA0
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355175AbhLBDXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:23:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355151AbhLBDXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:23:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F3EC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 19:20:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 42EB5CE21A4
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 03:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 67EC8C53FD5;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638415211;
        bh=1mKUgy9Gmo+8dT+mb6El9A34MG3nbvu+LWm3GQFLHo4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SyeWmZiHChi8snz839/pkAP7K4mSLXPRB5LBUc9BGcn8bPe5Bv06UrBDJ0CsM1CQX
         eUHdlsiFMTGNpaCHHbZ3vehQajwnhe/XN4CP+PFoUmkzJQg/6eJLGIQccqGNXtreRd
         Ax049aCeQaW0EYRpN66ByyJoEA4X7IZwJ1ONgucGF25I4Wn2wny8k9AWmOp5MunosJ
         18VJH2X9DsfGhJ5dU1ZtpElM6cIw7/DzLOw2+VvF6tmRwd0QMmwW1JNlB1eoDbGRA1
         J3/kM/7db20q4ZFl8fLGhYR2JJJ4qAAL5iUA4Fs2EW4Cn6vcCuq9URnq5nPqWWoWZj
         BzWhOjr09VrvQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F7EA60BE4;
        Thu,  2 Dec 2021 03:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: snmp: add statistics for tcp small
 queue check"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841521132.978.2256090015897309394.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:20:11 +0000
References: <20211201033246.2826224-1-eric.dumazet@gmail.com>
In-Reply-To: <20211201033246.2826224-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, imagedong@tencent.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 19:32:46 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> This reverts commit aeeecb889165617a841e939117f9a8095d0e7d80.
> 
> The new SNMP variable (TCPSmallQueueFailure) can be incremented
> for good reasons, even on a 100Gbit single TCP_STREAM flow.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: snmp: add statistics for tcp small queue check"
    https://git.kernel.org/netdev/net-next/c/ce8299b6f76f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


