Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02D8420AC7
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233240AbhJDMWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:22:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233120AbhJDMV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7BB4E6124C;
        Mon,  4 Oct 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633350010;
        bh=NbCZTNC0/9WGeIBJ1x/1JmU0MmUSnrL8M9qSDIJ/XhY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P5izihv7TNVKlNlzQahS6zzzr4bJbwVK2It7ci7hhs0qgzKsWYJ7ND8ndYtN/E6D4
         KqzGspMaZ0XI8azYVZBvlEznf1dmpDkIw1Hr5YHWqbhPGCEqobXVNnO58GxR0WP9pv
         u7fP2/OPZHL9vJI67ly8O9Dql+9h2zh5RWNGL96SY6lE6v7JbNrCfFY96N3p4Ak3Hj
         EJYCyScTvuWol1AWz1yo7lUaJBRbe6/B9RqepDT61GirTXgToRjtFOPOGgwE+8hewt
         76fFnAjqQrSSmzEXFG67n6ZreQFvIRmATq/eOu3ZR4D/oqYZ7rtHQdnWo4+LnIpBXx
         CfV+hVPhsMn0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6F97060A02;
        Mon,  4 Oct 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] Support for the ip6ip6 encapsulation of IOAM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163335001045.30570.12527451523558030753.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Oct 2021 12:20:10 +0000
References: <20211003184539.23629-1-justin.iurman@uliege.be>
In-Reply-To: <20211003184539.23629-1-justin.iurman@uliege.be>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun,  3 Oct 2021 20:45:35 +0200 you wrote:
> v2:
>  - add prerequisite patches
>  - keep uapi backwards compatible by adding two new attributes
>  - add more comments to document the ioam6_iptunnel uapi
> 
> In the current implementation, IOAM can only be inserted directly (i.e., only
> inside packets generated locally) by default, to be compliant with RFC8200.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] ipv6: ioam: Distinguish input and output for hop-limit
    https://git.kernel.org/netdev/net-next/c/52d03786459a
  - [net-next,v2,2/4] ipv6: ioam: Prerequisite patch for ioam6_iptunnel
    https://git.kernel.org/netdev/net-next/c/7b34e449e05e
  - [net-next,v2,3/4] ipv6: ioam: Add support for the ip6ip6 encapsulation
    https://git.kernel.org/netdev/net-next/c/8cb3bf8bff3c
  - [net-next,v2,4/4] selftests: net: Test for the IOAM encapsulation with IPv6
    https://git.kernel.org/netdev/net-next/c/bf77b1400a56

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


