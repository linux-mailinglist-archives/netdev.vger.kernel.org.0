Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBC3331A9A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 00:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhCHXAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 18:00:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:33444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhCHXAI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 18:00:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DC62F6528A;
        Mon,  8 Mar 2021 23:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615244407;
        bh=4KvtxQQjLO5Q7FLFNDWpxrmRU8aRg63axlvNACF16nA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g2CWhHv4Nqzy5ThTU7zrpe2nJjRdJpRHAmBHaQ7DCuuRlhZGpWBHm9E8uQ3VGauLQ
         UPG0Se9+ueB2EXdsYB/9J0BlMhp4fcYPP2In377/IvHhIzDad0CaIRZ8Sa/LJD+bUq
         C7ZzLZm2dwxjWaME6JcrLeT25TTPCVPrwC1Jvp+A9Wg+9xpKlFXKn+GIGFs8niXoF3
         Vh5RVLsPPyeLc2iU6nxofb4R/eEJE6HzBhDGXFBwysCoCZMgNI9Fqy4Y188OqCdOHJ
         sJ0ayAoi+ulwtXW50KSPhfQGEmZWXGNn3psi7SuVatcTBjoUwFp0rrbRcbSgd59HHZ
         oIKzHYwwXdSBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CE36E60952;
        Mon,  8 Mar 2021 23:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bonding: fix error return code of bond_neigh_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161524440784.4208.10501513000794222877.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 23:00:07 +0000
References: <20210308031102.26730-1-baijiaju1990@gmail.com>
In-Reply-To: <20210308031102.26730-1-baijiaju1990@gmail.com>
To:     Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  7 Mar 2021 19:11:02 -0800 you wrote:
> When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
> return code of bond_neigh_init() is assigned.
> To fix this bug, ret is assigned with -EINVAL in these cases.
> 
> Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: bonding: fix error return code of bond_neigh_init()
    https://git.kernel.org/netdev/net/c/2055a99da8a2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


