Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD357379932
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 23:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbhEJVbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 17:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:40414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231811AbhEJVbQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 17:31:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9237D61613;
        Mon, 10 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620682210;
        bh=MmE8v1hXubznzhGaE7C8q0XVtGuAxwMrNzLeBYh7e1I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SkNlk5d9VGZTA8yyM3909B0OwqFeqk7PVPGEx71TSc+iVwc+AanZeP5ErXLnsBxtr
         fq06GBo0JR5kylVOdYPtuQqeOSxibvxHtNdFB1ApOrzuQPnlBV6vGDpTuWeXBZtqL+
         xKdSVXDKAEJEZgunNJyyEX0rg3wg2hkrTqKt28ytctnIFyrenC34aXUFvFoL9wi+rV
         DIPy/dVE9vqhcdOh3B5IpXl55ZQjRsJE3wKe2uWIHVi4066an5pggQvAWXNAxXVgto
         xZdHomiovzawzQlJGfrOZ+riTtvFgPQBNgUEDzIKrH/FVNvlbLw9xh2T00TOuzWn4+
         hxtP/x3Prff0w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8C929609AC;
        Mon, 10 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] neighbour: Remove redundant initialization of 'bucket'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068221057.28006.13564077451143284721.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 21:30:10 +0000
References: <1620468185-122101-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1620468185-122101-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  8 May 2021 18:03:05 +0800 you wrote:
> Integer variable 'bucket' is being initialized however
> this value is never read as 'bucket' is assigned zero
> in for statement. Remove the redundant assignment.
> 
> Cleans up clang warning:
> 
> net/core/neighbour.c:3144:6: warning: Value stored to 'bucket' during
> its initialization is never read [clang-analyzer-deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - neighbour: Remove redundant initialization of 'bucket'
    https://git.kernel.org/netdev/net-next/c/48de7c0c1c92

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


