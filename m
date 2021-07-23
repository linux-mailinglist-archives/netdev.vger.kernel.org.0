Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F193D3C9C
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbhGWPAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:00:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235765AbhGWO7a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 10:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A75260EBD;
        Fri, 23 Jul 2021 15:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627054804;
        bh=R0L44uAf9kXc1MarPTVvuXq4z9Tihu/b/+LCxWdIKLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qLUpCbHfmyqDkKQM4kBYqCNbmMGXz7JYRyGX+9KncUpDKx6MTfgXC0bNydkyWrpvQ
         vMwfMFjKTOYRF7UpNLdw9pJhwg9n0UFhHrTQG/HF0VLsYIEkP/yeWkyFfZ7djTs9m9
         iu38/tpLKdi35UHcpWsE5InBW69ZXFUAmUX53NwBrK3Y2C7rNP22T1n4iVXK3kqhXu
         +NsLtpbZHj1qV9AGv3KfHHBQ51DE09pnm2L9MC/q3uW+/F5Z1limy9FPnjzFW3N6oQ
         1MEXJnSdeaAqKzleiKBbxXROpblM84Hgp2JmxwA+CyOdSkWxW9jB6a31kSIhtCqevy
         occkHVuowjobw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1E0A060972;
        Fri, 23 Jul 2021 15:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: fix implicit-connect for SYN+
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705480411.17668.14638810207586161441.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 15:40:04 +0000
References: <9f7076d5dd455e26df404b917bfe99f301c0eb72.1626969941.git.lucien.xin@gmail.com>
In-Reply-To: <9f7076d5dd455e26df404b917bfe99f301c0eb72.1626969941.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-sctp@vger.kernel.org,
        jmaloy@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 22 Jul 2021 12:05:41 -0400 you wrote:
> For implicit-connect, when it's either SYN- or SYN+, an ACK should
> be sent back to the client immediately. It's not appropriate for
> the client to enter established state only after receiving data
> from the server.
> 
> On client side, after the SYN is sent out, tipc_wait_for_connect()
> should be called to wait for the ACK if timeout is set.
> 
> [...]

Here is the summary with links:
  - [net] tipc: fix implicit-connect for SYN+
    https://git.kernel.org/netdev/net/c/f8dd60de1948

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


