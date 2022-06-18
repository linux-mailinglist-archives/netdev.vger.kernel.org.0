Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4DF55027C
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 05:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiFRDaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 23:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbiFRDaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 23:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7452A69CF9
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 20:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F59261FB0
        for <netdev@vger.kernel.org>; Sat, 18 Jun 2022 03:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61A11C341C0;
        Sat, 18 Jun 2022 03:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655523013;
        bh=LF5RKYltUxmTKQzW4lZoTH3Pr70TPRQVyS6U9ykwbtI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TRlV4NDOrpw66F0HR7khxmqjzft1SHyTMWo3VHbCccMjCzFjxzXc2HHch570QuhIi
         VOIIMJmcKCIwqo/wwgIxBJ+wie8ju47qDSJOJ+iOfFL0//pkDz/WbR7yMKDisikKM+
         MsBZw+ZyPcl41PwqCvVNc21FGtod86Q8Vv0ewcRCwy67yfTyCuJD2nz6U5Mq1AQRR3
         8EpcmAGW/1+jOQjpgHaziFedH11Gv465VUjs9AkJFPrezeVNIbFgq54JQuhxcR2qT6
         7Nx3V2u2Hb3LF0pacX0Ie5/+KvVs5L87yQrEhyiS6xQi0gRN+8arvPb2w66Kys2Wbc
         V8sqNJetQ7LMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45AAFFD99FF;
        Sat, 18 Jun 2022 03:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552301328.7046.16210340079386639846.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 03:30:13 +0000
References: <9400.1655407960@famine>
In-Reply-To: <9400.1655407960@famine>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, jtoppins@redhat.com,
        dingtianhong@huawei.com, vfalico@gmail.com, andy@greyhouse.net
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 12:32:40 -0700 you wrote:
> The bonding ARP monitor fails to decrement send_peer_notif, the
> number of peer notifications (gratuitous ARP or ND) to be sent. This
> results in a continuous series of notifications.
> 
> 	Correct this by decrementing the counter for each notification.
> 
> Reported-by: Jonathan Toppins <jtoppins@redhat.com>
> Signed-off-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Fixes: b0929915e035 ("bonding: Fix RTNL: assertion failed at net/core/rtnetlink.c for ab arp monitor")
> Link: https://lore.kernel.org/netdev/b2fd4147-8f50-bebd-963a-1a3e8d1d9715@redhat.com/
> 
> [...]

Here is the summary with links:
  - [net] bonding: ARP monitor spams NETDEV_NOTIFY_PEERS notifiers
    https://git.kernel.org/netdev/net/c/7a9214f3d88c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


