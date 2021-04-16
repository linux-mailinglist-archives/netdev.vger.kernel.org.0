Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06980362B13
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 00:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbhDPWaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 18:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230056AbhDPWag (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 18:30:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 219EC613C1;
        Fri, 16 Apr 2021 22:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618612209;
        bh=skkq0wVJiKzjSQea4J5Z5MH0iVGIV3lc5VANq2HIA/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=II14T/m/kYqCNOMsE1bZQHVRcBUZKJtyIVIrbHLy+Z9cPcXhwO0ef+noK3QSLXcg4
         RdNuxr9V5/lZLFwhf0ox4kVGwcgdcIq6mGB8O3j5uMk5bEamnbAY5YEoc5BZYtIPIb
         nrqY4D0ehNDrAahE00Hc7YeQSH8bsEXlvblggON2VyTx2fJEWIDZcmiGQWuUJAy46X
         +AAdAqDGOCjPsw3fv3YE9S5AoTmY1PehT8MICKzWE9CV8oIRAL0Yv5TGLylQDCpuKP
         1QltABPP/dibH1/h3Tz3hWZLDxiGeQ3a8UmmNoAcuAaZtR8EKpU6e9bwU2ZCSWUrP8
         srgSbvOjkkfwQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1188E60CD6;
        Fri, 16 Apr 2021 22:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] MAINTAINERS: update my email
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861220906.19916.16567222027627341386.git-patchwork-notify@kernel.org>
Date:   Fri, 16 Apr 2021 22:30:09 +0000
References: <20210416041813.13895-1-lijunp213@gmail.com>
In-Reply-To: <20210416041813.13895-1-lijunp213@gmail.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 15 Apr 2021 23:18:13 -0500 you wrote:
> Update my email and change myself to Reviewer.
> 
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] MAINTAINERS: update my email
    https://git.kernel.org/netdev/net/c/6b389c16378a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


