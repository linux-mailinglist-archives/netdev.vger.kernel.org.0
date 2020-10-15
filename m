Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5052828F939
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgJOTKE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727152AbgJOTKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:10:03 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602789003;
        bh=sj3HyIcKIgtG7lgmfDbWXebS3FQOZamkxyPH6dtjLHo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PeY7Y0CUd5BmkeSg7JGXaCyaGEqE7qMk1zG5FjmazyhCEKjM3RZOzES0rn4WgOBcQ
         R5MF/E1aXqYR4gYrnZoO3VRo3Uxlqky+yLx3ozCavqjNKsxdxYILhA4X/LOeVG6+AY
         jpAbUMRS47ZlfoohJzyXLrKJehAQbHIjA6oBABso=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sockmap: Don't call bpf_prog_put() on NULL pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160278900298.4062.17082299733897692954.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Oct 2020 19:10:02 +0000
References: <20201012170952.60750-1-alex.dewar90@gmail.com>
In-Reply-To: <20201012170952.60750-1-alex.dewar90@gmail.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        kpsingh@chromium.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 12 Oct 2020 18:09:53 +0100 you wrote:
> If bpf_prog_inc_not_zero() fails for skb_parser, then bpf_prog_put() is
> called unconditionally on skb_verdict, even though it may be NULL. Fix
> and tidy up error path.
> 
> Addresses-Coverity-ID: 1497799: Null pointer dereferences (FORWARD_NULL)
> Fixes: 743df8b7749f ("bpf, sockmap: Check skb_verdict and skb_parser programs explicitly")
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: sockmap: Don't call bpf_prog_put() on NULL pointer
    https://git.kernel.org/bpf/bpf-next/c/83c11c17553c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


