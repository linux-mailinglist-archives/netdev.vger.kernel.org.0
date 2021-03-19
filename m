Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933D934287B
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 23:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhCSWKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 18:10:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:50286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230281AbhCSWKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 18:10:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 94AF961976;
        Fri, 19 Mar 2021 22:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616191807;
        bh=8Rm8nUcbM7kjratMz5f7l43695kFr5pLKDKp+ifX8UM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PN9EzQfTDBWpVIBXDi/uprftc7AvzPgH5sB0GDZzznb084sTE77mZC2M1JMDc/g2e
         6nCtcwNDCzEFvIWXkG1c/uv2x5Gx+e31dVZI5exfAai+ZP4AT/TOOQgxLlafwH0OAE
         iIrXzVe9iuFOUPFYidtDOXVJ+nNdbOAl7QxgF2DHyj7s+VGQ/dLMqEVep5MpKt+AZ4
         rFkivp9jOW1utJ99RGiT1MUZ8hLDNIMOSap2JwPRD2Bp2lRqYUycg1W4X5h+8XTJzc
         sM+ngJHXi/1eK8iCldvKqvzA3erw/8XYc7jVjUhsg4S19m18/jbEMpk183zGXbDFJG
         270v2nlCXlcyQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8260460A0B;
        Fri, 19 Mar 2021 22:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Remove insn_buf[] declaration in inner block
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161619180752.8344.17156572958677826281.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 22:10:07 +0000
References: <20210318024851.49693-1-Jianlin.Lv@arm.com>
In-Reply-To: <20210318024851.49693-1-Jianlin.Lv@arm.com>
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        iecedge@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 18 Mar 2021 10:48:51 +0800 you wrote:
> Two insn_buf[16] variables are declared in the function, which act on
> function scope and block scope respectively.
> The statement in the inner blocks is redundant, so remove it.
> 
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> ---
>  kernel/bpf/verifier.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [bpf-next] bpf: Remove insn_buf[] declaration in inner block
    https://git.kernel.org/bpf/bpf-next/c/9ef05281e5d0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


