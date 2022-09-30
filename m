Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1350B5F0ABC
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 13:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiI3LjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 07:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbiI3Lia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 07:38:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 852DCDAF03
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 04:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4F24B81CFD
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8264AC433D7;
        Fri, 30 Sep 2022 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664537416;
        bh=Za0vMh0Gwoh5o58FBiw3Q+g61n03cIb0XZMh1qYvD8I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UEeuQVJRpd/qXOVmbKfIyBtYHbDN/9Txi7KDBdN+o7uom59udG3op0yotbQHrlm0J
         wj7i1wxt3DQf8SNBy3flqLN/YK8qnB1I0hg9An3iYHJtWxnniinWr2eFUCQ1Iuoi/5
         byCLMOKe2hJrBMFi+xTFnTF2ndu7ReqxjRH9+9ym2orteIQeEauKB2vMutvZ5PAcZA
         glgwHNNgr2HimZuFF4Jfizbopdmztmg/v9ZIa6WterlXHpMzTvbjszVThkLEU3LjoU
         dpM8h4pRvRmE9ati8B+XWBXDWbezEfleJAURuu+vbaeC2MV/6j3iM9ahTUZxg+2pKh
         W+Z9e7dO23iIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C0D2C395DA;
        Fri, 30 Sep 2022 11:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 1/2] net: tun: Convert to use sysfs_emit() APIs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166453741643.29464.4938868177986354579.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Sep 2022 11:30:16 +0000
References: <1664365784-31179-1-git-send-email-wangyufen@huawei.com>
In-Reply-To: <1664365784-31179-1-git-send-email-wangyufen@huawei.com>
To:     wangyufen <wangyufen@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 28 Sep 2022 19:49:43 +0800 you wrote:
> Follow the advice of the Documentation/filesystems/sysfs.rst and show()
> should only use sysfs_emit() or sysfs_emit_at() when formatting the value
> to be returned to user space.
> 
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
>  drivers/net/tun.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [net-next,1/2] net: tun: Convert to use sysfs_emit() APIs
    https://git.kernel.org/netdev/net-next/c/aff3069954ef
  - [net-next,2/2] net-sysfs: Convert to use sysfs_emit() APIs
    https://git.kernel.org/netdev/net-next/c/73c2e90a0edc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


