Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 568235F0AEC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiI3LpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbiI3Lop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:44:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395C291DB6
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7AE5622FA
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 459C6C43143;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664538018;
        bh=2P8eHp42TBugs7ee4z8rBuHizSvf3gd9RgScy6UFPME=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hgu8nplbbItaE+7gII4WqkupR/d0ahngcoLbb1R0ifC+HxoYHRhqKDk5I6UwEHre8
         2GMSfWgF9SxuCQDhyItGKmN//ehjuePhIZ3+EIcdoc5ujp6a/DRe/bVrMjX5NUJR6y
         IGigi4vq3dFkE+bsL/rt2VFE50RzrAfwgisDSggpyqDv7YdG8IIpsyV+jHX83khhHD
         OmwU2puC0q31+mcddFf02GNpm0GJFmtbRsSzEaMNBWRnEArhoz8ELQjLKeIm5grHGV
         Cofph701scvDvBzLKybdtpwbGAYjQww2qzX/k/whM9/fiP2F5UKlVoMTHn4+RKrGeu
         j3earqTPgIZww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3009BE49FA5;
        Fri, 30 Sep 2022 11:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2] net: bonding: Convert to use
 sysfs_emit()/sysfs_emit_at() APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453801819.4225.4902311082470980675.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:40:18 +0000
References: <1664368214-11462-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1664368214-11462-1-git-send-email-wangyufen@huawei.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Sep 2022 20:30:14 +0800 you wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the value
> to be returned to user space.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  drivers/net/bonding/bond_sysfs.c       | 106 ++++++++++++++++-----------------
>  drivers/net/bonding/bond_sysfs_slave.c |  28 ++++-----
>  2 files changed, 67 insertions(+), 67 deletions(-)

Here is the summary with links:
  - [net-next,v2] net: bonding: Convert to use sysfs_emit()/sysfs_emit_at() APIs
    https://git.kernel.org/netdev/net-next/c/96e0718165a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


