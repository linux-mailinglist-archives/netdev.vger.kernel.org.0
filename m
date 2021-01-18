Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513862FAD56
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 23:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731305AbhARWbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 17:31:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:37422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731537AbhARWas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 17:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1343C22D58;
        Mon, 18 Jan 2021 22:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611009008;
        bh=9d/fefa1I7a/TuegT0pdSMjuHBO+jpTqQk5Al75FuEc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MNDHJsBd9HYnhSfw692f3Yhk5CCfiIyHPMYZw0+AB6XSdZl7kiUTyuTXYuvNR8jq5
         OZmPFJUa1Wn4BzEvJuWSaFE8fTW4rHqgq8bhgNqsa1XVzgiCXa8LHyIipdnYlzAI6x
         gB8PlCnyvOJdqUKcrzXenZCuHRJyTZf7WD1AdKs2iaIICiq5HlfCkiJWYEokoX1t6n
         eqxwU10KiHGd0S9NChqsR7TA7CbNidB6ATyZDCIdD1QOD1Li0B2UT3/XDKVMDt9LhF
         uyEURf0uhePiSdGe/2JTvJgpaHGW5uAgCqxauSuJnlI9qtegusEJXJaxr1KUfhby7c
         3Dda1L8id470w==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 04827601A5;
        Mon, 18 Jan 2021 22:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next 0/2] add xdp_build_skb_from_frame utility routine
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161100900801.28109.7968679376496084703.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jan 2021 22:30:08 +0000
References: <cover.1610475660.git.lorenzo@kernel.org>
In-Reply-To: <cover.1610475660.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        brouer@redhat.com, lorenzo.bianconi@redhat.com,
        toshiaki.makita1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 12 Jan 2021 19:26:11 +0100 you wrote:
> Introduce __xdp_build_skb_from_frame and xdp_build_skb_from_frame routines
> to build the skb from a xdp_frame. Respect to __xdp_build_skb_from_frame,
> xdp_build_skb_from_frame will allocate the skb object.
> Rely on __xdp_build_skb_from_frame/xdp_build_skb_from_frame in cpumap and
> veth code.
> 
> Changes since v1:
> - fix a checkpatch warning
> - improve commit log in patch 2/2
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next,1/2] net: xdp: introduce __xdp_build_skb_from_frame utility routine
    https://git.kernel.org/bpf/bpf-next/c/e753e92bbf33
  - [v2,bpf-next,2/2] net: xdp: introduce xdp_build_skb_from_frame utility routine
    https://git.kernel.org/bpf/bpf-next/c/a2c2998d5c6b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


