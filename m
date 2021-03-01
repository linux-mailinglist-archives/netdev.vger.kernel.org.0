Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8632A2BD
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377834AbhCBIaD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:30:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:36012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233014AbhCAX4G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Mar 2021 18:56:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BA2266024A;
        Mon,  1 Mar 2021 23:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614642877;
        bh=VaJUCfJshr2TV7JIzi8XgeXjLG+Yl1Qt0mqYdZeYxYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IbHJID61sfpZZ0ApD2LHSJnNgJRq31JY9JtJwoG5JfrM4X9wMlg9QwChITa9hR1G8
         mtCeKWxLr6DQnto+71tTeYxcOWtL42ha9wa7PYAIbDAPjDxnhZ67MqUULYQfHE2WmU
         JJNq3Oq9Xo6iPUfbqdVLYqK0ts5SHIjEZieXNbopr8+41Hu3yQwmSRw1o2DEngXmL3
         d4GHNHVTWyJST4dyRt8VbZxyCkN+OJofE+GQzwbePdRNNhhGMZUlwAL2rA5Dp1l6V3
         csvgOXOWk9CiIYOUkuktu5Uy2eB3oikqCzB5TcB8mMMUi+cFcJ85x3gJKYkoRW+8a4
         VU3Ol/bMzEKvg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AB0B36095D;
        Mon,  1 Mar 2021 23:54:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: expand textsearch ts_state to fit skb_seq_state
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161464287769.7970.10502622383678977032.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Mar 2021 23:54:37 +0000
References: <20210301150944.138500-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210301150944.138500-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        willemb@google.com, bugs-a17@moonlit-rail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Mar 2021 15:09:44 +0000 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The referenced commit expands the skb_seq_state used by
> skb_find_text with a 4B frag_off field, growing it to 48B.
> 
> This exceeds container ts_state->cb, causing a stack corruption:
> 
> [...]

Here is the summary with links:
  - [net] net: expand textsearch ts_state to fit skb_seq_state
    https://git.kernel.org/netdev/net/c/b228c9b05876

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


