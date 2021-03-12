Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D40733836A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 03:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCLCKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 21:10:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhCLCKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 21:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 58BD564F90;
        Fri, 12 Mar 2021 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615515008;
        bh=YNATF87h0nf3BSXcDJOIzx8/hkJzTJ+0L79TGettFJQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ipqJ6PZQiGndLu6gek0ZT5uYZawNbePuCCdkUb/yZ08FZLu8MC5vN8k/KjKifxAf+
         1dpu03unGA+D6kyWH6R/thUhv8caofFNfHeXTs8c1VJig3kPiikf64FR93lCwCJcuk
         nZeziQwSLYJRGK8XOvNy8JDpAD06k8Rp6PflWN733Mq8N5q0aDJsmgl5JaMN5hRHNm
         lvy7SPVBinVAxULExLJnIot60qOs4gUrjOW+G6QztB6VCxkZso/+SAd2cU4nuk8W3w
         QYr4tnZS/iH5GtBAJHSkcSST/2uJ3F6disBMWQJc8AjDiO00uF/gEP9RTnq6+i21RO
         JbM1IO06bumFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 535E6609E7;
        Fri, 12 Mar 2021 02:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 1/2] tipc: convert dest node's address to network order
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161551500833.25701.15755029177377046109.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Mar 2021 02:10:08 +0000
References: <20210311033323.191873-1-hoang.h.le@dektech.com.au>
In-Reply-To: <20210311033323.191873-1-hoang.h.le@dektech.com.au>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Mar 2021 10:33:22 +0700 you wrote:
> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> (struct tipc_link_info)->dest is in network order (__be32), so we must
> convert the value to network order before assigning. The problem detected
> by sparse:
> 
> net/tipc/netlink_compat.c:699:24: warning: incorrect type in assignment (different base types)
> net/tipc/netlink_compat.c:699:24:    expected restricted __be32 [usertype] dest
> net/tipc/netlink_compat.c:699:24:    got int
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] tipc: convert dest node's address to network order
    https://git.kernel.org/netdev/net-next/c/1980d3756506
  - [net-next,2/2] tipc: clean up warnings detected by sparse
    https://git.kernel.org/netdev/net-next/c/97bc84bbd4de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


