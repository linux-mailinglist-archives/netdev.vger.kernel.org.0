Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2C234B264
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbhCZXAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:35314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AA49361A3F;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=qjR03MxN6bU4e+VqS0K6BFiTkKEshbiuj3eumdnfeT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UEvapn0wQHJ2A4lffR/dJTBkjliZIhlFT9vmyFBI0y6Fdij8Fk3jk1wc2g6beeo+c
         67ZBhZyjPiNVrdCxbE3zdscPYyy/FkBUIIeWVgWLFLNnvCUwGDF518NPcRsbJ18XtN
         L8mbG3NZ0GxgRozY80y6AZtbO2AvJ/BiU+3coaoMJ/ttYjOTmfK76ESpHRtbGmQm/S
         LgI+bnhUw/q/C1LjvEj9yyMuKSuVPHiu8xdIcr/4ZJr+lKJGY/pERInlIu0LqebpBp
         D2SsyxyB8Dr6H0P5StqGjOwDnwnakwzt1WFTj0me6QhsbzRHLXQ0YwJ7MLWOawJDlH
         6o1ndjX3GusZQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9299560192;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] tipc: fix kernel-doc warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961259.14639.7569806421766030836.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326091414.6705-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210326091414.6705-1-hoang.h.le@dektech.com.au>
To:     Hoang Le <hoang.h.le@dektech.com.au>
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tuan.a.vo@dektech.com.au, tung.q.nguyen@dektech.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 16:14:14 +0700 you wrote:
> Fix kernel-doc warning introduced in
> commit b83e214b2e04 ("tipc: add extack messages for bearer/media failure"):
> 
> net/tipc/bearer.c:248: warning: Function parameter or member 'extack' not described in 'tipc_enable_bearer'
> 
> Fixes: b83e214b2e04 ("tipc: add extack messages for bearer/media failure")
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> 
> [...]

Here is the summary with links:
  - [net-next] tipc: fix kernel-doc warnings
    https://git.kernel.org/netdev/net-next/c/bc556d3edd0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


