Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F18685EBE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbjBAFK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjBAFKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:10:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168E55085F
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 21:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A680160DCC
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 05:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01061C433A1;
        Wed,  1 Feb 2023 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675228220;
        bh=jzG5OTyZUfj89U0oaOqU4BLYjCCe+2KChzZSROfZYkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u5NK9lIFGVBAZD53gYlVz60zaS50hF7HTJWEBi4DHPuuagThAZnhms5d7MREMKa2j
         /v79SFfhGozJVNOI/bxWHg0Okej5XbCF1CLk1TD2EaIIaUJiizrRexGwE8Y+O42JT2
         I8o5COjUXC7ZIyEfVha5NBMG8WFnAKUpPVG7TqhW6ij68OgnvwZfyi0BgZAzNl7I4t
         kxs95/75XszlDnEWlCfTwKD83KFzCdHRinds0C+7EGvEYJfZizPIIyuBIAxoBssI60
         PbqRDBd5/1/PC6ni0XI5KXeD68JEQcBMVttctYJP9X6StAcQDs0BAIQR/MQbpSH8za
         J4J4ihgAbGusg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA6A7E270CD;
        Wed,  1 Feb 2023 05:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8][pull request] Intel Wired LAN: Remove redundant
 Device Control Error Reporting Enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167522821988.27789.6417511842180108829.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:10:19 +0000
References: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230130192519.686446-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, bhelgaas@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 30 Jan 2023 11:25:11 -0800 you wrote:
> Bjorn Helgaas says:
> 
> Since f26e58bf6f54 ("PCI/AER: Enable error reporting when AER is native"),
> the PCI core sets the Device Control bits that enable error reporting for
> PCIe devices.
> 
> This series removes redundant calls to pci_enable_pcie_error_reporting()
> that do the same thing from several NIC drivers.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] e1000e: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/601f46282cd8
  - [net-next,2/8] fm10k: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/3218487afdc4
  - [net-next,3/8] i40e: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/d04d9e769993
  - [net-next,4/8] iavf: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/bc4fddc3b306
  - [net-next,5/8] ice: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/ba153552c18d
  - [net-next,6/8] igb: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/8aea4c325296
  - [net-next,7/8] igc: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/c3c14ecfe04a
  - [net-next,8/8] ixgbe: Remove redundant pci_enable_pcie_error_reporting()
    https://git.kernel.org/netdev/net-next/c/dec6b8016445

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


