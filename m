Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A360D3AF5C3
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbhFUTCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:02:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231126AbhFUTCS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:02:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B54BF610C7;
        Mon, 21 Jun 2021 19:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624302003;
        bh=5ht+lxJxVJ9UBtJ3v90AnFYiHypPauv2wBcRxrQ4w1Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ub+arac7OjwsS/oTxyNRL1mwiJjy7cCw915RpkSaUVTdm9s4adfw/j5ZW02SVObj3
         a6leekOK9ko9UOSw6jqrF1FycJLi9WFWNwL4NNFGFUZfFifeUmaVmBGsizaAkctUTV
         Srqkf6WZR9c+lHbR5mpKGJZQaRZCUnN+jU0bRnB3JNpV6VqoBUymYAvJj7R8mccLR8
         EPfI4H8Oa7tcg4k9eziYP5+m3Qx2mbaTChzQGMv6Kh4JemowfdRj2exlSv8lGL+THg
         qrCqyaNXft2NhPGn9WIkSA7jh4qjTTFzAJIfTGZccxTbXoV68dwKNL/0IKg44Tp+dh
         dnhP18q4m6/3A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A826F609AC;
        Mon, 21 Jun 2021 19:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vrf: do not push non-ND strict packets with a source LLA
 through packet taps again
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430200368.28611.1289742615939222752.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:00:03 +0000
References: <20210618151553.59456-1-atenart@kernel.org>
In-Reply-To: <20210618151553.59456-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org, ssuryaextr@gmail.com, pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 17:15:53 +0200 you wrote:
> Non-ND strict packets with a source LLA go through the packet taps
> again, while non-ND strict packets with other source addresses do not,
> and we can see a clone of those packets on the vrf interface (we should
> not). This is due to a series of changes:
> 
> Commit 6f12fa775530[1] made non-ND strict packets not being pushed again
> in the packet taps. This changed with commit 205704c618af[2] for those
> packets having a source LLA, as they need a lookup with the orig_iif.
> 
> [...]

Here is the summary with links:
  - [net] vrf: do not push non-ND strict packets with a source LLA through packet taps again
    https://git.kernel.org/netdev/net/c/603113c514e9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


