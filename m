Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4021C352365
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236227AbhDAXUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:20:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235847AbhDAXUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:20:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C512E6113E;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617319209;
        bh=cjJrWfRHOBQrYVkTwYmSrSVz/yjKS7XXMmNqWmTF6yQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UsqkX2/dVl0DuRNVhm7mYNVl3J+X33qhpnggWH9QJUXFHpRGwlwymGSKjNAHMckAU
         gyxHtJMDTJu3Oklh8uy8sOrfUG/vGAUVlleQ0npv2Nfn2UMU11jK9jZzxOqg9w6LDO
         ZKh/5iPOhsdVz5zQx5Tl79F/sJWnzoHJvHKv3Iy6wF5M36SSURk4W6fBWJl/hFxVRs
         pa+jKG3sYbHFw5Obzu7lEujH7HbcsZTFq5Mf7JheyCwwE2LSE9S0mT4mzsDoprAHw6
         b9lI4gkIXtW4v+COy855vLiBugu1KtQkNkF7MzPPCW3VL4rUy6KN28udfgIiwWT22Z
         Ab3VtF/bSOrHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8897608FE;
        Thu,  1 Apr 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: ax88179_178a: initialize local variables before use
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731920975.16404.14594136802102080377.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:20:09 +0000
References: <20210401223607.3846-1-phil@philpotter.co.uk>
In-Reply-To: <20210401223607.3846-1-phil@philpotter.co.uk>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, wilken.gottwalt@mailbox.org,
        colin.king@canonical.com, bjorn@mork.no, jk@ozlabs.org,
        hkallweit1@gmail.com, bjorn.andersson@linaro.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 23:36:07 +0100 you wrote:
> Use memset to initialize local array in drivers/net/usb/ax88179_178a.c, and
> also set a local u16 and u32 variable to 0. Fixes a KMSAN found uninit-value bug
> reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=00371c73c72f72487c1d0bfe0cc9d00de339d5aa
> 
> Reported-by: syzbot+4993e4a0e237f1b53747@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> 
> [...]

Here is the summary with links:
  - net: usb: ax88179_178a: initialize local variables before use
    https://git.kernel.org/netdev/net-next/c/bd78980be1a6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


