Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB661A736
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 04:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiKEDKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 23:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKEDKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 23:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A95826AD4;
        Fri,  4 Nov 2022 20:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E28ED623AE;
        Sat,  5 Nov 2022 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37A23C433D6;
        Sat,  5 Nov 2022 03:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667617817;
        bh=nhpq3hxAK2wGS+j94s5Pcnje7u22mnXK8DftPTzq/aI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k23VnWodDWZgwsuaY6QbRqH44NDumZ6cSZwyPUSLi9ioCCl90v6JRfpqoJjUiAwcM
         4p+kdnrXSq4UeynwF1JK9sw6/aRaG4HzJJI1cn4dXNEgndLwrGX4bw9DUSNslvIMSj
         oAQ/A5XxiEB1cimQ+S/aPEoJxnj5U3LvhVhU2V0vdhl3REMnl+AkpIr5z0T5iaqPwl
         Ma07EyCrp7vZJ1qmKmZnunUQd8fBkqGTXQ3fq3Jlj7Q8g33CfH55sstaBCmXTt67lP
         ODcDj8g7xXWr32c6EoCLcaugbZBQ3NxAYXarGzrZTG4UKWw/4QE9cYRQlOznEEE/i8
         suWUipx9v7J1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C0D4E270FB;
        Sat,  5 Nov 2022 03:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] octeon_ep: support Octeon device CNF95N
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166761781710.20771.16670605812386475186.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Nov 2022 03:10:17 +0000
References: <20221103060600.1858-1-vburru@marvell.com>
In-Reply-To: <20221103060600.1858-1-vburru@marvell.com>
To:     Veerasenareddy Burru <vburru@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lironh@marvell.com, aayarekar@marvell.com, sedara@marvell.com,
        sburla@marvell.com, linux-doc@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 2 Nov 2022 23:05:57 -0700 you wrote:
> Add support for Octeon device CNF95N.
> CNF95N is a Octeon Fusion family product with same PCI NIC
> characteristics as CN93 which is currently supported by the driver.
> 
> update supported device list in Documentation.
> 
> Signed-off-by: Veerasenareddy Burru <vburru@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v4] octeon_ep: support Octeon device CNF95N
    https://git.kernel.org/netdev/net-next/c/63d9e1291484

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


