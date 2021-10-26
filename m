Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385CA43B3A7
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236410AbhJZOMc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:12:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236406AbhJZOMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:12:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6989C6109D;
        Tue, 26 Oct 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635257408;
        bh=8NcNksYS5/cw1V+wgtp2PQgW8I4ClQk++U3ITa9apVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NxsLZhXn+L+J3ZBysVU6Cp5tz2mifW0+G+OphBxX2q24egx3aYYo9kvaZy1KL85Nq
         0JaxkKjTbgXuGtU+ubJutzlrU5BPZJouf1BnwXX8V+38BHRhahxqKpzUKXk10lCAB/
         hrmr9SKvrzU5q2c3JC7Cp2pzrXLe5ucvAqH1p1MqUvzJtUXj0hFeLUZwt/0Z5fB2kU
         OXvjdGaTBnXUz4MEuY+OjWWv851zxTY7UJccthbOjWo9ZU8IpR+WPWxhYfH0IGv00b
         q53P4tzK5czJYWYDGl0AUhyrpqhcwx6aFa/3rkVNhJehLZoMJRcjNnWfuDH6Vmi9ls
         bghY8t5YZqj0Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 54565609CD;
        Tue, 26 Oct 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6] mctp: Implement extended addressing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525740834.12899.12865735318870217199.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:10:08 +0000
References: <20211026015728.3006286-1-jk@codeconstruct.com.au>
In-Reply-To: <20211026015728.3006286-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matt@codeconstruct.com.au, esyr@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 09:57:28 +0800 you wrote:
> This change allows an extended address struct - struct sockaddr_mctp_ext
> - to be passed to sendmsg/recvmsg. This allows userspace to specify
> output ifindex and physical address information (for sendmsg) or receive
> the input ifindex/physaddr for incoming messages (for recvmsg). This is
> typically used by userspace for MCTP address discovery and assignment
> operations.
> 
> [...]

Here is the summary with links:
  - [net-next,v6] mctp: Implement extended addressing
    https://git.kernel.org/netdev/net-next/c/99ce45d5e7db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


