Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBEDD6162D5
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbiKBMkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbiKBMkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:40:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACD12A272
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 05:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E7DBB821D8
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 12:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3CAF9C433D7;
        Wed,  2 Nov 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667392816;
        bh=7Ezyt6N/hXKPWgQipANrM2BCMv0KGaym6yayGTKg3sg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j6qSzEsVafdCxY3o0DmxQtJ//g1U7lcC5IxjswM2vBZtobGuqvadPVXXE9fp95zeM
         uudAe0oPWl0maMgSmQtJqiZKeCDkXZdO4585bqxhljLzxfVOPl4ACQhEiRtOim7AJJ
         s7MdvlYXghUeIrDz72i/lJgywleuUIl51f+Yiv0YpAb0ZGx3yGJrCP3MbVwqCxWIMx
         KBBMX4zIHWjqNT7dwmo9/5mvtU8MBtuSit721DBfzuLRVvxnS+sAmFbGBg2djCvl3O
         cGH3bkssi4NWsyONP09j77+gGS/d2/ABjPSJBI/XCxS1j4d3KXyGIGIERsgEC3quR3
         YwK0eZh24dUgQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1825EE270D5;
        Wed,  2 Nov 2022 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] two fixes for mISDN
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166739281609.30188.9839162793341176659.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 12:40:16 +0000
References: <20221031121341.1293978-1-yangyingliang@huawei.com>
In-Reply-To: <20221031121341.1293978-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, isdn@linux-pingi.de, davem@davemloft.net
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 31 Oct 2022 20:13:39 +0800 you wrote:
> This patchset fixes two issues when device_add() returns error.
> 
> Yang Yingliang (2):
>   mISDN: fix possible memory leak in mISDN_register_device()
>   isdn: mISDN: netjet: fix wrong check of device registration
> 
>  drivers/isdn/hardware/mISDN/netjet.c | 2 +-
>  drivers/isdn/mISDN/core.c            | 5 +++--
>  2 files changed, 4 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [1/2] mISDN: fix possible memory leak in mISDN_register_device()
    https://git.kernel.org/netdev/net/c/e7d1d4d9ac0d
  - [2/2] isdn: mISDN: netjet: fix wrong check of device registration
    https://git.kernel.org/netdev/net/c/bf00f5426074

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


