Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4282D30D324
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 06:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbhBCFkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 00:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhBCFkr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 00:40:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id CD52E64F6A;
        Wed,  3 Feb 2021 05:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612330806;
        bh=4xt2kK0/+hjv7UkIpC7c/rjkWmJ4qJpedVjLKP5os38=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mDMenACYP3GCT7OPgKWon318uxbj1N+SsVejJm9ZVniOE7wt9pkYiy3imazgmOdom
         +oEJKIVDbDkESOakziLGQ8sRCxSIUecgkg0NuDhVArxPL8tX44U9gd3S0zTS4Hx7z8
         QZzFP3w51FkORahDbhJxkzczKLue69t7+k3oDcmEeoehkR19YuFsYuiIgZmzi6YQ0i
         S9R2Kh/WBRfBKAyw/riInVKydqB0PrYwyypYw7bdP29/kRglwL8L50jjpxKbfjzhV1
         AlDB6D/YbRMSjegoNHe7xQ3l/YcbA+OuhhbJWQmMjx4O4QOOsE3MEtvzPb075/Bsx4
         9//L+tjpR5sJQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF3D5609E5;
        Wed,  3 Feb 2021 05:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] samples: bpf: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161233080677.26955.14722771894928310777.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 05:40:06 +0000
References: <1612322248-35398-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1612322248-35398-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed,  3 Feb 2021 11:17:28 +0800 you wrote:
> Eliminate the following coccicheck warning:
> ./samples/bpf/cookie_uid_helper_example.c:316:3-4: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  samples/bpf/cookie_uid_helper_example.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - samples: bpf: remove unneeded semicolon
    https://git.kernel.org/bpf/bpf-next/c/1132b9987a3f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


