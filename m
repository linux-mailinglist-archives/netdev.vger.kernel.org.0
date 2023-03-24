Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DE46C7B17
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 10:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbjCXJUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 05:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231949AbjCXJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 05:20:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A4C21969;
        Fri, 24 Mar 2023 02:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C4CC629E9;
        Fri, 24 Mar 2023 09:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE2C3C433A0;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679649620;
        bh=JrqCAgedwzPSgLvyyB7cQkB4eQeV28GZrSBiQ4c5iOo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JY/nSEUup2E+eVTUzJbQpk+bo5rREDVDrf2c3fq5X7AnDARlkff9qH8LUPw7DgolV
         Of+oVZ4rfz/LLOvu4/wh0kpJ3myGlgYgSfaFAQ68u1KRVhyUPU+l3iemJ20u4XV2RC
         KoDLpDXT0iw4Qt3PuZGvI0m8gdTGG0mP526jyskU5iiqofuW2q8zTCqdE4w478Ex+r
         xl7A0hQKIV79jGk8prL3+v2ZcELV1ZXNFQ1bBNh4UHJYwTsUdEi3lBBvVpMWEjI9pz
         +uTxuEaF+AZ6SsuYq7ad8rhN7Zp9Cn8ynB77EbYr13muXsvRgmf5RcMVpuRvh9Jkbt
         klPIfKex0RsUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7A437C41612;
        Fri, 24 Mar 2023 09:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/8] net: liquidio: Remove redundant pci_clear_master
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167964962049.21111.12008257993257432253.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 09:20:20 +0000
References: <20230323090314.22431-1-cai.huoqing@linux.dev>
In-Reply-To: <20230323090314.22431-1-cai.huoqing@linux.dev>
To:     Cai Huoqing <cai.huoqing@linux.dev>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, rajur@chelsio.com, reksio@newterm.pl,
        dmichail@fungible.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, saeedm@nvidia.com, leon@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
        decui@microsoft.com, shannon.nelson@amd.com, brett.creeley@amd.com,
        drivers@pensando.io, bhelgaas@google.com,
        jesse.brandeburg@intel.com, huangguangbin2@huawei.com,
        shenjian15@huawei.com, lanhao@huawei.com, wangjie125@huawei.com,
        longli@microsoft.com, jiri@resnulli.us, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-hyperv@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Mar 2023 17:03:00 +0800 you wrote:
> Remove pci_clear_master to simplify the code,
> the bus-mastering is also cleared in do_pci_disable_device,
> like this:
> ./drivers/pci/pci.c:2197
> static void do_pci_disable_device(struct pci_dev *dev)
> {
> 	u16 pci_command;
> 
> [...]

Here is the summary with links:
  - [1/8] net: liquidio: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/fc5aba60c244
  - [2/8] net: hisilicon: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/fc3e07e83e8e
  - [3/8] net: cxgb4vf: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/aae964bb7800
  - [4/8] net/fungible: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/8b91d5b62ce8
  - [5/8] net/mlx5: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/5b6f4bd24c8d
  - [6/8] net: mana: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/2d59af830752
  - [7/8] ionic: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/f686e9592734
  - [8/8] ethernet: ec_bhf: Remove redundant pci_clear_master
    https://git.kernel.org/netdev/net-next/c/3228150ba688

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


