Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAE62DA6AD
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgLODMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:12:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:36780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbgLODMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:31 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608001848;
        bh=dyYhfr/oglmo9jPTwdM8HV2JwONO7c9yhY9KNk4bUqs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iXwpXoZKEjux89v33vTwmmLJK4/n0AdHum6NqEHvLIQA5KZ2PcwwETgNkhbmMYgr/
         ZVyiJ0roxT0BmhVcCCBRhpXnEQ9x8HnyRn7Ipc4r46jRHOa8UUPzbjVmIqRrOI+Lfv
         hmnktYbWmE1R12NTxNDRCTZIP9oVhGA/D/USJzhu46CPJ0XNas3SeCb2P2crs/YEJz
         MnCWmomut2S7hslS5OQRjf2kREufm5ukaEutUuKftqaefDlaKwxJrxcyI9IPCCx+Im
         ugtMbr7f0Czixz2hzbuWmCuYA90j0y3AdrYKOKPfpThPzZQSMR/fMBhCuErSks5awd
         hjQ3AGMOlQovQ==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] MAINTAINERS: add mvpp2 driver entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800184815.22481.6841753296877608212.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:10:48 +0000
References: <20201211165114.26290-1-mw@semihalf.com>
In-Reply-To: <20201211165114.26290-1-mw@semihalf.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        mcroce@microsoft.com, sven.auhagen@voleatech.de, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Dec 2020 17:51:14 +0100 you wrote:
> Since its creation Marvell NIC driver for Armada 375/7k8k and
> CN913x SoC families mvpp2 has been lacking an entry in MAINTAINERS,
> which sometimes lead to unhandled bugs that persisted
> across several kernel releases.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> 
> [...]

Here is the summary with links:
  - [v2] MAINTAINERS: add mvpp2 driver entry
    https://git.kernel.org/netdev/net-next/c/2aa899ebd5c3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


