Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DBED6338B5
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbiKVJkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 04:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233266AbiKVJkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 04:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 770AD24F28;
        Tue, 22 Nov 2022 01:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 128BA61568;
        Tue, 22 Nov 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DE5BC433C1;
        Tue, 22 Nov 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669110015;
        bh=fMfXtIsZ2+bWiNMJ6NEZG31j1EjSUc90VJCg9Kidguc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GshXvYZhxABCrGu7JGnIO9SGOxrzGuknApVEZm6fiY7DcPM62K/ISLji7RjQsn17L
         x6qF4Yuecl41NbYKlgmxySsS9EH5FFIAcbbRdyqDDZKKofZxXaT/AD287bNwF9L382
         OJwl+WcuO7LpZCh5sQChTFG8VS3RVQRDG1w/Z0tdlt8SVkmtxWvmb3X7TbV0ADTNq4
         VqgWFMiJA2Bv2BbKEIBcBNJVorTjl4oZEUc1M5yvUb2GVNefEp9sDSSgbn/unB9aVn
         vc2HViBWOFADnFoGmjJVhXChNfHlcFgMEcmKyhyIrTZ3Vfjz5uS/YrBOlcX99f/NWA
         8wArIbX2B3NLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 582A4E29F42;
        Tue, 22 Nov 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: wwan: iosm: use ACPI_FREE() but not kfree() in
 ipc_pcie_read_bios_cfg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166911001534.14005.16331168495671916371.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 09:40:15 +0000
References: <20221118062447.2324881-1-bobo.shaobowang@huawei.com>
In-Reply-To: <20221118062447.2324881-1-bobo.shaobowang@huawei.com>
To:     Wangshaobo (bobo) <bobo.shaobowang@huawei.com>
Cc:     pabeni@redhat.com, davem@davemloft.net, kuba@kernel.org,
        liwei391@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 18 Nov 2022 14:24:47 +0800 you wrote:
> acpi_evaluate_dsm() should be coupled with ACPI_FREE() to free the ACPI
> memory, because we need to track the allocation of acpi_object when
> ACPI_DBG_TRACK_ALLOCATIONS enabled, so use ACPI_FREE() instead of kfree().
> 
> Fixes: d38a648d2d6c ("net: wwan: iosm: fix memory leak in ipc_pcie_read_bios_cfg")
> Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: wwan: iosm: use ACPI_FREE() but not kfree() in ipc_pcie_read_bios_cfg()
    https://git.kernel.org/netdev/net/c/e541dd7763fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


