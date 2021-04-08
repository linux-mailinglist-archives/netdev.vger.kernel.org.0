Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5932358EFC
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbhDHVKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231862AbhDHVKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C3ABB61181;
        Thu,  8 Apr 2021 21:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617916208;
        bh=OUK5fOHYj3CVb2a7jDwCycuPfx6zJpiAXR887uY2G6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R0uAmtJl+hKELiBRJ2MH+Tvl0Ilu4h21fbsWEExfvA6LqLvHFELRNxWfCWVY1aUqD
         e5ke6uOJqRDEZTy748FhBsO9kJvbdCIhbQaKGegXTaz8QqW8TIKvvAH0EcHJqkMIac
         EBwGBTnmL84CYzQ7DXnQMyx5plBbI9Bld0LrOeY66nxK+ZP/pjHCU6bofkr6iYqZIJ
         k10zfnSMH1WH8PqavWf6sc/eLV5pNorgYeA5pD5NO9okwTEbymaPKo0CPpWJm34oo5
         QKB/IIocFtRT1d8q+e5KbbryPKwlo/r+AW0kCHbBbQgkcWWEUIi9NetyEaS/HMiLut
         a1KyQu5VMtR6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC0FB60A2A;
        Thu,  8 Apr 2021 21:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ipv6: report errors for iftoken via netlink extack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791620876.7767.4230135036107780312.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 21:10:08 +0000
References: <20210407155912.19602-1-sthemmin@microsoft.com>
In-Reply-To: <20210407155912.19602-1-sthemmin@microsoft.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, li@zenithal.me
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Apr 2021 08:59:12 -0700 you wrote:
> From: Stephen Hemminger <stephen@networkplumber.org>
> 
> Setting iftoken can fail for several different reasons but there
> and there was no report to user as to the cause. Add netlink
> extended errors to the processing of the request.
> 
> This requires adding additional argument through rtnl_af_ops
> set_link_af callback.
> 
> [...]

Here is the summary with links:
  - [v2] ipv6: report errors for iftoken via netlink extack
    https://git.kernel.org/netdev/net/c/3583a4e8d77d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


