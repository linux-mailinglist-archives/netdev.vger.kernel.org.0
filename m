Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3B5309379
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbhA3Jfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:35:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:34540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233373AbhA3DUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 22:20:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7E03864E22;
        Sat, 30 Jan 2021 03:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611976806;
        bh=/YzEjJ3vLm3JJ5CvEbdJEIX/iI6KlCDFzfJmG1KKEzo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EDrYClNf1ed55cdfyEKix8O5byuaWsgh7OxapLf2g7b60CzxTYKTcWjYx46kQ0haR
         g7gv+vGcB+qwa9tOv9NPJ2kvVkFZ1kdHkYEMud7tp1H/ru6q4k0fFYNBVlY0FNfCGr
         CEz93sv+uPld+5pe/kNK7q5+rFPFaX9SY8UbJ79tJVFEz/xcZ4pVLv3ZUw1RwIvVib
         NG/GmlPuTDu0PRlRSTJoy5tVOgljD8n0/x9g2o0lIgagrWQ6orKGvGYZfKNs4Wc2gn
         lyJJjBlfId9o0DdXqHkedHfAC1F4FusyxzsGOUc1/0ha394HRAOJbRh9FZ2g8wrcHF
         dpelVhM1I7Wgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6CD0E60984;
        Sat, 30 Jan 2021 03:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ethernet: convert to use module_platform_driver in
 octeon_mgmt.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161197680644.13531.1325619394328700404.git-patchwork-notify@kernel.org>
Date:   Sat, 30 Jan 2021 03:20:06 +0000
References: <20210128035330.17676-1-dingsenjie@163.com>
In-Reply-To: <20210128035330.17676-1-dingsenjie@163.com>
To:     None <dingsenjie@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        leon@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingsenjie@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 28 Jan 2021 11:53:30 +0800 you wrote:
> From: dingsenjie <dingsenjie@yulong.com>
> 
> Simplify the code by using module_platform_driver macro
> for octeon_mgmt.
> 
> Signed-off-by: dingsenjie <dingsenjie@yulong.com>
> 
> [...]

Here is the summary with links:
  - net/ethernet: convert to use module_platform_driver in octeon_mgmt.c
    https://git.kernel.org/netdev/net-next/c/afa4f675aa62

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


