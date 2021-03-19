Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35553412BA
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbhCSCUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231241AbhCSCUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7552D64F62;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=e/Coxly/68IdWDw7fTtpBPQdUf/mSByMiDwU7jt/UHw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l/BrCSFAUPUgWLjZVCfXHnGEkqX+WTD0O9pZpHi291UUMSFl4VHSZ2EliV/yiz9oj
         O/r993++92GDfLyWBzyVf2MxGJ/cC2W+xD5FCVvXFmm4cjfnEt7tHq6pdabD7u3AF7
         6D1T/+cD2qa+raZtJepOrC4u+tjGP8/F++fRyARCUMhBXad0MsXijq3H9D4Zph33V6
         CuYLq7+wNxnse7cWMqk8eFfxJjB8HZ3tOKo6QDlNJX5hxIpQFzrjrJuegvRuZLfGpr
         zvou4OPSLoQj6QBJrRoE+WwmvP+2apwzc0BsBZAHot4y59uln6WzqqJJvKGFFf8gI/
         YCY5A3ByhFqmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B7EC6098E;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc/fdp: Simplify the return expression of fdp_nci_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041243.22955.9824525373123696158.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318133640.1377-1-zuoqilin1@163.com>
In-Reply-To: <20210318133640.1377-1-zuoqilin1@163.com>
To:     None <zuoqilin1@163.com>
Cc:     davem@davemloft.net, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 21:36:40 +0800 you wrote:
> From: zuoqilin <zuoqilin@yulong.com>
> 
> Simplify the return expression.
> 
> Signed-off-by: zuoqilin <zuoqilin@yulong.com>
> ---
>  drivers/nfc/fdp/fdp.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Here is the summary with links:
  - nfc/fdp: Simplify the return expression of fdp_nci_open()
    https://git.kernel.org/netdev/net-next/c/92a310cdcf81

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


