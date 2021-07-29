Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099B03DA1FA
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 13:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhG2LUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 07:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:43094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234105AbhG2LUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 07:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 65D0160F12;
        Thu, 29 Jul 2021 11:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627557606;
        bh=GUGqJc4hkT9HgOAzvCdYhvXfV8NepdHOO2EMVcpD7XA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g3vSY/yQX5hm7uHp4se7if7W+3xCDJJM19Km6u/OteQixGFLfW8bhVjaPiO4FLh84
         5A9TpPfwtsg6a9oyUd0bMjp+yYY8llG3pow5kAQPXM0OrL1sdRQgFy0HDqMtUZOz2X
         eJqMeKijA49lBDp+aIBoMrFNlFsDovrVBd3yUHiZTpaNX8iM9pqbs/AtghdUqaiQaB
         t8AOt72Vi+qxG5SIRL9Sc4cLkkgnAh/zKc/IsuiFmG2OR4zByizhPkAUwEM6qKxshA
         E0vEmke4SyIbbvzFcCz0jCOT8t/q+8u8ZGwbYKVLKsjN3q3FtZ6b8ldb8q4v/c/6fQ
         yQbRNlvEgk/dg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5A02E60A7B;
        Thu, 29 Jul 2021 11:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] sk_buff: optimize GRO for the common case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162755760636.22479.11591702770264272098.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 11:20:06 +0000
References: <cover.1627405778.git.pabeni@redhat.com>
In-Reply-To: <cover.1627405778.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 18:23:58 +0200 you wrote:
> This is a trimmed down revision of "sk_buff: optimize layout for GRO",
> specifically dropping the changes to the sk_buff layout[1].
> 
> This series tries to accomplish 2 goals:
> - optimize the GRO stage for the most common scenario, avoiding a bunch
>   of conditional and some more code
> - let owned skbs entering the GRO engine, allowing backpressure in the
>   veth GRO forward path.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] sk_buff: introduce 'slow_gro' flags
    https://git.kernel.org/netdev/net-next/c/5fc88f93edf2
  - [net-next,2/6] sk_buff: track dst status in slow_gro
    https://git.kernel.org/netdev/net-next/c/8a886b142bd0
  - [net-next,3/6] sk_buff: track extension status in slow_gro
    https://git.kernel.org/netdev/net-next/c/b0999f385ac3
  - [net-next,4/6] net: optimize GRO for the common case.
    https://git.kernel.org/netdev/net-next/c/9efb4b5baf6c
  - [net-next,5/6] skbuff: allow 'slow_gro' for skb carring sock reference
    https://git.kernel.org/netdev/net-next/c/5e10da5385d2
  - [net-next,6/6] veth: use skb_prepare_for_gro()
    https://git.kernel.org/netdev/net-next/c/d504fff0d14a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


