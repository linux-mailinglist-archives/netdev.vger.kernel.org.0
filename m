Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF273CC9F1
	for <lists+netdev@lfdr.de>; Sun, 18 Jul 2021 18:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhGRQx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 12:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhGRQxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 12:53:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1147E611AE;
        Sun, 18 Jul 2021 16:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626627005;
        bh=YM1pBlMCjvr9DX1PSRqS0lnmP/kbe++8BmHWSNr+YFI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LQtiRMlN7a5GIQYCQnUm//bOxDv9/idHQlH4Pry6VYotWVgvEsfhR7qNQ5d/+xyQb
         WaENYI06oK+YpDIehuKGvhz69GhvZ+yGhoTDHgxVvpLgAc1yCwmSYYSmF96jnLWnsX
         HSHcpOBXe8r5HY87jXS3361E5+Fu4jxAb6HvB543laffMcSf+My/hveOF72KGFfmzB
         Ih+KhfHPXH+kNEdd2MbU9fgHSiYPv810jtnbcWar7F/C13ZWeE3KBr5qF4rUnm4E7H
         dw9pmm8jQHHSK1rOMOMlyHRHk1MylStR9UC9fkfNanK5PRAXivwlCEtRHEtPlAd0fb
         uFmO4hE2XLWHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09EDE60A37;
        Sun, 18 Jul 2021 16:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sctp: trim optlen when it's a huge value in
 sctp_setsockopt
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162662700503.19662.17700177821485021975.git-patchwork-notify@kernel.org>
Date:   Sun, 18 Jul 2021 16:50:05 +0000
References: <0871af1e816f5239aaf546fcbc24af31aeec780f.1626556759.git.lucien.xin@gmail.com>
In-Reply-To: <0871af1e816f5239aaf546fcbc24af31aeec780f.1626556759.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-sctp@vger.kernel.org, marcelo.leitner@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 17 Jul 2021 17:19:19 -0400 you wrote:
> After commit ca84bd058dae ("sctp: copy the optval from user space in
> sctp_setsockopt"), it does memory allocation in sctp_setsockopt with
> the optlen, and it would fail the allocation and return error if the
> optlen from user space is a huge value.
> 
> This breaks some sockopts, like SCTP_HMAC_IDENT, SCTP_RESET_STREAMS and
> SCTP_AUTH_KEY, as when processing these sockopts before, optlen would
> be trimmed to a biggest value it needs when optlen is a huge value,
> instead of failing the allocation and returning error.
> 
> [...]

Here is the summary with links:
  - [net] sctp: trim optlen when it's a huge value in sctp_setsockopt
    https://git.kernel.org/netdev/net/c/2f3fdd8d4805

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


