Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1126C5F28
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjCWFuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCWFuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:50:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCBD234C3
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7372062320
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BFCFBC433EF;
        Thu, 23 Mar 2023 05:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679550618;
        bh=91dk/1Gv4npcGod8YZBPKOBUd810HuP22vmQ2Kzh2xg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QjcCjH6e6Ps2bDIl9Lfzev8KExg4FnKEvb+gdq6LpBkmNTrh1m/OJtjagwiB9YMNt
         /clk5podajixN/Xh5zaecLo4Cfln3farVFR+FvtXrcxOAR6UFt9tYY6wGoie9V3d0O
         tvTD2peI/ChaO0VAhH9CUN6C1lNA5HTZ69yJBhsPJCkNdTlNFEuobKaNNolRFLzH7l
         fOb5FTYfSZBWG8d5JGGXhEjNmC+EALn6YOEp/CxPoeXNRWZh6OijmvkA1mw4LqRhi0
         tnVYU/G1ocaIE7boROI+cjVUlljlPG/zsNNVR85/4ZSWGnxnBNJPGP7BJtNiPftnGQ
         +HdhHl3mE3eJQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9F4FEE61B86;
        Thu, 23 Mar 2023 05:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2023-03-21 (iavf, i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955061863.14332.18264684431925581838.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:50:18 +0000
References: <20230321183548.2849671-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230321183548.2849671-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 21 Mar 2023 11:35:46 -0700 you wrote:
> This series contains updates to iavf and i40e drivers.
> 
> Stefan Assmann adds check, and return, if driver has already gone
> through remove to prevent hang for iavf.
> 
> Radoslaw adds zero initialization to ensure Flow Director packets are
> populated with correct values for i40e.
> 
> [...]

Here is the summary with links:
  - [net,1/2] iavf: fix hang on reboot with ice
    https://git.kernel.org/netdev/net/c/4e264be98b88
  - [net,2/2] i40e: fix flow director packet filter programming
    https://git.kernel.org/netdev/net/c/c672297bbc0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


