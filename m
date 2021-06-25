Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADBE3B48B1
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbhFYSWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229531AbhFYSWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 14:22:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 649BE6195D;
        Fri, 25 Jun 2021 18:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624645203;
        bh=mkJy5WAgNQ/3r4VfL7w+yx56L7SkyPZn/IPbaHisLN8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=laizGJINOHfPB5JgwOHA1HazPl2jb7Nbbq93iYhRsBvggDEAMqr1+GstIhieSmu/I
         DtqEUFMbT44JpRIoeC/Fn1cELDw6qr6QDaUqfZRX3KQ6OfEF794nmrBA2K4rro2eCB
         yhPVu2efMv7AXdHhPJp6XaxWK/E+IE6WPfuHCxTeBBopkCb++YBSiDhMITOfLcBrfh
         +UdBXQHJAuHtOs01iLD0Z0P4GvaUyKcpKtfqPOoXbQhQS2XQkb4dHUSBfqWuC7gCDL
         d6J2D64PexV94ffjQ3wyP82aD3t0qLpMULfCpqoagySbP+i6Tt48N6y4cLB8hRnOMc
         CDR3ehTBJuk1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 59FCB60952;
        Fri, 25 Jun 2021 18:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dev_forward_skb: do not scrub skb mark within the same
 name space
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162464520336.18713.1117702842915043978.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Jun 2021 18:20:03 +0000
References: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20210624080505.21628-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 10:05:05 +0200 you wrote:
> The goal is to keep the mark during a bpf_redirect(), like it is done for
> legacy encapsulation / decapsulation, when there is no x-netns.
> This was initially done in commit 213dd74aee76 ("skbuff: Do not scrub skb
> mark within the same name space").
> 
> When the call to skb_scrub_packet() was added in dev_forward_skb() (commit
> 8b27f27797ca ("skb: allow skb_scrub_packet() to be used by tunnels")), the
> second argument (xnet) was set to true to force a call to skb_orphan(). At
> this time, the mark was always cleanned up by skb_scrub_packet(), whatever
> xnet value was.
> This call to skb_orphan() was removed later in commit
> 9c4c325252c5 ("skbuff: preserve sock reference when scrubbing the skb.").
> But this 'true' stayed here without any real reason.
> 
> [...]

Here is the summary with links:
  - [net] dev_forward_skb: do not scrub skb mark within the same name space
    https://git.kernel.org/netdev/net/c/ff70202b2d1a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


