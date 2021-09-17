Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0579840F5C5
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 12:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242104AbhIQKVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 06:21:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:49718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237545AbhIQKV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 06:21:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 701B7610A6;
        Fri, 17 Sep 2021 10:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631874007;
        bh=OClB0FfyZJXFuCivv1rWFT5J2PgYy0v6GRtB4eCYo+Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=clnLuK8+Xw3VMtv9WgprktOxm4d5UFSs/fWVKKIFNkoPpDBKXi0qWkqL4KCwuT/nO
         nqoYl5DXfHwpRFUnU6+Us9vPNGyTciP/L9pPnRY1lKmBghF2XqV4T+YdCONHvPu0/I
         52XcGnag6yQt+vB3C96ntLMmfbCCDa832BWtgSEY3IjelkOQV5Mns16XkAatyrKUQr
         1fgRo0S4seNpfAfoiLZ7mkKNcTjSv5foGKsdSFetuYSiZGogClgyd+3gzWghH0m5ko
         gnrK5W/YBT2dQK9TDxtnMtkALyTeSlSwZbyqWYvyPnNVMKs0nTa299mIv8WYc2OrmP
         0/ddXJzeCyx9A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64BC360965;
        Fri, 17 Sep 2021 10:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next,v1] net: e1000e: solve insmod 'Unknown symbol mutex_lock'
 error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163187400740.11494.8208551206077305287.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Sep 2021 10:20:07 +0000
References: <20210917141654.8978-1-chenhaoa@uniontech.com>
In-Reply-To: <20210917141654.8978-1-chenhaoa@uniontech.com>
To:     Hao Chen <chenhaoa@uniontech.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 17 Sep 2021 14:16:54 +0000 you wrote:
> After I turn on the CONFIG_LOCK_STAT=y, insmod e1000e.ko will report:
> [    5.641579] e1000e: Unknown symbol mutex_lock (err -2)
> [   90.775705] e1000e: Unknown symbol mutex_lock (err -2)
> [  132.252339] e1000e: Unknown symbol mutex_lock (err -2)
> 
> This problem fixed after include <linux/mutex.h>.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] net: e1000e: solve insmod 'Unknown symbol mutex_lock' error
    https://git.kernel.org/netdev/net-next/c/6042d4348a34

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


