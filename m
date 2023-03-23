Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFCF6C6221
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:42:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjCWImI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjCWIlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:41:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7805937F1A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1C1896250C
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 08:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78327C4339B;
        Thu, 23 Mar 2023 08:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679560820;
        bh=XCkg0g+KU39WNstXFubw0HDy/c70Q+nidWL35Hw3Zv4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kE/euMY2UbI81BaILsf2qQj9fTE4JPk9SGHqNzB9/4gT72CWfDASLo15vC5tqxVYb
         k/LPq63q5uP3kPbyfUaL1+k8AbN2Vs916Wv1KTQSer3eoPkyqU98Vs+rUEFPYgRFZ7
         Q0rpcPNZNMp7JQFKbPXaSzIWUsmWRZH8PKOY66NiAma/RnHWQ3UZ5m7GbTfMsomcHP
         bIKXlVJnuSRh17cqEhf0LrIt3SsLoxdLu4Z9PJsIjXLcXpOPv60lrEIp8Q3feoYVKQ
         hxewTxMWPG+H7WGDHvF2eP9Gg7gE19x61fflDClXNX6asq3pfbKEwq9oQESlw69uAH
         OFEH0TXArq6HA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E514E21ED4;
        Thu, 23 Mar 2023 08:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3][pull request] Intel Wired LAN Driver Updates
 2023-03-21 (igb, igbvf, igc)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167956082038.32268.11572468873567180690.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 08:40:20 +0000
References: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230321200013.2866582-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 21 Mar 2023 13:00:10 -0700 you wrote:
> This series contains updates to igb, igbvf, and igc drivers.
> 
> Andrii changes igb driver to utilize diff_by_scaled_ppm() implementation
> over an open-coded version.
> 
> Dawid adds pci_error_handlers for reset_prepare and reset_done for
> igbvf.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] igb: refactor igb_ptp_adjfine_82580 to use diff_by_scaled_ppm
    https://git.kernel.org/netdev/net-next/c/d71980d47e27
  - [net-next,2/3] igbvf: add PCI reset handler functions
    https://git.kernel.org/netdev/net-next/c/5a9b7bfb0d15
  - [net-next,3/3] igc: Remove obsolete DMA coalescing code
    https://git.kernel.org/netdev/net-next/c/65364bbe0b02

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


