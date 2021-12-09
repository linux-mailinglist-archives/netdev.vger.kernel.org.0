Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B126846E0BB
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbhLICNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:13:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42488 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229835AbhLICNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:13:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B6F8CE24A0;
        Thu,  9 Dec 2021 02:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85E89C00446;
        Thu,  9 Dec 2021 02:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639015809;
        bh=VXUsDyDJoOr+tj/YnS1eAx45iTBeRMtTx1y5bb6bnGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pkhsElEWgtdu2RyAUw7qNBgLa7w9xcn5yBS7pKG6R40VVWF5yb58ucqvrx7eAL4lz
         Mi6mZHom09WgJl22cS+PpQXX2H2zNkQHYOoTzC6OxgI4MjFq+RYcOffyOoXnHr161j
         EmahUCoxPFVh2wXl4GehKUY0cQRxJJ5cmKwQNxKR7glObvOgMCy5m39k/PDk9ZxiTI
         hLqs0H1BZpTd5CKZtl5BAeCqD/yTiXClpC9J6ZUnXoCuClygJxHcPEoqdcit1SFDhH
         /avvd0bgfFmAX0JNPs5fqnP7dd9rhSjfleB+8m3IsOGrDo3tUbmYOT/w8nmlxamwjQ
         M7vd9bOc5HDQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6A9BE60A36;
        Thu,  9 Dec 2021 02:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] vmxnet3: fix minimum vectors alloc issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901580943.22374.8688111636911326175.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 02:10:09 +0000
References: <20211207081737.14000-1-doshir@vmware.com>
In-Reply-To: <20211207081737.14000-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, gyang@vmware.com, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 7 Dec 2021 00:17:37 -0800 you wrote:
> 'Commit 39f9895a00f4 ("vmxnet3: add support for 32 Tx/Rx queues")'
> added support for 32Tx/Rx queues. Within that patch, value of
> VMXNET3_LINUX_MIN_MSIX_VECT was updated.
> 
> However, there is a case (numvcpus = 2) which actually requires 3
> intrs which matches VMXNET3_LINUX_MIN_MSIX_VECT which then is
> treated as failure by stack to allocate more vectors. This patch
> fixes this issue.
> 
> [...]

Here is the summary with links:
  - [net-next] vmxnet3: fix minimum vectors alloc issue
    https://git.kernel.org/netdev/net/c/f71ef02f1a4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


