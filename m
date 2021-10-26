Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1A643B2AD
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236050AbhJZMwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231365AbhJZMwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 08:52:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 23A7D60FD7;
        Tue, 26 Oct 2021 12:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635252607;
        bh=CfzKjBilMxy0fD05/N+NiDZwY3u3XB7a+ywe/A9oFLA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uK+pj6h4ApHE8uHQSeV2+iF6WwQ45q3j63izjO6JCFRloUZVQCTdTCuun2EILL2PH
         AKYMzxyTADL2BV0W2BmegR+nTBDJEksQYuDJzX7OsmJXzs9V3ArjPYlmao2ZnyrWb0
         WtQ/2PNaG65gaUwgZIsri+gyh58cI021qqOsw6L7haUFimUOgsTkQpAank3DcVaBA/
         kZA8bdyNlvqU7VTzusUoZ7y/x5G29d9QkvVbK5+HFJRsrBYZbPxYncxQ7kDI2X0AGw
         R5GExoxnBhD89+zVTqxDQJLhAOlza28D3Jo6nsliW3hBQBK/U40rKp9xEHst2qwXCZ
         ysClcmNxpPZLQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18132608FE;
        Tue, 26 Oct 2021 12:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] tipc: fix size validations for the MSG_CRYPTO type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525260709.9181.15451570324245661940.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 12:50:07 +0000
References: <YXbN6S9KPq8S5N0v@kroah.com>
In-Reply-To: <YXbN6S9KPq8S5N0v@kroah.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, jmaloy@redhat.com, kuba@kernel.org,
        davem@davemloft.net, tuong.t.lien@dektech.com.au,
        maxv@sentinelone.com, ying.xue@windriver.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 17:31:53 +0200 you wrote:
> From: Max VA <maxv@sentinelone.com>
> 
> The function tipc_crypto_key_rcv is used to parse MSG_CRYPTO messages
> to receive keys from other nodes in the cluster in order to decrypt any
> further messages from them.
> This patch verifies that any supplied sizes in the message body are
> valid for the received message.
> 
> [...]

Here is the summary with links:
  - tipc: fix size validations for the MSG_CRYPTO type
    https://git.kernel.org/netdev/net/c/fa40d9734a57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


