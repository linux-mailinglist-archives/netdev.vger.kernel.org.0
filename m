Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89E23349D20
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhCZAAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:00:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhCZAAK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:00:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7149A61A40;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616716809;
        bh=jpcBiFj0ShAQs/djZ8csJdQIcztPuXpzcg6Pk1oswIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=atO72IW60ga1Hv7yZoZZOnkeb3I9xpo9foMBJT8Ej9ixyJRj3xlgUcPa//9FdcApv
         7mzAohgAyYd8yIxcmtgAz6T7uHhgv+wVuVaWEOcetEpc+DYdF6mlfcv2hVan3rpQes
         n2oaqKxdPwnkbAAD5N2aM+R4T0wnbHkvZ/mZ3e1Gu+Ns8rfV/1PPpyR7mS5k/qedGY
         yB4Cq0ftzKSTI5zioSmmJqfCEmwtQNbfn82ndhwLF8f0/iHOc8j1DvdvkBL20RRgs/
         W9Gzj4vVQV9nC4u9DzE7ROJs3s9s959yZ+p/SkSgUFUzQoyPjliTfES7U87LGHubY9
         m6HBrcEn3Nm1w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6541D625C1;
        Fri, 26 Mar 2021 00:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] tipc: add extack messages for bearer/media failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671680941.21425.1282744560689258542.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:00:09 +0000
References: <20210325015641.7063-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210325015641.7063-1-hoang.h.le@dektech.com.au>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tuan.a.vo@dektech.com.au, tung.q.nguyen@dektech.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 08:56:41 +0700 you wrote:
> Add extack error messages for -EINVAL errors when enabling bearer,
> getting/setting properties for a media/bearer
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> ---
>  net/tipc/bearer.c | 50 +++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 40 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next] tipc: add extack messages for bearer/media failure
    https://git.kernel.org/netdev/net-next/c/b83e214b2e04

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


