Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A61032DD3D
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbhCDWkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhCDWkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:40:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CDDA164F4A;
        Thu,  4 Mar 2021 22:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614897608;
        bh=z3dYkTdFd0b/FhBOFYn7+ECXiQD6CX54QtDgEcgUUuU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kp0nRVmuR2VXblVwicbDe1Vu6ZNTcK1jxlVpc2oKRuhJjYu4AEwrLSl7Yxn342FSj
         j6/m8WxoD+gJB5BLI/LYzmI7q5dsQfdQKgH56NUvjV+3dcxlTk/Qymt8egYJ8dJkBn
         MQamja24ny1l2ND0Z96iSbkva8rrl3rvr2Hy8Um9IVgFoSBTqgg8yPzfsY3/0PGEmM
         fHejhN4peE83WXrDJJ3SS+jWBDhV4o6aUVD5b9qSn7ukxVHd3+d8Doi6mzXRuHUOpk
         3eOYkk7j1MWQwJPcEOSdpCvqlviDXSZBxOHR2kDinB/UOJwvvLRb0tT6t+YqkZuc9T
         d6NHBsz3Cvrig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2BB760A12;
        Thu,  4 Mar 2021 22:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: avoid duplicates in classes dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489760879.17160.3832033067769645684.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:40:08 +0000
References: <20210304144317.78065-1-mheyne@amazon.de>
In-Reply-To: <20210304144317.78065-1-mheyne@amazon.de>
To:     Maximilian Heyne <mheyne@amazon.de>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, jkosina@suse.cz,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 4 Mar 2021 14:43:17 +0000 you wrote:
> This is a follow up of commit ea3274695353 ("net: sched: avoid
> duplicates in qdisc dump") which has fixed the issue only for the qdisc
> dump.
> 
> The duplicate printing also occurs when dumping the classes via
>   tc class show dev eth0
> 
> [...]

Here is the summary with links:
  - net: sched: avoid duplicates in classes dump
    https://git.kernel.org/netdev/net/c/bfc256056358

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


