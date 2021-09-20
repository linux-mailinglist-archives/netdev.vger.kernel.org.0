Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD9CD411439
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 14:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237751AbhITMVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 08:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237746AbhITMVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 08:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7C0BA610F9;
        Mon, 20 Sep 2021 12:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632140407;
        bh=o4f+jmMAvBiPcB04C3f2YVORvW8X2OsXP2hYBrbQg9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nO7y5BqmoGpDTngv6ZphCxrayX2j26kgHTbD8Tz6KDpVsy9790GbOD6yeierjh8eN
         k6sdfpvsBD5AOWOvVuKdc4AUY6iSd6ZadM4K4VzQFUVds1cEWWSjpLgtdqyo6Zq36m
         yiYQj4A0nQuA/qb2JvWRjkuC/EqjoMO3Ahmyxyt73A+HudFsUF6mSQCim11VQ9bkUR
         yTZE22gzfU3hnrkusrim/FsBDWW6lgNXehbszzMVl4JeNFSg6u5SphFB37Ts3+oAgr
         7KoFjlrrICn/SeKrxrCPTu4ujwPUY2aByGt4vNfgvOech7zgBd5bWFEl0MRejrumkf
         WYvC0L8zDSpDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7212660A5B;
        Mon, 20 Sep 2021 12:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net/ipv4/route.c: remove superfluous header files from
 route.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163214040746.3439.15546413011047021772.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Sep 2021 12:20:07 +0000
References: <20210920113137.25121-1-liumh1@shanghaitech.edu.cn>
In-Reply-To: <20210920113137.25121-1-liumh1@shanghaitech.edu.cn>
To:     Mianhan Liu <liumh1@shanghaitech.edu.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 20 Sep 2021 19:31:37 +0800 you wrote:
> route.c hasn't use any macro or function declared in uaccess.h, types.h,
> string.h, sockios.h, times.h, protocol.h, arp.h and l3mdev.h. Thus, these
> files can be removed from route.c safely without affecting the compilation
> of the net module.
> 
> Signed-off-by: Mianhan Liu <liumh1@shanghaitech.edu.cn>
> 
> [...]

Here is the summary with links:
  - [-next] net/ipv4/route.c: remove superfluous header files from route.c
    https://git.kernel.org/netdev/net-next/c/ffa66f15e450

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


