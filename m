Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281F1362B36
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234989AbhDPWkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230489AbhDPWkg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:40:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EDE5C613B0;
        Fri, 16 Apr 2021 22:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618612811;
        bh=iouLfYlxjaIJk3q65ISTxssJ+dEjZO8R/ICpAgY3eic=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oxowdO8SQNn1pgVMcQFpfO2nyZwxMnk+XYov/t9tpEbbwco6HmyN+mMLtmNtuzyDq
         8QBtdc2Zl6dR7Gf0agH8pPf+uHY2BS1I1rOOmZT0zXRL1wN4kqibYOsK6fAkj/NgFT
         FbJmWn0ZyJtbKp6TwAoRqkixH46pUc+VhbamRtX85Al8Oqri+LwOVZo/Hmi7FMOoJi
         E1uioyc/n8Yr+YBxZKqvOLXGJV4s3ottsi4cQPYCBBtZjpzTd2FbOxk4RF97j2r10l
         vJ4Fhv4cocknvWifV6zltX9gIc0sXvQSc6wIaB67EXuyEX1+2xlc/c93te9DqwVnBi
         MM05GnIuAIoCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E022260CD6;
        Fri, 16 Apr 2021 22:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: mvpp2: Add parsing support for different
 IPv4 IHL values
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861281091.23739.14287826762066877912.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:40:10 +0000
References: <1618560917-31548-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1618560917-31548-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@kernel.org, lironh@marvell.com,
        danat@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 11:15:17 +0300 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Add parser entries for different IPv4 IHL values.
> Each entry will set the L4 header offset according to the IPv4 IHL field.
> L3 header offset will set during the parsing of the IPv4 protocol.
> 
> Because of missed parser support for IP header length > 20, RX IPv4 checksum HW offload fails
> and skb->ip_summed set to CHECKSUM_NONE(checksum done by Network stack).
> This patch adds RX IPv4 checksum HW offload capability for frames with IP header length > 20.
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: mvpp2: Add parsing support for different IPv4 IHL values
    https://git.kernel.org/netdev/net-next/c/4ad29b1a484e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


