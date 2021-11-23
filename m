Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3C545A29E
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 13:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236663AbhKWMdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 07:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234978AbhKWMdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 07:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 95E7D60F26;
        Tue, 23 Nov 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637670608;
        bh=DwEwqsj+n0zrzeGHWjeB4XXOotybguXVgBnKBWYQAks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c9SZNaDC92Je13iUgUc2rxol1j0Wfd4AOClpV/IdkQsauupKHN09ldhLkURskf9Nl
         WRaoECgTQnkbByh5cTPqvTdGxCuyXjbDXkuN6bRsYgOCxfYv4UVwzYGpIIsWo5dDmi
         LZoCikRv5zx0YkqHiHvDYrW01emvS8DqsPmppFSaiBSUh/Qulu737qqfqw3G0/I9zR
         LazqeVkLcR3Gw4nMvzqSxP31vnEMtfJcU3UwZD2LPlQNkn9v3f6TLW79GqGtmN0GJk
         ngpNpnc/xjHQ3tKxYLBH3NgATscMsLtnUeRUIWJiBFV7pjV+4lIATEQLBxInjTexyM
         G58G5ZSk74T+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89492609BB;
        Tue, 23 Nov 2021 12:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: remove .ndo_change_proto_down
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163767060855.14930.6658373290474957799.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 12:30:08 +0000
References: <20211123012447.841500-1-kuba@kernel.org>
In-Reply-To: <20211123012447.841500-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        atenart@kernel.org, aroulin@cumulusnetworks.com, roopa@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 17:24:47 -0800 you wrote:
> .ndo_change_proto_down was added seemingly to enable out-of-tree
> implementations. Over 2.5yrs later we still have no real users
> upstream. Hardwire the generic implementation for now, we can
> revert once real users materialize. (rocker is a test vehicle,
> not a user.)
> 
> We need to drop the optimization on the sysfs side, because
> unlike ndos priv_flags will be changed at runtime, so we'd
> need READ_ONCE/WRITE_ONCE everywhere..
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: remove .ndo_change_proto_down
    https://git.kernel.org/netdev/net-next/c/2106efda785b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


