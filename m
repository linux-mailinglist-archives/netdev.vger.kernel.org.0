Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783263317FE
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbhCHUAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:54842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231613AbhCHUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:00:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3451165272;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615233609;
        bh=L8Bi9QBES5QtOxxCg4XDoKzq4ycT/SESC3cVzHHi7KA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATrEgwsTbjB9VKZyIB78EJ+Uz8Tv6vS2CsdnzYtHWWtq5NF3DSb/H5kPUlfL4Lm6x
         h/5Q2HKF6mh+QXQsBz2cdYdgFreQ7jbLMnTHct1qcCCDAm6LmYXZ0zlEu9Ay6FNxsD
         8qi1wtiOf+yDxkIa8Bvx/aVun/JYLMCO+Uj0vAgDkSEL0SZ3dnK1po3++Kg5lkMsKZ
         nqLf7BlwoUf+c8CEYbDYcKB1cXxXY6huZ+PFM3cIZXiTwVt15mlsryVvcMO5CGOeRY
         vYPE+nYKPCIFaqju7mq5A5EhWWj/mfN8fnoukirNKiGpQT5rKK7iZxrdfi4DSDvz4M
         p/FJsMF9gwygw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2A96A60A57;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: usb: log errors to dmesg/syslog
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523360917.22994.9175927751897526036.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:00:09 +0000
References: <20210306221232.3382941-2-grundler@chromium.org>
In-Reply-To: <20210306221232.3382941-2-grundler@chromium.org>
To:     Grant Grundler <grundler@chromium.org>
Cc:     oneukum@suse.com, kuba@kernel.org, roland@kernel.org,
        nic_swsd@realtek.com, netdev@vger.kernel.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  6 Mar 2021 14:12:32 -0800 you wrote:
> Errors in protocol should be logged when the driver aborts operations.
> If the driver can carry on and "humor" the device, then emitting
> the message as debug output level is fine.
> 
> Signed-off-by: Grant Grundler <grundler@chromium.org>
> ---
>  drivers/net/usb/usbnet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - [net-next] net: usb: log errors to dmesg/syslog
    https://git.kernel.org/netdev/net/c/4d8c79b7e9ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


