Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA47A3D135A
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 18:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbhGUP3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 11:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231727AbhGUP33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 11:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EBA7261245;
        Wed, 21 Jul 2021 16:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626883806;
        bh=9po4yHoqMYC7yQEp4hXhHwButVoTm8asp6b6zFpG190=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i1pp6A/+1HaTGhIDRl5RSZVvJKnDaluWox7ByBGakNQF2DwZaQ8k490JARPyDqJ0J
         IV5176XqnR5C18u4lDdwuqOpSVel2BwiwfM81vA7+4GJQ2aPauy6sA9klqtI8EmeZ9
         J5FwV6FzuTnZ1sNFpayMh7tEvWYx/s5y2fnO1if+jdlROs16o4es8Cnj3GUqa5iUrD
         BFy7JdAQQJhCo4GC69gHiBBj0g/MJcshVyoQbTh8m6S+GHjmBdn6Pgu0ZB3kcGehaZ
         DaP8v87bBKRlE26/wJ+q94sugb+KhsvivKY0LkJVP4plJw3kIN8KPltTQmVDrrzF4I
         jX52MBBPma2OA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DFFAD60A4E;
        Wed, 21 Jul 2021 16:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND PATCH V3 1/2] usb: hso: fix error handling code of
 hso_create_net_device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162688380591.30339.10495926052970334831.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Jul 2021 16:10:05 +0000
References: <20210721081510.1516058-1-mudongliangabcd@gmail.com>
In-Reply-To: <20210721081510.1516058-1-mudongliangabcd@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        johan@kernel.org, oneukum@suse.com, jirislaby@kernel.org,
        kernel@esmil.dk, dan.carpenter@oracle.com, mail@anirudhrb.com,
        syzbot+44d53c7255bb1aea22d2@syzkaller.appspotmail.com,
        rkovhaev@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Jul 2021 16:14:56 +0800 you wrote:
> The current error handling code of hso_create_net_device is
> hso_free_net_device, no matter which errors lead to. For example,
> WARNING in hso_free_net_device [1].
> 
> Fix this by refactoring the error handling code of
> hso_create_net_device by handling different errors by different code.
> 
> [...]

Here is the summary with links:
  - [RESEND,V3,1/2] usb: hso: fix error handling code of hso_create_net_device
    https://git.kernel.org/netdev/net-next/c/788e67f18d79
  - [RESEND,V3,2/2] usb: hso: remove the bailout parameter
    https://git.kernel.org/netdev/net-next/c/dcb713d53e2e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


