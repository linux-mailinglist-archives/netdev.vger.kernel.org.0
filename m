Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1703A34F26A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbhC3Uu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:50:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231701AbhC3UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1191C619C5;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617137411;
        bh=kORNIc1tI+gi+cv82ihiD0jLlqKIzA5GZx2PzCWxHFE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nR+scLRV7EjBVeAbGajlvRclun6tsNdR4l/N/7RN3OiP/Fck9MP+GayEQv+dEj6Tm
         bX5QQIo7VV5THP+NRq6gGbR9PrhkQ4mjjlCJn4ajehRbuRGZ6KrUxtjWEcYsMAwca7
         GO7p2WJYtUVX0/1zFoLXzWf1h50A6ZQnHTi9YpJ9s+FUW7zpVVPLsvHX52/E9uyDZ0
         oZIJjr11lDAxHbA0X6I+D5sUfkjakF8Rd2+yHF+nnP8qisK3pUtvMoQQboOkr9W7SY
         B1p19xVcjd0qGdKdOV8DPXVzvRYM+iBIMovNbBgz8W+VZXlMRE8ezagh+onzOGjSfZ
         DBg6W8qhBHhYQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BA4D60A5B;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next V6 0/6] add support for RFC 8335 PROBE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713741104.14455.1689704495568353043.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:50:11 +0000
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 18:45:04 -0700 you wrote:
> The popular utility ping has several severe limitations, such as the
> inability to query specific interfaces on a node and requiring
> bidirectional connectivity between the probing and probed interfaces.
> RFC 8335 attempts to solve these limitations by creating the new utility
> PROBE which is a specialized ICMP message that makes use of the ICMP
> Extension Structure outlined in RFC 4884.
> 
> [...]

Here is the summary with links:
  - [net-next,V6,1/6] icmp: add support for RFC 8335 PROBE
    https://git.kernel.org/netdev/net-next/c/2b246b2569cd
  - [net-next,V6,2/6] ICMPV6: add support for RFC 8335 PROBE
    https://git.kernel.org/netdev/net-next/c/750f4fc2a12f
  - [net-next,V6,3/6] net: add sysctl for enabling RFC 8335 PROBE messages
    https://git.kernel.org/netdev/net-next/c/f1b8fa9fa586
  - [net-next,V6,4/6] net: add support for sending RFC 8335 PROBE messages
    https://git.kernel.org/netdev/net-next/c/08baf54f01f5
  - [net-next,V6,5/6] ipv6: add ipv6_dev_find to stubs
    https://git.kernel.org/netdev/net-next/c/504a40113cc4
  - [net-next,V6,6/6] icmp: add response to RFC 8335 PROBE messages
    https://git.kernel.org/netdev/net-next/c/d329ea5bd884

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


