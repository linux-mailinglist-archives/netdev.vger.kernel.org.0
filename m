Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0235264813C
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbiLILAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:00:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiLILAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:00:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27514B776
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 49E01CE293F
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D3E1C433F2;
        Fri,  9 Dec 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670583616;
        bh=9urtGGzyWKiA72jKnWZ4fvezqmlbLm/7vD4Ky/o2aLA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qyxPDk2jvgjBi18oiygWAjC/6qaVMCP/DXI/uwfhKHWHrwH2lHhF6Gm1akDBM3nX2
         UHSDaN09xdF57Fy0Om0v2D0hubRZ1LLXws9FICg0aYXGfQpbS0TkgLygqTZQkIzf8U
         m25GqKH1vpZ2gDzD+mc9P8blkKc3qi5jympWjrdjMqOZtDPwcIlh7/z5RcNeLXMKxv
         ySVpYkwGtXngkhE7kNnUqUshK+0ffZe1RjTiOmj4qqJ7oCvdl6+Is5w8KgL6/eBFE6
         2Zifv/JLohR8nw2izp6kchQXBkz753dVeNV3+Mddum+EbtwSU08uiYDWpJ9LHNQdPX
         oNjD3EQNV43DA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63C25C433D7;
        Fri,  9 Dec 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] drivers: net: qlcnic: Fix potential memory leak in
 qlcnic_sriov_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167058361640.21061.15692616468787861295.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Dec 2022 11:00:16 +0000
References: <20221207085410.123938-1-yuancan@huawei.com>
In-Reply-To: <20221207085410.123938-1-yuancan@huawei.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        rajesh.borundia@qlogic.com, sucheta.chakraborty@qlogic.com,
        leon@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 7 Dec 2022 08:54:10 +0000 you wrote:
> If vp alloc failed in qlcnic_sriov_init(), all previously allocated vp
> needs to be freed.
> 
> Fixes: f197a7aa6288 ("qlcnic: VF-PF communication channel implementation")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
> Changes in v2:
> - free all vp before destroy_workqueue(bc->bc_trans_wq)
> 
> [...]

Here is the summary with links:
  - [net,v2] drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()
    https://git.kernel.org/netdev/net/c/01de1123322e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


