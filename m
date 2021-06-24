Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9944F3B376A
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhFXTw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:52:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:38576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232797AbhFXTwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 15:52:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 234956135C;
        Thu, 24 Jun 2021 19:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624564204;
        bh=bTB8r1HAIn7hdi046kFfZ2cR7cNC0MBy75g+y2OpkkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eoTcXiY95rdRUGqL5YDaoOJtixnwnkUWoHMc06/JHN2nBbEs8P18Tjr9RgaIyPkYw
         Gufai8oC+PQFVFRUWIXEhNenjttITbFiqFG5RtokqbV7s2TsuSkGt+h/PS9Z77fXZz
         50Sa8WquGIMtcEjBsnckZDL/So5xaBS4BuQGzXbiqEBBKFX0++CpeL3Qx+RLqUUuOt
         0NfGuj1S/hOfhF+T4DduHLO7bJ5FhSi97I2qfJRZOy0Omm/cf/J0fs9yxGquLB0D0V
         mKtuWAwMReENK7vRKltjz+Y4nL343DjyCvsgevcP4L8gtTQbPowEQU4QaCqfNUZDU8
         BW8WdVP9R0Wcg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1149D60978;
        Thu, 24 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] ipv6: fix out-of-bound access in ip6_parse_tlv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162456420406.10881.12824127599134062597.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 19:50:04 +0000
References: <20210624100720.2310271-1-eric.dumazet@gmail.com>
In-Reply-To: <20210624100720.2310271-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com, tom@herbertland.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 24 Jun 2021 03:07:20 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First problem is that optlen is fetched without checking
> there is more than one byte to parse.
> 
> Fix this by taking care of IPV6_TLV_PAD1 before
> fetching optlen (under appropriate sanity checks against len)
> 
> [...]

Here is the summary with links:
  - [v2,net] ipv6: fix out-of-bound access in ip6_parse_tlv()
    https://git.kernel.org/netdev/net/c/624085a31c1a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


