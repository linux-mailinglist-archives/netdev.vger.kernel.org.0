Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 748143CC53E
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 20:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbhGQSXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 14:23:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233429AbhGQSXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Jul 2021 14:23:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B915C61154;
        Sat, 17 Jul 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626546004;
        bh=XhL/ZEmIp6HW3fUyelCUSaQWBT83AU7vCHNhyjlt/bc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WgJIM9PGoVgrezie2yyxK85XqxRgtHtawfZYwr6/2aECRIWA4o1KKTIwSqwVBzWiI
         ZtryJQ0reLHSDdvxs3Z6D3TTUkB39ZP/rKD1Un3jfhxdQ9+1DvyNXa7CPoESJDDHdB
         KhXAzhIZOGeFMxPtx0UzL6cgtvIS+encJB0/EvXjj4JJG941YIt08oP5mimd+7+/2S
         IY6+P26tfBLeO3ArmoVTl5wiDoEoPHhEL3pi5mjTqBHFjuUXcmfRgmTVh3m3G/irza
         RkWVFgkajG/1U3fig8ksYhsnXlZjSj+UzNVVXhdforx2ssynRO1BvnVtCUhXpC1Kp9
         Eedw/jHTF3m3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ABC5C609EF;
        Sat, 17 Jul 2021 18:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 1/1] police: Fix normal output back to what it was
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162654600469.8766.13825773690430757971.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Jul 2021 18:20:04 +0000
References: <20210712122653.100652-1-roid@nvidia.com>
In-Reply-To: <20210712122653.100652-1-roid@nvidia.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, liuhangbin@gmail.com,
        paulb@nvidia.com, dcaratti@redhat.com, jhs@mojatatu.com,
        mrv@mojatatu.com, baowen.zheng@corigine.com,
        stephen@networkplumber.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (refs/heads/main):

On Mon, 12 Jul 2021 15:26:53 +0300 you wrote:
> With the json support fix the normal output was
> changed. set it back to what it was.
> Print overhead with print_size().
> Print newline before ref.
> 
> Fixes: 0d5cf51e0d6c ("police: Add support for json output")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [iproute2,1/1] police: Fix normal output back to what it was
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=71d36000dc9c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


