Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FBFC357781
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhDGWUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhDGWUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D692361182;
        Wed,  7 Apr 2021 22:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617834028;
        bh=rkDaavYWOqsLA80FQfeD64FktxZ9vBDjgDs2spIWCU8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g7JQ9tZ8fE/aph56XXt4VXIIlvpbCrUF+hk7BZLTbCmwrWKMeUo5KmQ/3IO/mCNg3
         Rwuxnef7Wf4EUqztk1MoBKNeNKb/67I7f4+4lVOSOKxHuO4e+4omgFq5GdtGshOfBH
         w0q5xfSrkPHlSaSZp077TGdv0LLfYhFwMPabd6WjRqR6ny9Trv0eJZN2FVd7PGz1G7
         NHu9vN2QK7DH2UnOlJLK/+VbKZKm8T1PWtyAhjRnM6TKKLnt65NyIswMYkHLTcU2fl
         34+1z2t9PBmzpfIFdc5wasrd5wyofNG9DcNKJD/PY+krRYzcB59K9m5qXm7sNFsuYJ
         tF77K+gV8SPnA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CD0EC609B6;
        Wed,  7 Apr 2021 22:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: hso: fix null-ptr-deref during tty device
 unregistration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783402883.11274.17007849600420610230.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:20:28 +0000
References: <20210407172726.29706-1-mail@anirudhrb.com>
In-Reply-To: <20210407172726.29706-1-mail@anirudhrb.com>
To:     Anirudh Rayabharam <mail@anirudhrb.com>
Cc:     davem@davemloft.net, kuba@kernel.org, oneukum@suse.com,
        gregkh@linuxfoundation.org, geert@linux-m68k.org,
        zhengyongjun3@huawei.com, rkovhaev@gmail.com, kernel@esmil.dk,
        jgarzik@redhat.com, alan@lxorguk.ukuu.org.uk,
        syzbot+c49fe6089f295a05e6f8@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  7 Apr 2021 22:57:22 +0530 you wrote:
> Multiple ttys try to claim the same the minor number causing a double
> unregistration of the same device. The first unregistration succeeds
> but the next one results in a null-ptr-deref.
> 
> The get_free_serial_index() function returns an available minor number
> but doesn't assign it immediately. The assignment is done by the caller
> later. But before this assignment, calls to get_free_serial_index()
> would return the same minor number.
> 
> [...]

Here is the summary with links:
  - [v2] net: hso: fix null-ptr-deref during tty device unregistration
    https://git.kernel.org/netdev/net/c/8a12f8836145

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


