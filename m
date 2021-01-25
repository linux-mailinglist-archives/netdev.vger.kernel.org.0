Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC4F30302C
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732291AbhAYXb1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:31:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732438AbhAYXav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 18:30:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F6F622A84;
        Mon, 25 Jan 2021 23:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611617410;
        bh=KkMxQ+vHsUYumkAumXkTO1FhHTJql/Il+Pn7iHRzVAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bPsBywWoSeSEg/dGNt1IAAghtZW9szXkV9fXg/M7vIx2CNkk1Dp+S1NcRYRa//H2U
         kC7id9lF6gPm9lj+MaG1Yle1yAMgMTyATjFMCl+xtg5b8NQtte9Ups+Xv4+WFjbdwd
         rAHAn+mufhCHdqMvOIHlWx/Jo1Y4jd1vUZst0iiAa052dDfUPYkxxwZ84PKqoH+pnL
         Ihk2DSJLGGZMK2w7ldUmfPgVefhSPdcRKTNqCfCMzI87Ka0s7vxq77tpTvqH5GOs4B
         0CI/xBzqvgaexpFr3XQWruCNzaeLfRRjBM0LdoHLQFEb0ce3hr+ye6C6YiJd0oy1c+
         W+4nhaCqNPSoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6072261FBF;
        Mon, 25 Jan 2021 23:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] tools headers: Sync struct bpf_perf_event_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161161741038.15463.3231537580662958439.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jan 2021 23:30:10 +0000
References: <20210123185221.23946-1-dev@der-flo.net>
In-Reply-To: <20210123185221.23946-1-dev@der-flo.net>
To:     Florian Lehner <dev@der-flo.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, yhs@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sat, 23 Jan 2021 19:52:21 +0100 you wrote:
> Update struct bpf_perf_event_data with the addr field to match the
> tools headers with the kernel headers.
> 
> Signed-off-by: Florian Lehner <dev@der-flo.net>
> ---
>  tools/include/uapi/linux/bpf_perf_event.h | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [bpf-next] tools headers: Sync struct bpf_perf_event_data
    https://git.kernel.org/bpf/bpf-next/c/726bf76fcd09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


