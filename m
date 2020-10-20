Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7E3294513
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 00:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439046AbgJTWUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 18:20:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392360AbgJTWUE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 18:20:04 -0400
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603232403;
        bh=EJ0M7bh6oJZ7EAjm3izxYhwyEePM7/0lKZB4QgXeJrA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cdvw4dHOH0SAR9J6j1v21NSm7a4E6f6q62R48kfyElaeCBIjp2PzunU237Ipshi1c
         goxCW05hNzW8bfK/stNEZupglTAfHnbCOMMNclYEwhzhzYeN4DPDrLgewrc5ODXDmI
         h81kTCuABnz+GdMFICReZZhw/Qc3ksvea8Pea9/M=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] bpf,
 doc: Fix patchwork URL to point to kernel.org instance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160323240376.13977.12203769623093980540.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Oct 2020 22:20:03 +0000
References: <f73ae01c7e6f9cf0a3890f2ca988a8e69190c50b.1603223852.git.daniel@iogearbox.net>
In-Reply-To: <f73ae01c7e6f9cf0a3890f2ca988a8e69190c50b.1603223852.git.daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     ast@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Tue, 20 Oct 2020 21:59:55 +0200 you wrote:
> Follow-up on ebb034b15bfa ("bpf: Migrate from patchwork.ozlabs.org
> to patchwork.kernel.org.") in order to fix up the patchwork URL (Q)
> in the MAINTAINERS file for BPF subsystem.
> 
> While at it, also add the official website (W) entry.
> 
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> 
> [...]

Here is the summary with links:
  - [bpf] bpf, doc: Fix patchwork URL to point to kernel.org instance
    https://git.kernel.org/bpf/bpf/c/c5eb48e89286

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


