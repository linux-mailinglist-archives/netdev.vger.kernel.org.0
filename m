Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4625F2B7106
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 22:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbgKQVkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 16:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:56758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725779AbgKQVkG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 16:40:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605649205;
        bh=K8eG/03No4/XChYqBHJ4IuMzj8dTr5AOrWF/h+S4erg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=knV2Z282xqVCEWgvPJ9wHikURIg7Cpj6OJLYQYFAAiZEcPMoB0htKvYcs94hsIZ0C
         b2MsJC2FuZaIBRno5k8kS2Bx2cuHG55JnAfHDFYZoBVj8FOrdlkenN6uvEaPGaHnE3
         loVU3DyA60RCLIwAVGQbOQs1m7NKg0ah4X3fsz3w=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RFC] net: wan: Delete the DLCI / SDLA drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160564920559.32260.9743051487863534241.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Nov 2020 21:40:05 +0000
References: <20201114150921.685594-1-xie.he.0141@gmail.com>
In-Reply-To: <20201114150921.685594-1-xie.he.0141@gmail.com>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mike.mclagan@linux.org,
        arnd@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 14 Nov 2020 07:09:21 -0800 you wrote:
> The DLCI driver (dlci.c) implements the Frame Relay protocol. However,
> we already have another newer and better implementation of Frame Relay
> provided by the HDLC_FR driver (hdlc_fr.c).
> 
> The DLCI driver's implementation of Frame Relay is used by only one
> hardware driver in the kernel - the SDLA driver (sdla.c).
> 
> [...]

Here is the summary with links:
  - [net-next,RFC] net: wan: Delete the DLCI / SDLA drivers
    https://git.kernel.org/netdev/net-next/c/f73659192b0b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


