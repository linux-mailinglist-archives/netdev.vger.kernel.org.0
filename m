Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327062DE694
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 16:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgLRPas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 10:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:33628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725919AbgLRPar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 10:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608305407;
        bh=nFp0kxUQQXK3c6uo4i4vSMOlMh9pjIozCEdT8jDPUpk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FvElQRLdHzVto4LwlakV2coBcm1ttWwvyEWB2Ph5s7NAbJR2yuNK3o7aAuMzFJiyd
         rkbLOR9i/WetGnr7bw1yygrBRkuvbcquRLVW6afVhf69aABTbLSiGQ5jcWKsQw3ySf
         ACHDKEM3rCUgU/4B34pm5b/mzoshqD/NH6F9a+5uce2c4zdArIYzZnyuflIbDh/axA
         7+zfeB6N5k04Lfg8aHHPLxrr+mDRBKX7pRqjvMYKDI5c7vy/yxC2I++hv6oEGSk13n
         CZ7s22tLKWd6yTxa4Rt2KS0WmCorBqz8QFyGxiCOEGxsAk8mA8pnk5h7wy/XMOieX4
         f/DOHXtvaNDRw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: remove unused including <linux/version.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160830540719.2903.13527324551168501333.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Dec 2020 15:30:07 +0000
References: <1608086835-54523-1-git-send-email-tiantao6@hisilicon.com>
In-Reply-To: <1608086835-54523-1-git-send-email-tiantao6@hisilicon.com>
To:     Tian Tao <tiantao6@hisilicon.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (refs/heads/master):

On Wed, 16 Dec 2020 10:47:15 +0800 you wrote:
> Remove including <linux/version.h> that don't need it.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
> ---
>  kernel/bpf/syscall.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - bpf: remove unused including <linux/version.h>
    https://git.kernel.org/bpf/bpf/c/d467d80dc399

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


