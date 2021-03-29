Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D0134DC80
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 01:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhC2XaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 19:30:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:40024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhC2XaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 19:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0721C6198A;
        Mon, 29 Mar 2021 23:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617060609;
        bh=m0UFAjJb3G6CV6iL2f517+xnndY1nBga2XCbbyYYPx8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATNkr3r6jZ5ZuXu8ghf9nCHOeMJv98z9FT0LaN40CMocsFT3JCGXyzSD+nt9Xqilc
         sKF17j0OOKOg5ef6iey4vGK4Y0AEKwuFaxlWzp4QbEmWD9O/dGoxSatiTxHUJCH19k
         Q+aQVsRAdAY1U5tX4LM/9OvY54UpW1jFSxR3IjFsHKvm8Togf+p2U8tQrobMaEAyp7
         RrMkmf25uLeNIZZNF9uYDCwG1pg/S8pkGOH7CXqzD4KDS4XO5HBe7GlRMw7aQCsUbp
         /ZnzsJARlCyU3lDFBZK7GFaAb6abjFlqnt631ADwyRDJGG5ASzH5yHgSMZTGtVrbn/
         FCo6H8VC4Qb8w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBA0960A49;
        Mon, 29 Mar 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dt-bindings: net: ethernet-controller: fix typo in NVMEM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161706060895.18537.12306660989715387046.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 23:30:08 +0000
References: <20210329140317.23343-1-zajec5@gmail.com>
In-Reply-To: <20210329140317.23343-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, andrew@lunn.ch, mripard@kernel.org,
        f.fainelli@gmail.com, devicetree@vger.kernel.org, rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 16:03:17 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> The correct property name is "nvmem-cell-names". This is what:
> 1. Was originally documented in the ethernet.txt
> 2. Is used in DTS files
> 3. Matches standard syntax for phandles
> 4. Linux net subsystem checks for
> 
> [...]

Here is the summary with links:
  - [net] dt-bindings: net: ethernet-controller: fix typo in NVMEM
    https://git.kernel.org/netdev/net/c/af9d316f3dd6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


