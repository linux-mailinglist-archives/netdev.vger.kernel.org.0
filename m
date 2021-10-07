Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD128425CC5
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241890AbhJGUCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:02:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241477AbhJGUCB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 16:02:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 665246112D;
        Thu,  7 Oct 2021 20:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633636807;
        bh=vBf7O5HaMg+yen9rxsqNpu/kJW27dU+jgbD/U9q/aRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kQOWpKiGswLw12/2lywgoHEz3UDSVJVgyyjAKFFKOrTOu15BVU8Ew8yGG78yXwi8A
         M19ETubmSadYjMIBPkN0n3dlMUcIkfDaQEP06sEIqhJ3jJgcSBTW/s9mamkM0N0T5n
         IrbQRV3kKDSzBMLkKya4ZWkfGyQdkTVUn4Ly8iErSLh6rOoLOZ9xcc2+5syBK5b+6f
         C3wqs0ypbJWnZP7WSh5yE2ZQoOfzJE26RIL7xbP/SQ7/TQtmIOuXAaD7ddm+1vgivW
         4rnr4JtnXPpI+Z/lYjAzpDhpnUAXY56ocrsJDUACgoO+Fuu3aN3i1nuuBPQOSGUoqk
         AvTUFjFYog9Ww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5B63760A54;
        Thu,  7 Oct 2021 20:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] mips, bpf: Optimize loading of 64-bit constants
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163363680737.2891.16781139212094319162.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 20:00:07 +0000
References: <20211007142828.634182-1-johan.almbladh@anyfinetworks.com>
In-Reply-To: <20211007142828.634182-1-johan.almbladh@anyfinetworks.com>
To:     Johan Almbladh <johan.almbladh@anyfinetworks.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        paulburton@kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        tony.ambardar@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  7 Oct 2021 16:28:28 +0200 you wrote:
> This patch shaves off a few instructions when loading sparse 64-bit
> constants to register. The change is covered by additional tests in
> lib/test_bpf.c.
> 
> Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
> ---
>  arch/mips/net/bpf_jit_comp64.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] mips, bpf: Optimize loading of 64-bit constants
    https://git.kernel.org/bpf/bpf-next/c/612ff31f7672

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


