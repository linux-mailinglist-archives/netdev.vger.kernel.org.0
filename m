Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CACB5EB677
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiI0AuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiI0AuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA8C3F1D8
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 17:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50846150C
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 00:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 33E9EC433C1;
        Tue, 27 Sep 2022 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664239818;
        bh=ljozSzyz6y9DHBabFdLygQQeDOlJUa/8VecVImyGe0g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tf/SeUrzQdeFx72n+rIqdjHLopVaF90rc0Ip27FZdeLFiejufHCjP3a7ErnyQzDxJ
         rsKKWALNav+JbQK2Pev6t3kFaAdpfidtO++4e89kH/jbWJyYeTF5wLdMg6Ubo3AK9g
         gNTqRpnnQsWc9AkHkWJqQj4KCmLGX4tSsyI0NiQm2Wc6LUkKBIdG7qSScR1Afrz4j2
         Dwh+o+ULqhGr1cQvt3MmvXQWoJFcUTxO0a27uyc3qbYLhSYacmZGzDT9viGyr3wtKg
         sBoZ9zfDW5nswZQhmhY2QQQEh7G1wVQ4E7y7ejKnn52FQb4KmrX0rwYtVsNGpK5KGA
         i2iXkH1ytrSPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0C3BEE21EC5;
        Tue, 27 Sep 2022 00:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: dsa: remove unnecessary
 i2c_set_clientdata()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166423981804.26881.9485732762058666260.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 00:50:18 +0000
References: <20220923143742.87093-1-yangyingliang@huawei.com>
In-Reply-To: <20220923143742.87093-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, woojung.huh@microchip.com,
        Arun.Ramadoss@microchip.com, george.mccollister@gmail.com,
        davem@davemloft.net, kuba@kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 22:37:39 +0800 you wrote:
> This patchset https://lore.kernel.org/all/20220921140524.3831101-8-yangyingliang@huawei.com/T/
> removed all set_drvdata(NULL) in driver remove function.
> 
> i2c_set_clientdata() is another wrapper of set drvdata function, to follow
> the same convention, remove i2c_set_clientdata() called in driver remove
> function in drivers/net/dsa/.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: dsa: lan9303: remove unnecessary i2c_set_clientdata()
    https://git.kernel.org/netdev/net-next/c/db5d451c4640
  - [net-next,2/3] net: dsa: microchip: ksz9477: remove unnecessary i2c_set_clientdata()
    https://git.kernel.org/netdev/net-next/c/008971adb95d
  - [net-next,3/3] net: dsa: xrs700x: remove unnecessary i2c_set_clientdata()
    https://git.kernel.org/netdev/net-next/c/6387bf7c390a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


