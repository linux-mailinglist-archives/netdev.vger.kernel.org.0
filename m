Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4A238F43D
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 22:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhEXUVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 16:21:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:47756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233079AbhEXUVi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 16:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1047D6141A;
        Mon, 24 May 2021 20:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621887610;
        bh=E8TX+IzIzGjUSD9qVd+RzLohf3ZOA7PPDZRYaimXkY0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GuKsXZy6NHg7xyybAI8KX5OyeRiu0s8QAcBZjUoxyRMdghXKFu0knrErphNq/qjJb
         uuhGPBEqr1PD5G4WxsnN1RaWuL7llEJ29JAOs1+cTeyc0HST4lF7VDEcgbzNbpLAXy
         wuviShCVcdoaube8yQi4Gywm2cH+Iq7di5AKNZ8Ft2s6zH0LlupnSM+VhJBb5xIGS5
         lx5/qpUNbtCcopApLIFE3t+ysVuPUg6EdKb6FtuXIn542mQNp7yYNemEhxgAu2IbJb
         Kgq8OMeP7kExNU4Cru9HsO9g5aXSSdBgzhtmGSOIwX5/ttIlabaIE9Ag0t/pRHADzA
         HF1TIZkJTWHGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00BAF60CD4;
        Mon, 24 May 2021 20:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hso: fix control-request directions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162188760999.19394.15297874086454377579.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 20:20:09 +0000
References: <20210524092511.4657-1-johan@kernel.org>
In-Reply-To: <20210524092511.4657-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 11:25:11 +0200 you wrote:
> The direction of the pipe argument must match the request-type direction
> bit or control requests may fail depending on the host-controller-driver
> implementation.
> 
> Fix the tiocmset and rfkill requests which erroneously used
> usb_rcvctrlpipe().
> 
> [...]

Here is the summary with links:
  - [net] net: hso: fix control-request directions
    https://git.kernel.org/netdev/net/c/1a6e9a9c68c1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


