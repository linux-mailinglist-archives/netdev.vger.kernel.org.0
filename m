Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FDC3EDF67
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233539AbhHPVkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:40:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229987AbhHPVkj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:40:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E67F760F39;
        Mon, 16 Aug 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629150006;
        bh=kkqYGdS+bxZFR43v/vsQxRAK647tUeKqoUcTwYIxLnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ifvc4la4E6+a5Aorpw1WQHb2UaICbqQXdMdlGTI2kns3lAhIg/WJT1uQtKmX9dIC3
         ofyAXCbeRwwSTCwZZjw6kTRlvnNGq4apLhQUkxlaoKkqFw4t/NxvpZBivdyopn1p5e
         PAxfo/9UwrGgektCic079xYaAKldNTUSoMXg5yhXK0F1fDAeH1iDPc5IuGcq2htUVq
         6RtE6HUA/c1RX/yN5XxXQwD+4DpF1VdYBKS1ZTN17m6NiNO5XgLXUmu5GgJQcdpIIl
         a9ipVSIaYnkMIc+UxeYyKw5gNPGX3XqpsYEE6BfPoi9zjAMFrkJJCha65cpKAuvGTW
         rh7cKv+A0VAcQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D8769609CF;
        Mon, 16 Aug 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] bpf, tests: Fix spelling mistake "shoft" -> "shift"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162915000688.3631.14506994484111009318.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 21:40:06 +0000
References: <20210815213950.47751-1-colin.king@canonical.com>
In-Reply-To: <20210815213950.47751-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Sun, 15 Aug 2021 22:39:50 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> There is a spelling mistake in a literal string. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  lib/test_bpf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] bpf, tests: Fix spelling mistake "shoft" -> "shift"
    https://git.kernel.org/bpf/bpf-next/c/1bda52f80471

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


