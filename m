Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7480B3BDF68
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 00:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhGFWcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 18:32:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229787AbhGFWcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 18:32:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C35F461CA8;
        Tue,  6 Jul 2021 22:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625610604;
        bh=CU8Dj3VyUGSl5NGdLRBX15hC55n5PtB6hA4SyQprjRk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mWoPYPTcrKgghYLdhXUh1gLTKtYaNxe9FyrYH2+Fz7KLSFz01skRyJeLeGY8uUglk
         fyw9QRNLl3OxY/rNYNFiysnN12u7SW5Y00tUQzuvuGj4ZRfh8FeEDQFtfFoJ9KuHRa
         vo2BLfbNLGxfn4VSNXLOGXsgkADm4Lwg2NqX+n8m9nrKHwGdMZUVhZmb3PDpUaC01V
         4AgnsnOo2PScO/qjmbbKWv1QaQwCDT8QKdT7wQd1Y8ZAYYIbDltpAUM1c3a10hm8bA
         B+aLl1+6c9CNhRL2UaO/Rj/d3XtOoyWDSzOG1o30oyr9T7Tj5PQOKr33QnBOtJPKWZ
         M7T/qdz+Tv/qg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0BEE60C09;
        Tue,  6 Jul 2021 22:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: fix 'disable_policy' for fwd packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162561060471.6207.591258543864975321.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Jul 2021 22:30:04 +0000
References: <20210706091335.30103-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20210706091335.30103-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, steffen.klassert@secunet.com,
        netdev@vger.kernel.org, dforster@brocade.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  6 Jul 2021 11:13:35 +0200 you wrote:
> The goal of commit df789fe75206 ("ipv6: Provide ipv6 version of
> "disable_policy" sysctl") was to have the disable_policy from ipv4
> available on ipv6.
> However, it's not exactly the same mechanism. On IPv4, all packets coming
> from an interface, which has disable_policy set, bypass the policy check.
> For ipv6, this is done only for local packets, ie for packets destinated to
> an address configured on the incoming interface.
> 
> [...]

Here is the summary with links:
  - [net] ipv6: fix 'disable_policy' for fwd packets
    https://git.kernel.org/netdev/net/c/ccd27f05ae7b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


