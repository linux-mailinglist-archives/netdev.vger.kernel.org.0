Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 223ED3E3A15
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 14:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhHHMA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 08:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230270AbhHHMAY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Aug 2021 08:00:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 28FD461056;
        Sun,  8 Aug 2021 12:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628424006;
        bh=iYTrV9QESJfVuxWpMo57RWko8EE5TF5De0b1jivUQIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VDm3dIhXVPMlX8vcV8KgfH1QMVH93c66Vkl/blaF6N9IJrrh+kQeol2/m0AsayXCG
         d/VUwEorb+p0trae06H1PdTcbogFrmUL5kiU6a1lMbLDXyo+4Fcel8PWzC0ujH0VMI
         l/aRrsCFwxW3jvOS2knf9q9X8F+djeWLMxgKynBwDH2Un/YoLchy4axeGL/9gvR3Yj
         n0R6zYGwah9gKDeK/xofyWIbU0IuGbZ6r95BdVqJPWsr30LB1W0RUt351IM1O4mK7Z
         KUbmEKYx6VU38olmpAxkjWCq6joJe2gMfDN1jKQRMtDGqLdQvDVJ5EcLeczvQQA5Oz
         7oFedGjK/nMHA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2396660726;
        Sun,  8 Aug 2021 12:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [V2][PATCH] atm: horizon: Fix spelling mistakes in TX comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162842400614.17847.3821752720470977425.git-patchwork-notify@kernel.org>
Date:   Sun, 08 Aug 2021 12:00:06 +0000
References: <20210807154140.1294779-1-jun.miao@windriver.com>
In-Reply-To: <20210807154140.1294779-1-jun.miao@windriver.com>
To:     Jun Miao <jun.miao@windriver.com>
Cc:     3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  7 Aug 2021 23:41:40 +0800 you wrote:
> It's "must not", not "musn't", meaning "shall not".
> Let's fix that.
> 
> Suggested-by: Joe Perches <joe@perches.com>
> Signed-off-by: Jun Miao <jun.miao@windriver.com>
> ---
>  drivers/atm/horizon.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [V2] atm: horizon: Fix spelling mistakes in TX comment
    https://git.kernel.org/netdev/net-next/c/64ec13ec92d5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


