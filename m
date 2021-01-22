Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFAC301107
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 00:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbhAVXbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 18:31:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:46858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728221AbhAVXav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 18:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8F99623A03;
        Fri, 22 Jan 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611358209;
        bh=kvzL36zOa+p9axjtl2lZH42anCEs/BgeZ7+DYDnaL5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LWtOmb3kXth1Df0eOg4YwR2kR80URTk7LFnnPaHcnP32oCvJjC6SXLOvFHIBZAjLD
         SAOZb2fp2A2W9WN6iUIZ6IIh1ZCLJmcRPYEQMRorUMnykv/zTkBPMwhvMoiRkRembf
         cY4skbAxb+z8pEB1nMfYfcOybFuKmolJNlHoGrGb4VgdaqhCdDaIfJLWNsDFbSh1Vh
         /HVOD+Uj2Eg9nVLqpYs1Pam8/PGbn++ovQuOviwzRnLRuHF0anzlbbCZRr/cBvBKch
         N237DzD7rZVHBOH+iOpMwsKehKq/5+RVKPR940CtT1f68aEuatF3lq1km/voeZAoT4
         A5ufPlvefZ3Zw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7FEF7652D0;
        Fri, 22 Jan 2021 23:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: fix typo in scalar{,32}_min_max_rsh comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161135820951.8788.8675889908012402818.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jan 2021 23:30:09 +0000
References: <20210121174324.24127-1-tklauser@distanz.ch>
In-Reply-To: <20210121174324.24127-1-tklauser@distanz.ch>
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Thu, 21 Jan 2021 18:43:24 +0100 you wrote:
> s/bounts/bounds/
> 
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  kernel/bpf/verifier.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf: fix typo in scalar{,32}_min_max_rsh comments
    https://git.kernel.org/bpf/bpf-next/c/18b24d78d537

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


