Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAF9D3D7EBF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 22:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhG0UAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 16:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229681AbhG0UAO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 16:00:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 025E660FC2;
        Tue, 27 Jul 2021 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627416014;
        bh=d0ZP2pOk1dVuAkqL8ks/8KOUxF5Ghmlabk6beOTdtW0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bQhQFgC4lCZSGYteM/6nqj8xhGUJ0uUFf7lYtaH/lwXeCSKDjTdqit2GE+qGgzagX
         uVj+LuF5SEfp3An/XcSuRm8k+0c57AVTUciuM90Dc70ijkYhSNWJXSZgwge7TYpgP8
         kLJLQjBwx1o8le3fcLGC1hrVu9KjMlBvBi9eVbCwPNE1Mezc/XwEyGlzXqN+xE7EGC
         jMJWzd+eV9ifoprkbergpMnfZQmS8VC/DcZos3yqPsoAeRGofFgHS35qW80sYAxDtf
         34FaLi12+chm7xrZ5NzxPQ8N8TiIAgju6F5A0BUcUljsSaybxJvKJOJTUNVMcVhzhf
         23NgHMHGj6RTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE65760A6C;
        Tue, 27 Jul 2021 20:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] ionic: driver updates 27-July-2021
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162741601397.17427.863934488517066772.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 20:00:13 +0000
References: <20210727174334.67931-1-snelson@pensando.io>
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        drivers@pensando.io
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Jul 2021 10:43:24 -0700 you wrote:
> This is a collection of small driver updates for adding a couple of
> small features and for a bit of code cleaning.
> 
> Shannon Nelson (10):
>   ionic: minimize resources when under kdump
>   ionic: monitor fw status generation
>   ionic: print firmware version on identify
>   ionic: init reconfig err to 0
>   ionic: use fewer inits on the buf_info struct
>   ionic: increment num-vfs before configure
>   ionic: remove unneeded comp union fields
>   ionic: block some ethtool operations when fw in reset
>   ionic: enable rxhash only with multiple queues
>   ionic: add function tag to debug string
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] ionic: minimize resources when under kdump
    https://git.kernel.org/netdev/net-next/c/c0b03e839950
  - [net-next,02/10] ionic: monitor fw status generation
    https://git.kernel.org/netdev/net-next/c/d2662072c094
  - [net-next,03/10] ionic: print firmware version on identify
    https://git.kernel.org/netdev/net-next/c/73d618bb7e19
  - [net-next,04/10] ionic: init reconfig err to 0
    https://git.kernel.org/netdev/net-next/c/e7f52aa44380
  - [net-next,05/10] ionic: use fewer inits on the buf_info struct
    https://git.kernel.org/netdev/net-next/c/e75ccac1d064
  - [net-next,06/10] ionic: increment num-vfs before configure
    https://git.kernel.org/netdev/net-next/c/73618201acaa
  - [net-next,07/10] ionic: remove unneeded comp union fields
    https://git.kernel.org/netdev/net-next/c/a1cda1844bee
  - [net-next,08/10] ionic: block some ethtool operations when fw in reset
    https://git.kernel.org/netdev/net-next/c/f51236867736
  - [net-next,09/10] ionic: enable rxhash only with multiple queues
    https://git.kernel.org/netdev/net-next/c/6edddead9550
  - [net-next,10/10] ionic: add function tag to debug string
    https://git.kernel.org/netdev/net-next/c/18d6426402de

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


