Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345206B1C86
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbjCIHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCIHk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:40:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0D6785A5E;
        Wed,  8 Mar 2023 23:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D0A561A38;
        Thu,  9 Mar 2023 07:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C79A9C433D2;
        Thu,  9 Mar 2023 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347623;
        bh=HHYt8aLbuz6IkOfI+LhZEtJr3IrwCVJJ/+VHPDerd9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WWPk3rpjhXS8Pe/26VtnKCNwxZ0rHPPuWD/ExvR4vsiNIfCyq47kGQt/HgS9jZQql
         objQ1HyVarLMAKrdj2L4TnugQwbme5vwr+waQUIRqmYUHIN4kdj8M8WPMi+8VWlQzB
         2JCbyRJxw5+kuhCdB2Sy1tp2H9JnZXe8szA2YAyIWLQ6WgILO9tPNX0TE4GVeGOsWR
         GEJQR+5zjik4LlZD5+HCLAV73OmHS1DoUkYkklgUCX4P/w1iwXDGdlHmnmlqExrm0a
         aySBuZ5tueldk46sz1zykxQoUxKa70kcnK8zIhhV4DI/w/7SHbwrqr/qajPU1qODk+
         jwCMhFaICRHqg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A1B08E61B6E;
        Thu,  9 Mar 2023 07:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/28] PCI/AER: Remove redundant Device Control Error
 Reporting Enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167834762365.29033.5915436899896564508.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 07:40:23 +0000
References: <20230307181940.868828-1-helgaas@kernel.org>
In-Reply-To: <20230307181940.868828-1-helgaas@kernel.org>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        aayarekar@marvell.com, ajit.khaparde@broadcom.com,
        aelior@marvell.com, chris.snook@gmail.com, dmichail@fungible.com,
        ecree.xilinx@gmail.com, jesse.brandeburg@intel.com,
        jiawenwu@trustnetic.com, manishc@marvell.com,
        habetsm.xilinx@gmail.com, mengyuanlou@net-swift.com,
        michael.chan@broadcom.com, rahulv@marvell.com, rajur@chelsio.com,
        rmody@marvell.com, salil.mehta@huawei.com, shshaikh@marvell.com,
        somnath.kotur@broadcom.com, sriharsha.basavapatna@broadcom.com,
        skalluru@marvell.com, anthony.l.nguyen@intel.com,
        vburru@marvell.com, yisen.zhuang@huawei.com,
        GR-Linux-NIC-Dev@marvell.com, intel-wired-lan@lists.osuosl.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 12:19:11 -0600 you wrote:
> From: Bjorn Helgaas <bhelgaas@google.com>
> 
> Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
> which appeared in v6.0, the PCI core has enabled PCIe error reporting for
> all devices during enumeration.
> 
> Remove driver code to do this and remove unnecessary includes of
> <linux/aer.h> from several other drivers.
> 
> [...]

Here is the summary with links:
  - [01/28] alx: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/1de2a84dd060
  - [02/28] be2net: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/b4e24578b484
  - [03/28] bnx2: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/5f00358b5e90
  - [04/28] bnx2x: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/2fba753cc9b5
  - [05/28] bnxt: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/5f29b73d4eba
  - [06/28] cxgb4: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/ca7f175fc24e
  - [07/28] net/fungible: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/49f79ac22f89
  - [08/28] net: hns3: remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/c183033f631a
  - [09/28] netxen_nic: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/2d0e0372069d
  - [10/28] octeon_ep: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/fe3f4c292da1
  - [11/28] qed: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/1263c7b78315
  - [12/28] net: qede: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/5f1fbdc168f4
  - [13/28] qlcnic: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/95e35f599407
  - [14/28] qlcnic: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/e07ce5567194
  - [15/28] sfc: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/bdedf705688c
  - [16/28] sfc: falcon: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/4ac9272691a4
  - [17/28] sfc/siena: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/ecded61ceb89
  - [18/28] sfc_ef100: Drop redundant pci_disable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/c39abdd396bc
  - [19/28] net: ngbe: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/a7edf8e5142f
  - [20/28] net: txgbe: Drop redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/1fccc781bf7e
  - [21/28] e1000e: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/ab76f2bff0f3
  - [22/28] fm10k: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/8be901a6715f
  - [23/28] i40e: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/acd2bb015fae
  - [24/28] iavf: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/495b72c79302
  - [25/28] ice: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/ddd652ef30e3
  - [26/28] igb: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/648a2020fdac
  - [27/28] igc: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/1530522f101f
  - [28/28] ixgbe: Remove unnecessary aer.h include
    https://git.kernel.org/netdev/net-next/c/f3468e394439

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


