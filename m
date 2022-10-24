Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B37BA609E52
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJXJuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbiJXJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:50:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2E3356FB;
        Mon, 24 Oct 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECB4661162;
        Mon, 24 Oct 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 533B0C433C1;
        Mon, 24 Oct 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666605016;
        bh=KkJv9pQMuI9y/XwLw6a+6h5/sOiz+GihvArdXW93g4g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V2Q+SvhXTUHpbdvPu8VO0g0ggFJQjQolsabqSNj0Pd7Both88nVwxYR5CnbH86S4C
         FHuuQcwegCIeuWylbmDE7RFxAlNd+p/hLckQBCyPiRz6jrCmhYLr9PmpHH9zPi7Ta1
         CFGXiGgEbXsz/GkfVNrMsdSSPpI0eukQk+4ojC2n0n4jKf3O2l9ECYwppbTtnNhe9N
         0CwbPNW7KuY5mHGX+8zkx0yaLVAYzKq71SZehfNeMdylBLLkZRJ+fGxqeKnBLno4LF
         iqBSuqPohDup0DKUTKK9khoqkPjVm5uaoWdFKDXfbIbiCOqMs9WkcOPwO3IULVzwiV
         kby0Sq2kwrRUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36168E270DE;
        Mon, 24 Oct 2022 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: fman: Use physical address for userspace
 interfaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660501621.28227.3493718376720166675.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 09:50:16 +0000
References: <20221020155041.2448668-1-sean.anderson@seco.com>
In-Reply-To: <20221020155041.2448668-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, geert@linux-m68k.org,
        madalin.bucur@nxp.com, edumazet@google.com, camelia.groza@nxp.com,
        kuba@kernel.org, andrew@lunn.ch, afd@ti.com,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        madalin.bucur@oss.nxp.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Oct 2022 11:50:41 -0400 you wrote:
> Before 262f2b782e25 ("net: fman: Map the base address once"), the
> physical address of the MAC was exposed to userspace in two places: via
> sysfs and via SIOCGIFMAP. While this is not best practice, it is an
> external ABI which is in use by userspace software.
> 
> The aforementioned commit inadvertently modified these addresses and
> made them virtual. This constitutes and ABI break.  Additionally, it
> leaks the kernel's memory layout to userspace. Partially revert that
> commit, reintroducing the resource back into struct mac_device, while
> keeping the intended changes (the rework of the address mapping).
> 
> [...]

Here is the summary with links:
  - [net,v2] net: fman: Use physical address for userspace interfaces
    https://git.kernel.org/netdev/net/c/c99f0f7e6837

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


