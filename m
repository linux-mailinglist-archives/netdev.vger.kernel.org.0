Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5764344EE28
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 21:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236235AbhKLUxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 15:53:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235940AbhKLUw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 15:52:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A3A3160EBD;
        Fri, 12 Nov 2021 20:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636750207;
        bh=lwjAWwAg4DrbN15ZktK7sl/Nn904/HeWrcHovPV0roE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lbYBddhvG88lOdDAlIsyroMjlRZ0Ge5HDUYD1wj/VA03iZb9ho9m9tsatW1u27Vpf
         7PnpLrMWGHWj6lrM+ozapz+t69vPULjcKOBi96kDSlgYUJ1I9TWBsPIwlDiAjaAqMV
         uk7yQ9/5Yt761/qTmmDhibI0z8nkeAlt8BAntYSUz3915s1v6O5JzThuUvY9GWCV6T
         hazzHH1enLH18XGQWhTZnh/23/06Iu+LKSSjRxywBXxHf15wWjlDqI3h5G9w1Y6Rse
         fszI3j56oDJc9NsANgodJKIXS8oRJ1Q5EIMRRVaBe4jHaJ9eMWcOCtnXn9O0G7IaIc
         YCO2tZxjoga1g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 956EA609F8;
        Fri, 12 Nov 2021 20:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] samples: bpf: fix summary per-sec stats in
 xdp_sample_user
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163675020760.12842.17692151581487954557.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Nov 2021 20:50:07 +0000
References: <20211111215703.690-1-alexandr.lobakin@intel.com>
In-Reply-To: <20211111215703.690-1-alexandr.lobakin@intel.com>
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, jesse.brandeburg@intel.com,
        maciej.fijalkowski@intel.com, michal.swiatkowski@intel.com,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        john.fastabend@gmail.com, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        memxor@gmail.com, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu, 11 Nov 2021 22:57:03 +0100 you wrote:
> sample_summary_print() uses accumulated period to calculate and
> display per-sec averages. This period gets incremented by sampling
> interval each time a new sample is formed, and thus equals to the
> number of samples collected multiplied by this interval.
> However, the totals are being calculated differently, they receive
> current sample statistics already divided by the interval gotten as
> a difference between sample timestamps for better precision -- in
> other words, they are being incremented by the per-sec values each
> sample.
> This leads to the excessive division of summary per-secs when
> interval != 1 sec. It is obvious pps couldn't become two times
> lower just from picking a different sampling interval value:
> 
> [...]

Here is the summary with links:
  - [bpf] samples: bpf: fix summary per-sec stats in xdp_sample_user
    https://git.kernel.org/bpf/bpf/c/b51a6682d432

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


