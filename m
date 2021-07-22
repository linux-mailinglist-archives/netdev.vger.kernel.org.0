Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84803D3093
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 01:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232731AbhGVXJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 19:09:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232550AbhGVXJ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Jul 2021 19:09:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E860F60EB6;
        Thu, 22 Jul 2021 23:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626997804;
        bh=I8UIiCevCR4u91FO0lQ/dfU0HqumVRTmrXG6r8JmeKc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sHRz57t1Ouo4i1IcHzBGKonw3/DzO+/ZIkz00GtI8+wZoMp8O5bLG/n8kEDkJEJvc
         uigaaV/lIcDHHGGpsdf3l5jXr6TQziPUepmmQNfM7UZap4J5eDvbKHdknRAD10PXv9
         nzrBxH199k4F3FCNUxONhjqEitwq9q9+y6afZ4INySSJQJJqUaV83a3YQbfC3QBDJt
         Txyeh0wUccO9evlIfjp5z51i18gUcoHm4fNz6j/3DTsWRf6mg4UU088WJcH4gPIrMU
         Ms4QCJ/IuDC6YpGfJm++1DRFKFIXuK+42Cn9zmvbALQQSak7eGKK5bJkAioEzIEenC
         HLRXhZxIQQ/PQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC57B60726;
        Thu, 22 Jul 2021 23:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: remove redundant intiialization of variable stype
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162699780389.9644.9613532501307738267.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jul 2021 23:50:03 +0000
References: <20210721115630.109279-1-colin.king@canonical.com>
In-Reply-To: <20210721115630.109279-1-colin.king@canonical.com>
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

On Wed, 21 Jul 2021 12:56:30 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable stype is being initialized with a value that is never
> read, it is being updated later on. The assignment is redundant and
> can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - bpf: remove redundant intiialization of variable stype
    https://git.kernel.org/bpf/bpf-next/c/724f17b7d45d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


