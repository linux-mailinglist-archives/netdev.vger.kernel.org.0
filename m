Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3E41DAE2
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350988AbhI3NVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348765AbhI3NVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 09:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D654619E5;
        Thu, 30 Sep 2021 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633008010;
        bh=/Heyy/1HnZaK+qp4uwWckO1u3v+fdHR68DdhP5+lgxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QgalYUELezYcC/Zm5qqvYlYm2lZe4ItVCu2BYNkV53zekXgHTcADFr3ZX+MoYxfa7
         2pVyX0i4sSVqRq2/yIFYHIbL/5W2CGpOi0jpGM8IonEx80QKCL7+CA9IxfBq/i9hRu
         1U1BPWppUTfWznIw1RTsPRvBHgdwBIE107KOiU8wPCIhPUD/IoRV3IZwiYq8QiJCxo
         9oilMV9XQYOhVBsLv0i5/UVvrCgqmtiK1FBDeMBlf345Z3/8cVD4Oto4HrnKIFCqWs
         94eKmiTW+7aSqgHUE1WPyL3ER/EbgZtpnCNq6wR4vXOykF8G3HwkhjZjnJT7j9Zplt
         9q4bBrFe7LUnw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 079B760A3C;
        Thu, 30 Sep 2021 13:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: snmp: minor optimizations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300801002.14372.16920403544921536422.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 13:20:10 +0000
References: <20210930010333.2625706-1-eric.dumazet@gmail.com>
In-Reply-To: <20210930010333.2625706-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 29 Sep 2021 18:03:31 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Fetching many SNMP counters on hosts with large number of cpus
> takes a lot of time. mptcp still uses the old non-batched
> fashion which is not cache friendly.
> 
> Eric Dumazet (2):
>   net: snmp: inline snmp_get_cpu_field()
>   mptcp: use batch snmp operations in mptcp_seq_show()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: snmp: inline snmp_get_cpu_field()
    https://git.kernel.org/netdev/net-next/c/59f09ae8fac4
  - [net-next,2/2] mptcp: use batch snmp operations in mptcp_seq_show()
    https://git.kernel.org/netdev/net-next/c/acbd0c814413

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


