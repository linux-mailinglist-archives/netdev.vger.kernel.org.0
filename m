Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93A7639AC30
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhFCVBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:01:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:46044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229881AbhFCVBt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:01:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A32A8613E7;
        Thu,  3 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754004;
        bh=i/DbtdEfdFtqSMKTTQ+lZ3rzdgh5gLDcyamoeO8l2Bo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gmc07TSyyr5ZijS3NkszwXlE8wz+qvEFowo3r0TOawxfeHX6wPbL5A/uDXatg7qTv
         XIfrC6Pup6BmrpX+1Xjx0z38HS2xLGMLxamPUKjzFlN1UPsv3cmfT82IbVj57Vj8Iu
         WGLUCfDhD8QOPqGTtgxYqhSL4DbMLq/EeXDJ04uWXAMHScqYHtfJmYuaQo3yz9g54X
         VK6D4W6wdCln5rpWxqfhIt9rt7aWBo71OQDN7r26DSd6irrqtq3gg/rq4AJcVCkium
         jjgqqNvMRYUur7GqHIn82NbP3u8nHMpEGFKolfQzamcp3l9UU+yC2XIz/bUhF4e5+h
         Y4GHcPucQQJ4A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95C3C60ACA;
        Thu,  3 Jun 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sit: set name of device back to struct parms
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275400460.32659.7229242985463910393.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:00:04 +0000
References: <20210602103626.26873-1-zhangkaiheb@126.com>
In-Reply-To: <20210602103626.26873-1-zhangkaiheb@126.com>
To:     zhang kai <zhangkaiheb@126.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  2 Jun 2021 18:36:26 +0800 you wrote:
> addrconf_set_sit_dstaddr will use parms->name.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/ipv6/sit.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - sit: set name of device back to struct parms
    https://git.kernel.org/netdev/net/c/261ba78cc364

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


