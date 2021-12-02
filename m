Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C64834663B0
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 13:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346953AbhLBMdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 07:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346595AbhLBMdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 07:33:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CA6C061757;
        Thu,  2 Dec 2021 04:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 74F43CE2281;
        Thu,  2 Dec 2021 12:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D49CC53FD1;
        Thu,  2 Dec 2021 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638448209;
        bh=1neSMLTnFwGSiuXpwZJ2fOw6eY1uH2v+Jw+vQfWvn1U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ts8QWyugmecDZU882BDgyupJDwwX5HBFYQwPJh7H81Jd2Iwu5zhG+tggV7AyjkAaW
         f4zJ+h8Efl7NwVGBFLyuUptlYHyUAdNMusYgSMjummBioR3WM8GvYibjfntez+qTjJ
         +UXI5ewxAtYOSp6CpKKUk0g7DY5Y0uAdvLTvzcovrzhaxGyeDrLyJsiSbvuvIlwRt5
         4mTKaThh7qJgYS8ldzOI3/+ZgETT2pZorObpadbDBC2vlLZWoSxVrOJVfYF6jFRNnp
         Q/c5TAMaDpZ654PyvF1WiDtsknVt8wVpbG6LQbmZBiqgdofCRaYZ8mBM1y+CVyeG40
         cM+CYsn+5wMwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 853FE60A88;
        Thu,  2 Dec 2021 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] gro: Fix inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163844820954.14016.3674174898705138455.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 12:30:09 +0000
References: <1638433842-41235-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1638433842-41235-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  2 Dec 2021 16:30:42 +0800 you wrote:
> Eliminate the follow smatch warning:
> 
> net/ipv6/ip6_offload.c:249 ipv6_gro_receive() warn: inconsistent
> indenting.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - gro: Fix inconsistent indenting
    https://git.kernel.org/netdev/net/c/1ebb87cc8928

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


