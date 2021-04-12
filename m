Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1856335D29B
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 23:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241128AbhDLVaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 17:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240341AbhDLVa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 17:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 142C46105A;
        Mon, 12 Apr 2021 21:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618263009;
        bh=2VluHk+eufc1objCaoPosLzTVE5QK66i0940ZSFxJqs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RVHJNJLjiipjm4YwQ3YLDc0HrL+buSc6Sj9/gK1/V0PzbxuDqVsMo8R+SM9ubp8UH
         FSfy3KEOCmZQkC+Z/B1tCL8e8iMyje5igJLmidcOTIiqvWle17zDBHcOBLn/iJTIK+
         YWApwu4berwdRM205NbbzmrIOUweueNyahIchvFhCHkqvsjstRtpjMZjUKppR+T7JX
         Z9c8ZiJzGbe9oE0fiPSgEG5pVApKR3V2E0k3Gy3N8U+m/cvTtn2innbOD1Cwj+95pc
         89/7rPyuVcJeSpzpi3/SKD/gcR0GL85E8xNmNAVqgruzpJ2TrbizTr2A0KIyQzkG9u
         WXh5HQobAU3fw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 081D260CD0;
        Mon, 12 Apr 2021 21:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net resend] ethtool: fix kdoc attr name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161826300902.30008.7569791245532516594.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Apr 2021 21:30:09 +0000
References: <20210412184707.825656-1-kuba@kernel.org>
In-Reply-To: <20210412184707.825656-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz,
        andrew@lunn.ch, johannes.berg@intel.com, danieller@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 12 Apr 2021 11:47:07 -0700 you wrote:
> Add missing 't' in attrtype.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ethtool/netlink.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net,resend] ethtool: fix kdoc attr name
    https://git.kernel.org/netdev/net/c/f33b0e196ed7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


