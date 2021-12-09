Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1C246EC6E
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239905AbhLIQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:03:46 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51674 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235371AbhLIQDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:03:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B79CCE26C5;
        Thu,  9 Dec 2021 16:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 861F2C004DD;
        Thu,  9 Dec 2021 16:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639065609;
        bh=b2oJrwonEquCfIzXhozEbw55cqkLK2BkARfn7t/jLGs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q7OmcZsAKmTZrQA11oPIbHVB3Y7ftoIjrrW/J5trKZ9+xrmBDHvl1/oZn65a6Pw7A
         IjylmQW0R8TcTWwrNNA3cc90rrzXANF6ulpoalA/hOqXzOaop272DagU9f7E5F6M3N
         Z9yOu32l8/cjb9MIJ5MAa5+Ht5BRoaczRuOkqzM2iv2nodSiI72QGeHHgV/L7vaks1
         A53Lvw4pPQDaLo8TjEaqR9ON1cgxBF9Ib8tonyo47JsqXQ2C80ZLTqVG/nezixDm1U
         nbbIuouvQhlkMsNBBrYLQxFRnnQizrv1Tz/AlOBu/PR3b9Y/FxDgjobwO6bSHcg2B1
         K8kxZQ96RCCgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 717EF60A54;
        Thu,  9 Dec 2021 16:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: fix segfault in nfc_genl_dump_devices_done
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906560946.14007.9068116924167275493.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:00:09 +0000
References: <20211208182742.340542-1-tadeusz.struk@linaro.org>
In-Reply-To: <20211208182742.340542-1-tadeusz.struk@linaro.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     netdev@vger.kernel.org, krzysztof.kozlowski@canonical.com,
        davem@davemloft.net, kuba@kernel.org, stable@vger.kernel.org,
        syzbot+f9f76f4a0766420b4a02@syzkaller.appspotmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Dec 2021 10:27:42 -0800 you wrote:
> When kmalloc in nfc_genl_dump_devices() fails then
> nfc_genl_dump_devices_done() segfaults as below
> 
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 PID: 25 Comm: kworker/0:1 Not tainted 5.16.0-rc4-01180-g2a987e65025e-dirty #5
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-6.fc35 04/01/2014
> Workqueue: events netlink_sock_destruct_work
> RIP: 0010:klist_iter_exit+0x26/0x80
> Call Trace:
> <TASK>
> class_dev_iter_exit+0x15/0x20
> nfc_genl_dump_devices_done+0x3b/0x50
> genl_lock_done+0x84/0xd0
> netlink_sock_destruct+0x8f/0x270
> __sk_destruct+0x64/0x3b0
> sk_destruct+0xa8/0xd0
> __sk_free+0x2e8/0x3d0
> sk_free+0x51/0x90
> netlink_sock_destruct_work+0x1c/0x20
> process_one_work+0x411/0x710
> worker_thread+0x6fd/0xa80
> 
> [...]

Here is the summary with links:
  - nfc: fix segfault in nfc_genl_dump_devices_done
    https://git.kernel.org/netdev/net/c/fd79a0cbf0b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


