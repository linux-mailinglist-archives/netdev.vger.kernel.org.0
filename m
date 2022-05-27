Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF2E15359F7
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 09:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346057AbiE0HKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 03:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345267AbiE0HKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 03:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4808F68A6;
        Fri, 27 May 2022 00:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EE57B82373;
        Fri, 27 May 2022 07:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2B887C34100;
        Fri, 27 May 2022 07:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653635413;
        bh=VfQljeW8VSYce8YPJcbQdzZsTyI0fH78WhfERJkS1Jo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FHj7hGttXyWLduFDWcuKu1EZFwdcy8c73t3a5GkGR3g50eTu/oMfv3BFsYVYpZGPC
         9a0pDntETzVxSBECHF0OnizJheKTgTpqPNzfLEqLih/sk6pMfh4L4JY6PfErs0A1Ri
         OH0gjezBcHYbv7Ueg44T6qiBD27CFJVEXEq5IY7E4jr6098C+CHrnJFx0q7Y9v5AIJ
         y7J1QJ1q2kLi/WM+5kupvhnFHLm2gHmG5zHGs05cTDlpRsO8wWFbkp8YuAjqTyfx1K
         VmTvdVUzUKoSxru2+bnTeO5IQEKGAp1meiV8YZwG9D81/dEZ07tErHTI+RE9fdrqaP
         8yQ1ZC6OlZ5Ig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FD2FF03944;
        Fri, 27 May 2022 07:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: Fix refcount leak in
 mv88e6xxx_mdios_register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165363541306.15180.11215142620498870991.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 07:10:13 +0000
References: <20220526145208.25673-1-linmq006@gmail.com>
In-Reply-To: <20220526145208.25673-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 26 May 2022 18:52:08 +0400 you wrote:
> of_get_child_by_name() returns a node pointer with refcount
> incremented, we should use of_node_put() on it when done.
> 
> mv88e6xxx_mdio_register() pass the device node to of_mdiobus_register().
> We don't need the device node after it.
> 
> Add missing of_node_put() to avoid refcount leak.
> 
> [...]

Here is the summary with links:
  - [v3] net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
    https://git.kernel.org/netdev/net/c/02ded5a17361

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


