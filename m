Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADFBE33494F
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 22:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhCJVAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 16:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:32828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232063AbhCJVAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 16:00:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B011F65048;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615410013;
        bh=LMM8v+ULduN1OG4BQtOCkDh+guUiIu1XijrRnCwdFzo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jaWbV1bh5N02V4B1flzRJpWpWcFwOEUftEIQg+tW2axocbVzf2iVEHeGrP6VD8jMC
         QMjFe5mCTmhtUEV8sKYeNUdPiTvjp/3rgDEXaZxFz74bmsWiSrRqoUg+WLfp1Q0o37
         0Vwj1ikRUgkGzAP1Rj45bKtRUeo1xJiBYfBoFfLCP5eKOvEQyvVEJoXcnWwd8q1RTs
         GviiQQA5lyIIzAfZaR91rCIVI2wPpiWRvdjlHG77ucq8beHb3K6nZZsk907P0bcZ5e
         SBHDDTZDDM6g4YixUtBe15zr5VH91uMlKAvYu+bhs9iBGcWJkVBoVpmHYwkOoq5wgd
         iRwlgOsM0IQAw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A4E74609D2;
        Wed, 10 Mar 2021 21:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: mISDN: remove unneeded variable 'ret'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161541001367.4631.14674755959607622064.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 21:00:13 +0000
References: <1615366384-12225-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1615366384-12225-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Mar 2021 16:53:04 +0800 you wrote:
> Fix the following coccicheck warning:
> ./drivers/isdn/mISDN/dsp_core.c:956:6-9: Unneeded variable: "err".
> Return "0" on line 1001
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - isdn: mISDN: remove unneeded variable 'ret'
    https://git.kernel.org/netdev/net-next/c/762c1adb1c15

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


