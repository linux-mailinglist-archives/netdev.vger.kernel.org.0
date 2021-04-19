Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86506364E87
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhDSXUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:20:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229723AbhDSXUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B8FEF61029;
        Mon, 19 Apr 2021 23:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618874408;
        bh=Mka3d0H9tODgbsi3UC/E+x954bjUDtO9sLOf7RbSIks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XPgzf2L32co6dbaNqMrqDZI0Z5cODPedz9Z5ks85YeIfE5wplsj6pABCPkbpkSg3M
         nfzdY170gLZS4JnY2pizcJSx8L63XURDusnN9fuQJ4l1jVI8WBxKBEBlAq0Jm1NfY7
         Cryme9m5uqiAtSPcU08FzkVNpIBksfCBsZv4eGTiginxBwu4nPWe8z28USQvmzlq4C
         WrpNI8CZztO0/jdaKfjrzsXlhYmdqIWS41VsSXMKYNwuUQY6qKJ08M6NDYbr4bvT3z
         sZFZTFvji+A9eMrQtWrjXn1ZyotH/Hkgrd7WxNrZ1sk5S28+b0gJLpeYOLSd/7iNon
         Z90kWsP7xA0rg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A966260A0B;
        Mon, 19 Apr 2021 23:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net-next] net: marvell: prestera: add support for AC3X
 98DX3265 device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887440868.5975.9264539900149145693.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:20:08 +0000
References: <20210416231751.17652-1-vadym.kochan@plvision.eu>
In-Reply-To: <20210416231751.17652-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mickeyr@marvell.com,
        vkochan@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 17 Apr 2021 02:17:51 +0300 you wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> Add PCI match for AC3X 98DX3265 device which is supported by the current
> driver and firmware.
> 
> Signed-off-by: Vadym Kochan <vkochan@marvell.com>
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next] net: marvell: prestera: add support for AC3X 98DX3265 device
    https://git.kernel.org/netdev/net-next/c/ced97eea3974

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


