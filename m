Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB9B23E9B2F
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 01:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232813AbhHKXUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 19:20:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:43358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232725AbhHKXUa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 19:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 42A5C6104F;
        Wed, 11 Aug 2021 23:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628724006;
        bh=cg5H0FupjxOtpcBwlU1+ZdjEWrlaLb0Oos0u4f3UlsU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fSnNepY3W72nXN59fx4TUPOIv6HkRGNfjwEkIYFNshRhQxQwznWIng5YzFoDABxAS
         VXeDPZ60en4rntVte5ajiWDPBmNma8e52+raOFcMYWagLAG0cmSvBeHIg4V6sPnHI7
         5k6000qn98hpQTIewIpvB/VuK+HY/KwWRZiYegoPn1ilccvKctNqBmDbag+WQcEFIc
         xxBhItYLNB09JKjx48hftzOMIWDeaNa0CW2BphF6pau01GAfut4XIidExH1zhJ5PeU
         jmVsDAiBcWq1ECAvM83cTd7bGVIQ5ThQTLSxj/ecIOdSQ5Ck7efHlMcvJSDZZNf+G7
         gmmdCYreNmxCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37B1D60A69;
        Wed, 11 Aug 2021 23:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] mctp: Specify route types,
 require rtm_type in RTM_*ROUTE messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162872400622.25017.5734796664787607896.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 23:20:06 +0000
References: <20210810023834.2231088-1-jk@codeconstruct.com.au>
In-Reply-To: <20210810023834.2231088-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 10:38:34 +0800 you wrote:
> This change adds a 'type' attribute to routes, which can be parsed from
> a RTM_NEWROUTE message. This will help to distinguish local vs. peer
> routes in a future change.
> 
> This means userspace will need to set a correct rtm_type in RTM_NEWROUTE
> and RTM_DELROUTE messages; we currently only accept RTN_UNICAST.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] mctp: Specify route types, require rtm_type in RTM_*ROUTE messages
    https://git.kernel.org/netdev/net-next/c/83f0a0b7285b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


