Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3806297E2
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiKOMAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:00:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiKOMAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24257D58
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5E3616E2
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2C882C433D6;
        Tue, 15 Nov 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668513616;
        bh=l6ucSQ1z6D9bQ4qeP+zbpt8fUEKvOEjuUdpR/XHUFnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uXTmjuPKnWWBa6cXBYd/Imi2SOR41zQe5LQd4Hzznvltn1MYtUWrqZLkJadctzLLd
         R69CPCOCCPodoGyrkzWX1BQx16Vw7s5UUrI/iZoHwlOh7wy1jNBdihHMdZuXEFdZZE
         j3dowWht0VOFYlyVBNF7jaycEu4EuN9uJfWIE6ZRIWJl4fwAGA47mOSJINPRjFBXYI
         3XdkvNojAETqyqm6QE13rLabMx0tBd6QPZKth9KbQiGHmmZcpOl4TP2NmrpJ91A7rL
         cs5P+FrLs6KMtcxRPHX+wJ1y+9cbM4wgkGNMfuQgxiHVIvwFRnNFIJvkza61yA6Tqu
         QRTATOJqzDHRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E3D2C395F5;
        Tue, 15 Nov 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net v3] kcm: close race conditions on sk_receive_queue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166851361605.12756.14307645361145537314.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 12:00:16 +0000
References: <20221114005119.597905-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20221114005119.597905-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, wanghai38@huawei.com,
        cong.wang@bytedance.com,
        syzbot+278279efdd2730dd14bf@syzkaller.appspotmail.com,
        shaozhengchao@huawei.com, pabeni@redhat.com, tom@herbertland.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 13 Nov 2022 16:51:19 -0800 you wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> sk->sk_receive_queue is protected by skb queue lock, but for KCM
> sockets its RX path takes mux->rx_lock to protect more than just
> skb queue. However, kcm_recvmsg() still only grabs the skb queue
> lock, so race conditions still exist.
> 
> [...]

Here is the summary with links:
  - [net,v3] kcm: close race conditions on sk_receive_queue
    https://git.kernel.org/netdev/net/c/5121197ecc5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


