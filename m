Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC603AA964
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 05:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFQDMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 23:12:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhFQDMK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 23:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 192C5613DE;
        Thu, 17 Jun 2021 03:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623899403;
        bh=nOf4evt9ycXsTz4VT4PWEZi+INi/5H2eWdlFS1QU6f4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F4Kxy20f7yLGPNG+3SMIEmZ6o+4cG9nKtbGV2o/XpZgny40zmTsfo7NGvaw0KKiVn
         ukrdsQoU5hGGNhig1dpFt0NRTd6SKAsQzLcYoagnocACsi5WxmFoYWG7D7phHlzxWy
         YepibyQC005CSQQDq7ehigB5RCWbnQMelz65ahHupoSmnQp44FOLanHN5bKtspQ2/C
         oqAZQ/AA27yD4P1vls5NYTp1lRNOAbGkskvCCn6pjlHhFI6VUEupebt9qD2Mm98h6+
         Rcg8hiu045u80EDh+w4SDBgtBTbU+3X4TosQEh+M7titiBdIEU/Plh+ssSAmd3nQbh
         +NV+zzthb7myA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0A71360A6B;
        Thu, 17 Jun 2021 03:10:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Fix typo in kernel/bpf/bpf_lsm.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162389940303.31670.2887150400933314249.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 03:10:03 +0000
References: <1623809076-97907-1-git-send-email-chengshuyi@linux.alibaba.com>
In-Reply-To: <1623809076-97907-1-git-send-email-chengshuyi@linux.alibaba.com>
To:     Shuyi Cheng <chengshuyi@linux.alibaba.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 16 Jun 2021 10:04:36 +0800 you wrote:
> Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
> ---
>  kernel/bpf/bpf_lsm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] bpf: Fix typo in kernel/bpf/bpf_lsm.c
    https://git.kernel.org/bpf/bpf-next/c/712b78c697cd

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


