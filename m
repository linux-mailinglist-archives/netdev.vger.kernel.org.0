Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 639B639C2EA
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbhFDVvw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFDVvu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:51:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C0DD61406;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622843404;
        bh=XfAPtsUQtTY912+zqfvretVVslVZAX4hOztUn+VzC6A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EkkJFbzEtfmFX6A1/Y//1vjxZd41oZf8S/yjP8vwa5Rkc8lQzee/a3XcDN/DuSVHN
         CfOgv9fBChqsTZRAAsZ2L0NqcZvH9M6owrUww5j1hsw5QYBQpbyfNuhhfBby5VF4P1
         1S63F27qRxgk89ep3HruoPLcGhKVH61PEqNuShcgOOAUYzTffhqSEEt0VEQhT3g9eT
         42wjRkysOXCWzQZgZTNTmgyTpuFVCDofmt35gHtqw06B8+CWZ+3EXaBa4ytiu53HOF
         lOPHObYznGRJyyghTm0ywqO7jOEvC7tKuyjVu6v+iC4KGn5PYlQ4NuTr1t8YdGJgn8
         JWjO4uXsh2OOg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 19B0D60BFB;
        Fri,  4 Jun 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] cxgb4: avoid link re-train during TC-MQPRIO configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284340410.5449.17732591776950932726.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:50:04 +0000
References: <1622805498-26094-1-git-send-email-rahul.lakkireddy@chelsio.com>
In-Reply-To: <1622805498-26094-1-git-send-email-rahul.lakkireddy@chelsio.com>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rajur@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  4 Jun 2021 16:48:18 +0530 you wrote:
> When configuring TC-MQPRIO offload, only turn off netdev carrier and
> don't bring physical link down in hardware. Otherwise, when the
> physical link is brought up again after configuration, it gets
> re-trained and stalls ongoing traffic.
> 
> Also, when firmware is no longer accessible or crashed, avoid sending
> FLOWC and waiting for reply that will never come.
> 
> [...]

Here is the summary with links:
  - [net] cxgb4: avoid link re-train during TC-MQPRIO configuration
    https://git.kernel.org/netdev/net/c/3822d0670c9d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


