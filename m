Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A76B030B625
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 05:01:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhBBEAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 23:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230168AbhBBEAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 23:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 82A1D64ED3;
        Tue,  2 Feb 2021 04:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612238407;
        bh=zuhCPkf5QFbIWBkMc2pWKRatlh1UIvV/sLTyAQn4Qxg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QaTEPFkJE6fV/hW5FLb6QDbgJt5SFQz0BeGQvq1YHqlgz9htL2tDII4WnbNkmpAvl
         zoMxD7JjGZTBiM96sftCvjDskOl4jsHOgzQFVc4es8X1Oce3rBs2r29la4vOwlJfHW
         iGkhVH7SBAV4xROUvc93MUyjfaP9fXShihKEMks3mrLUEY10P1cBTJyhP41v6ifr03
         qXvs4V3Xef1f4XTd1Lmboz8mD/XmaPexy6XJipM159DTK0ACtMD/Y/wuGxMiQ0isvT
         zJjpH+se9XN+uhme5QBT1TCkAaYbiXtbXK7AtKmfuVLUuMKyz0obXLb5bv/fbr5RFS
         XwdrejZakLsHw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6D197609D7;
        Tue,  2 Feb 2021 04:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/1] vsock: fix the race conditions in multi-transport
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161223840744.29348.6975246146992657399.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Feb 2021 04:00:07 +0000
References: <20210201084719.2257066-1-alex.popov@linux.com>
In-Reply-To: <20210201084719.2257066-1-alex.popov@linux.com>
To:     Alexander Popov <alex.popov@linux.com>
Cc:     davem@davemloft.net, kuba@kernel.org, sgarzare@redhat.com,
        jhansen@vmware.com, stefan@datenfreihafen.org, jeffv@google.com,
        greg@kroah.com, torvalds@linuxfoundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  1 Feb 2021 11:47:19 +0300 you wrote:
> There are multiple similar bugs implicitly introduced by the
> commit c0cfa2d8a788fcf4 ("vsock: add multi-transports support") and
> commit 6a2c0962105ae8ce ("vsock: prevent transport modules unloading").
> 
> The bug pattern:
>  [1] vsock_sock.transport pointer is copied to a local variable,
>  [2] lock_sock() is called,
>  [3] the local variable is used.
> VSOCK multi-transport support introduced the race condition:
> vsock_sock.transport value may change between [1] and [2].
> 
> [...]

Here is the summary with links:
  - [v2,1/1] vsock: fix the race conditions in multi-transport support
    https://git.kernel.org/netdev/net/c/c518adafa39f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


