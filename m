Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0550F415D5E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240802AbhIWMBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240775AbhIWMBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Sep 2021 08:01:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CB4886115A;
        Thu, 23 Sep 2021 12:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632398407;
        bh=X+3VvimFSnrjreK0igv8ZAR1isWFqfcaOxieRRv8P1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZLane4t70YXhxx7ZuHjTDsAmboDY1obbNRP1hlNatdPjFeP+Gazx/CcQMVdpC6oa/
         Xg9W4+zTPQOJAq2uyC8IgRB2/wphemdtG6iddsS87r5/8iOxz+Vi5R5c9zgNhoTNyz
         RJQYxzj3kbOcXSsHJrX1HzMZcmG1FdKl3+Nd0KAUrJw5JQe1Bv9z1uTKWe1JluvyHq
         u3jSXIRBkikdKGx+Rq8d2xK47ke+1K7695z5sThsLFt0uivGq75u/fwBKmXd3eVPPr
         6SquX8LKkzX/4vZBRfsoeNCW7SbgTyBwW3Vfoi+DtrpNuEOy1UevqAyAymqAEPqM9Y
         0DZyl6dmOuPpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BE1F160AA4;
        Thu, 23 Sep 2021 12:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: remove Guvenc Gulce as net/smc maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163239840777.772.9007347269459264988.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Sep 2021 12:00:07 +0000
References: <20210922172129.773374-1-guvenc@linux.ibm.com>
In-Reply-To: <20210922172129.773374-1-guvenc@linux.ibm.com>
To:     Guvenc Gulce <guvenc@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        kgraul@linux.ibm.com, jwi@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 22 Sep 2021 19:21:29 +0200 you wrote:
> Remove myself as net/smc maintainer, as I am
> leaving IBM soon and can not maintain net/smc anymore.
> 
> Cc: Julian Wiedmann <jwi@linux.ibm.com>
> Acked-by: Karsten Graul <kgraul@linux.ibm.com>
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net] MAINTAINERS: remove Guvenc Gulce as net/smc maintainer
    https://git.kernel.org/netdev/net/c/5b099870c8e0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


