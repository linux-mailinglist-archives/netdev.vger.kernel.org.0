Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1AC42EEC7
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 12:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238012AbhJOKcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 06:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237986AbhJOKcR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 06:32:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B08AB6108E;
        Fri, 15 Oct 2021 10:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634293811;
        bh=R6UavHqY76VYhoX9YrB+YjQkMSGLySy0yuGX/Xlx0hQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZHzHpmM9i5OHaNpvQkgO7uv19A+kq8pDiYlckKm4amw51Y4pWPMbkf3NNr5ZzWg7W
         FXe62D9iWWHl73iDrwzBlDGrJ9Bje8IrN882Inkob3sVSaaPJGOrI15xWSrR/2gda4
         cL2GJGwqKWLDqm1t/v1vn82xMBn2vgIeL98aurTuZSXnfsZ0L1I89IeQWJDfDkfZRn
         l09S+DfYTGHjIuV4D7791eaZ6wDQ221GKOtMChwLYSXPSxJpGaVjn3+8SGBgkYuNbF
         V9t29Nt4JcAqguNyvFim2lGzrEpg7wxYEWPJOycwiLUOLpZLxvMqOpSwTMBElylQ1a
         8rZXk5K8VnPNw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A582660A4D;
        Fri, 15 Oct 2021 10:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] mctp: Avoid leak of mctp_sk_key
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163429381167.2368.8427273925060119169.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 10:30:11 +0000
References: <20211014081050.3041204-1-matt@codeconstruct.com.au>
In-Reply-To: <20211014081050.3041204-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jk@codeconstruct.com.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 16:10:50 +0800 you wrote:
> mctp_key_alloc() returns a key already referenced.
> 
> The mctp_route_input() path receives a packet for a bind socket and
> allocates a key. It passes the key to mctp_key_add() which takes a
> refcount and adds the key to lists. mctp_route_input() should then
> release its own refcount when setting the key pointer to NULL.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] mctp: Avoid leak of mctp_sk_key
    https://git.kernel.org/netdev/net-next/c/0b93aed2842d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


