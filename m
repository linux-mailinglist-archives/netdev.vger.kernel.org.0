Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867902FAF4A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 05:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729459AbhASEBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 23:01:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbhASEA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 23:00:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C9D1120DD4;
        Tue, 19 Jan 2021 04:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611028808;
        bh=ay7kbvjUBwnpdN7mplj+CYdGA7Vr5h/rNg0vwgKu/E4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PCNeHy5pztls0YNUxVSaxZHplX9qZU3TK/pjKtLrBCAdYPUJ177qelSunK37mCRIA
         o7XE+XSOxQqL4/CUeQaHBjOwoqt6+ocUNRpdkXTTgwXiW07K079KpY9jPvbhr1Ond1
         g/kxiL6IP/RgjUPK3PARCiaktdgjOBL2xN44FF5UwrC1eyI72bytbMKf8LqIdShcHF
         vxhZWVNjZ/4mb5WME4xEV4vtyrF66ULQ5xD+D6QOFIIsDyiH2+RTgsCI+64YWG1c05
         Hsn2VH6Bfpm00tEmOHa9+JqAtK9jNuEGo5gJQxC+r4T3VKZ+LLbT16ak831vnuQmf2
         N9ExKDssxGQ8A==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id BDA3F6036C;
        Tue, 19 Jan 2021 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] ipv6: fixes for the multicast routes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161102880877.24762.7105009788756297504.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 04:00:08 +0000
References: <20210115184209.78611-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210115184209.78611-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 15 Jan 2021 19:42:07 +0100 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> Fix two wrong flags in the IPv6 multicast routes created
> by the autoconf code.
> 
> Matteo Croce (2):
>   ipv6: create multicast route with RTPROT_KERNEL
>   ipv6: set multicast flag on the multicast route
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipv6: create multicast route with RTPROT_KERNEL
    https://git.kernel.org/netdev/net/c/a826b04303a4
  - [net,2/2] ipv6: set multicast flag on the multicast route
    https://git.kernel.org/netdev/net/c/ceed9038b278

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


