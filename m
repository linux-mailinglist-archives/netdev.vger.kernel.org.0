Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84E0A37EE93
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240364AbhELVxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237787AbhELVLl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:11:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CACB561430;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620853810;
        bh=mzdx41xWb1EHQvvOP6qVAugk5Gc2sjUvA1qzPge9WLM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XPhEmMpgEf4gkBOKZtTC4VW3dFQWb4+E8xYYBh5LIUZ1DHDZymfF0+TmtOBUSBqmc
         lMoUae7mciaxVwmkvPbLAo7zK/0fKDtHGYe7HNEkJjtiZXU5g6Uag25ftDklcjySWK
         PFyiLgVeSWaZKEhJ+zFftR9c0qG/ILZI6xJNq4Y2ulebhrBWm94THQnm20d9byzeLY
         i4FAAdOuauIQ3oa4b9Fc7mH8jJnUviJwcTQI/KIADQ6QZLqqDVmP0cvCuSMkJFCEdY
         vOobaGKZx6RTVY2OsjJ/FijqsLFYvfUOMli1G37e+rohn0LzodrrrEi3pN4pVGZsP+
         D95ez1RDuiVwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C1C7960A48;
        Wed, 12 May 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: packetmmap: fix only tx timestamp on request
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085381078.5514.17300159595073839467.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:10:10 +0000
References: <1620783082-28906-1-git-send-email-rsanger@wand.net.nz>
In-Reply-To: <1620783082-28906-1-git-send-email-rsanger@wand.net.nz>
To:     Richard Sanger <rsanger@wand.net.nz>
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net,
        willemdebruijn.kernel@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 13:31:22 +1200 you wrote:
> The packetmmap tx ring should only return timestamps if requested via
> setsockopt PACKET_TIMESTAMP, as documented. This allows compatibility
> with non-timestamp aware user-space code which checks
> tp_status == TP_STATUS_AVAILABLE; not expecting additional timestamp
> flags to be set in tp_status.
> 
> Fixes: b9c32fb27170 ("packet: if hw/sw ts enabled in rx/tx ring, report which ts we got")
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Signed-off-by: Richard Sanger <rsanger@wand.net.nz>
> 
> [...]

Here is the summary with links:
  - [v2] net: packetmmap: fix only tx timestamp on request
    https://git.kernel.org/netdev/net/c/171c3b151118

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


