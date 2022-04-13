Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E20B74FF617
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235321AbiDMLwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiDMLwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:52:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5F92DA96;
        Wed, 13 Apr 2022 04:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 330C061DF3;
        Wed, 13 Apr 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8C28AC385A3;
        Wed, 13 Apr 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649850611;
        bh=THqDCvLfnB4Vl1fsgGQlKexdh/6abOcTHlctLXK8bvM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oOe9AUwS4wBUyP9HT1IJCgdIWbZGkyVYJy6nO2XYqq+9L5VUlJXoBX4iNCCtmYrnc
         5RcrTCLHsdsjyqYXRuckuvT7F5rFa1TgyGHXhU+1tSYQQK4Yco9/pqgaC7pB0CZ2wt
         jEO2HCNQVmLjVf/gv7+Hb2A9mNiuyAWWOR4VFDsBlY4ZYzPhWWZExSIx+nau/lHwKf
         yLwrfnscdKcMTKQDwX2oa7NiRblAOSkSOfLg9BkTmjJZ/tW2atBqnpA7eiw+klCbPv
         EqQmpj0DwAvQf85Gle0MLsyDIWEaqPPwfqwWROIrPM4VyhufKt3b9XhDYgqDzIuBRj
         Yron797RQMJlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 65FB2E8DD5E;
        Wed, 13 Apr 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ftgmac100: access hardware register after clock ready
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985061139.24768.4926200477271415631.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:50:11 +0000
References: <20220412114859.18665-1-dylan_hung@aspeedtech.com>
In-Reply-To: <20220412114859.18665-1-dylan_hung@aspeedtech.com>
To:     Dylan Hung <dylan_hung@aspeedtech.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        guoheyi@linux.alibaba.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, yangyingliang@huawei.com, joel@jms.id.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        BMC-SW@aspeedtech.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Apr 2022 19:48:59 +0800 you wrote:
> AST2600 MAC register 0x58 is writable only when the MAC clock is
> enabled.  Usually, the MAC clock is enabled by the bootloader so
> register 0x58 is set normally when the bootloader is involved.  To make
> ast2600 ftgmac100 work without the bootloader, postpone the register
> write until the clock is ready.
> 
> Fixes: 137d23cea1c0 ("net: ftgmac100: Fix Aspeed ast2600 TX hang issue")
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> 
> [...]

Here is the summary with links:
  - net: ftgmac100: access hardware register after clock ready
    https://git.kernel.org/netdev/net/c/3d2504524531

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


