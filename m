Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C024738F4EE
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233968AbhEXVbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:31:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233859AbhEXVbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 40F4F61411;
        Mon, 24 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621891810;
        bh=ndaxLsaJgNKt8FeEudg8lqLUhJnV8xc2IzazzOki4b0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aFrF3h0EDfFGD5jg9j0PQiswdkf/AWoAA+4szwOO9kGvsItmMQT3phpKmxraMeYrJ
         1bkz+pQNY51CcfUWH/1yTmPVRsIuGEjgUFDwQ/VsOxpF+xERmSf6p4+VAhSBGUlc4m
         W746JJnmYCn+7m/PXi1eLUGrWIeNB8QKhxMnvoR65BlvaVGJDl/yVFVu7W4JrooU7k
         A1irx7+/OC0SNJKMywvVqJfwFpGfHJKBqFi2knMQCSTiDZKX87T6n3/CmR8YhMf919
         mC90GgOlODnAoh5gv/qlJWGc0uQLE2nO2BhBJSnu8HaRdAMSK0AW8vmieZjO847G9w
         Fapai3jUUpSdg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3614B60BCF;
        Mon, 24 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: fix memory leak in smsc75xx_bind
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162189181021.16512.10408929378825905994.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 21:30:10 +0000
References: <20210524200208.31621-1-paskripkin@gmail.com>
In-Reply-To: <20210524200208.31621-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     steve.glendinning@shawell.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@kernel.vger.org,
        syzbot+b558506ba8165425fee2@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 23:02:08 +0300 you wrote:
> Syzbot reported memory leak in smsc75xx_bind().
> The problem was is non-freed memory in case of
> errors after memory allocation.
> 
> backtrace:
>   [<ffffffff84245b62>] kmalloc include/linux/slab.h:556 [inline]
>   [<ffffffff84245b62>] kzalloc include/linux/slab.h:686 [inline]
>   [<ffffffff84245b62>] smsc75xx_bind+0x7a/0x334 drivers/net/usb/smsc75xx.c:1460
>   [<ffffffff82b5b2e6>] usbnet_probe+0x3b6/0xc30 drivers/net/usb/usbnet.c:1728
> 
> [...]

Here is the summary with links:
  - net: usb: fix memory leak in smsc75xx_bind
    https://git.kernel.org/netdev/net/c/46a8b29c6306

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


