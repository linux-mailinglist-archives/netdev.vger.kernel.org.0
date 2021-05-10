Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E933799EC
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 00:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhEJWVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 18:21:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhEJWVS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 18:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DB47614A5;
        Mon, 10 May 2021 22:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620685212;
        bh=+qs6QUZsikd3ICz2UiLJtwktgyraJBroeNj6A1XFuYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JBZxUzS+qUcEqFV9FVf4Ni0ZlSaiz1yGDC9dqqw2A7+zkbeElRTS8S9oQG0ut8jN+
         hZNG3VwJ/lG8vMXXhJGUhuCYlod+kvA8tcmzWmicRAhB5Q6PnOZ6b2TCI5/Rdaprzq
         Kq5+DbEtNFLLF0AUtQDgNZd8m774e5IOFxoHji56hF1XdBGk1RZuEb2R/F1b32YMTl
         Q2scxn7r0g+cNya9OTxCKJANqrSjkez1B4xuMlK6ZuD2jD2KhaedVEG9Mb8vFKcPpM
         VfMJEf6J4cwWQ8NfUogTzNPykhDPZLSdjCoauzgHsBxC/M7U/v17wlUYQK8RJ1w4EO
         sW/R2riUuGrDw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F130B60A0E;
        Mon, 10 May 2021 22:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] mvpp2: resolve two warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162068521198.17141.17479532563487837396.git-patchwork-notify@kernel.org>
Date:   Mon, 10 May 2021 22:20:11 +0000
References: <20210510165232.16609-1-mcroce@linux.microsoft.com>
In-Reply-To: <20210510165232.16609-1-mcroce@linux.microsoft.com>
To:     Matteo Croce <mcroce@linux.microsoft.com>
Cc:     mw@semihalf.com, linux@armlinux.org.uk, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 10 May 2021 18:52:30 +0200 you wrote:
> From: Matteo Croce <mcroce@microsoft.com>
> 
> Just two small changes to suppress two warnings.
> 
> Matteo Croce (2):
>   mvpp2: remove unused parameter
>   mvpp2: suppress warning
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] mvpp2: remove unused parameter
    https://git.kernel.org/netdev/net-next/c/376d68929d5b
  - [net-next,2/2] mvpp2: suppress warning
    https://git.kernel.org/netdev/net-next/c/4c598e5e679c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


