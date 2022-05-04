Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC410519C99
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 12:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347907AbiEDKOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 06:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347963AbiEDKN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 06:13:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 160E255B8
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 03:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D68D561A59
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 10:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2CF37C385B0;
        Wed,  4 May 2022 10:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651659022;
        bh=M/n/EQdMUojN7gQYNAGa+43j2SnOVWtPL2eaidtMl9w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AnkqHk89pjGePKGTrMR7bNAreKQOqQT8dfWgtcQ2iBsZWIfASnzG/eHg3FAx03tBU
         HsI8+AgIVZCUJo4vlBgU42EmLNYRlT6XpgLTYHzM719LWi4hvtrULNgSG54WgH99/b
         99qCfgFoKmnzq5GQH6g7uCGXs4kvNSeM0w5SHoWy5UIXDp+V2vpyXuHfJzRvADyjxq
         q+QQhNBitv/3TmXW0qlf1ctDG8UcYWKZOF3sjdEp9dFHQ3XZ/CGyg0pSfg+QHC72jm
         lU3bFnS4NkP02LsdIGMqIswFmg+SZOks9xlKle6byuDnYX0obNYIPHzgajDrHtTrOk
         SJnH3EhTiue5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1018BF03847;
        Wed,  4 May 2022 10:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/13]: Move Siena into a separate subdirectory
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165165902206.16679.1813803946133834745.git-patchwork-notify@kernel.org>
Date:   Wed, 04 May 2022 10:10:22 +0000
References: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
In-Reply-To: <165165052672.13116.6437319692346674708.stgit@palantir17.mph.net>
To:     Martin Habets <habetsm.xilinx@gmail.com>
Cc:     kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, netdev@vger.kernel.org, ecree.xilinx@gmail.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 04 May 2022 08:49:41 +0100 you wrote:
> The Siena NICs (SFN5000 and SFN6000 series) went EOL in November 2021.
> Most of these adapters have been remove from our test labs, and testing
> has been reduced to a minimum.
> 
> This patch series creates a separate kernel module for the Siena architecture,
> analogous to what was done for Falcon some years ago.
> This reduces our maintenance for the sfc.ko module, and allows us to
> enhance the EF10 and EF100 drivers without the risk of breaking Siena NICs.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/13] sfc: Disable Siena support
    (no matching commit)
  - [net-next,v3,02/13] sfc: Move Siena specific files
    https://git.kernel.org/netdev/net-next/c/6a9b3de82516
  - [net-next,v3,03/13] sfc: Copy shared files needed for Siena (part 1)
    https://git.kernel.org/netdev/net-next/c/6a9b3de82516
  - [net-next,v3,04/13] sfc: Copy shared files needed for Siena (part 2)
    https://git.kernel.org/netdev/net-next/c/6a9b3de82516
  - [net-next,v3,05/13] sfc: Copy a subset of mcdi_pcol.h to siena
    (no matching commit)
  - [net-next,v3,06/13] sfc/siena: Remove build references to missing functionality
    (no matching commit)
  - [net-next,v3,07/13] sfc/siena: Rename functions in efx headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,08/13] sfc/siena: Rename RX/TX functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,09/13] sfc/siena: Rename peripheral functions to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,10/13] sfc/siena: Rename functions in mcdi headers to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,11/13] sfc/siena: Rename functions in nic_common.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,12/13] sfc/siena: Inline functions in sriov.h to avoid conflicts with sfc
    (no matching commit)
  - [net-next,v3,13/13] sfc: Add a basic Siena module
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


