Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB08653F1EF
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 00:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbiFFWEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 18:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbiFFWEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 18:04:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D54833F;
        Mon,  6 Jun 2022 15:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07D1960A21;
        Mon,  6 Jun 2022 22:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 571F3C3411D;
        Mon,  6 Jun 2022 22:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654553069;
        bh=pcU7MMJhbHLVJcZH22KwvHFDITSCSB1DObcIzkin+nk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OvB9PWHE70USGE8IlRpY+INQcKWJACJ4tBihs7Zn3Jk22BDHhOjCU8R+JCagxZX3N
         +O6qxYVa0UCVLk3xUaz2kao0SmTbmHQfYQ2ueH5egUwJ105mO0gEyUPYjYK5QXngIB
         YoHk0/ngz6yr8EQM/sXJPp+IPalvLBtp6DkLQ3caqY3PubzOMVtE6EQvPV/MBvxYra
         fYlgPqKgIMHpsDDfNcjW5R0ekhqq9PlovlAY2lwFCFetjfSVN9CpPGszfp2JW5sZ4Y
         +CuAUAC4ahKzraZ1PkXeSHP5dc5Pf64TH9uLnvTrnUYjBKROJaFx497QljR89jjSqV
         u5p3LGpxRFmPA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 32DB8E737ED;
        Mon,  6 Jun 2022 22:04:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: ethernet: bgmac: Fix refcount leak in
 bcma_mdio_mii_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165455306920.27266.6098747312199049626.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Jun 2022 22:04:29 +0000
References: <20220603133238.44114-1-linmq006@gmail.com>
In-Reply-To: <20220603133238.44114-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, f.fainelli@gmail.com, arnd@arndb.de,
        jon.mason@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  3 Jun 2022 17:32:38 +0400 you wrote:
> of_get_child_by_name() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when not need anymore.
> Add missing of_node_put() to avoid refcount leak.
> 
> Fixes: 55954f3bfdac ("net: ethernet: bgmac: move BCMA MDIO Phy code into a separate file")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: ethernet: bgmac: Fix refcount leak in bcma_mdio_mii_register
    https://git.kernel.org/netdev/net/c/b8d91399775c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


