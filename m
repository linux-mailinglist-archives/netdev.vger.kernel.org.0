Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A5A634C0CE
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 03:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbhC2BAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 21:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC2BAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 21:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5578561941;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616979611;
        bh=jGsD/rIy4jpFFHA8P7cF3NmqO8WHG9MtADhVzJFwkWg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y2fFAp2kiyCpla5Ja1rYqMJf0Y6bA22GgaDeD+cofwc9aKt/hOezvktaWdtFtXiBX
         k7hHiJnK/6yRveW9iTv5oiAQBk2JNFw3iWJjZS1XBKpbJWy0E5uWtCQB8XEj9P8TI4
         SYloJif0KSNS8UjSmE3LfrSRrNo4m1oQnO85Xi4EZadbm2KiQxI3NOZAVYHTVM83VC
         T8tAWP5D8j3uFJ9S/8XTidVw3nK8ZK0PWBmoLmnu4bNomuWXHN1qKdtaSypwXWvwsA
         3CEyLegR5cvYTnCzj7rak9exi5zbRqGgO6wbfI8+LoOWqNXlquN/ec9pla+eRf6Rbo
         efjau3KsmmItw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 490DD60A58;
        Mon, 29 Mar 2021 01:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nexthop: Rename artifacts related to legacy
 multipath nexthop groups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161697961129.31306.12805810387852527074.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 01:00:11 +0000
References: <2e29627ba3c4e6edf5ee2c053da52dab22f3d514.1616764400.git.petrm@nvidia.com>
In-Reply-To: <2e29627ba3c4e6edf5ee2c053da52dab22f3d514.1616764400.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 14:20:22 +0100 you wrote:
> After resilient next-hop groups have been added recently, there are two
> types of multipath next-hop groups: the legacy "mpath", and the new
> "resilient". Calling the legacy next-hop group type "mpath" is unfortunate,
> because that describes the fact that a packet could be forwarded in one of
> several paths, which is also true for the resilient next-hop groups.
> 
> Therefore, to make the naming clearer, rename various artifacts to reflect
> the assumptions made. Therefore as of this patch:
> 
> [...]

Here is the summary with links:
  - [net-next] nexthop: Rename artifacts related to legacy multipath nexthop groups
    https://git.kernel.org/netdev/net-next/c/de1d1ee3e3e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


