Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F2A598B27
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345539AbiHRSaf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345492AbiHRSaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DB9B69E5
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03C2EB823CF
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 18:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AAE4DC433C1;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660847417;
        bh=/qcddAuKC8q63V48O8PFwNfdchMvguSXfiPyEKnMMi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NITf0/rEQotR5rgN+dxw6p1DotfhJa96Tp3glmWpwC2ZkS7mFpX+CaLmtKs3amG8N
         My3Fptx8/+a+1Qk+Yu9iGwSEDQCtNgq+qizi1fOdj/xphDWGaZYzXH5bEutBcI/ePm
         fINEmVadPmoPI1Q+DXkYf6ePdpsnkXxik76zqbs0Y2SvS1K4dLmLYh4F7hhfQfKMFL
         YzBtdEPHhK5j3STHs5ilsCCvQs/trL7lrlB8yXqe137G67GvnIxvUvgOlSBw7hbRp3
         cs+dYKYj9UWF+j9sTp0zMCNHZw1vYQngGTdKLfqY4nbn8E6sgCigs6Kwg/1aLKLHCJ
         wbFf/VZ3V2x9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 90292C4166F;
        Thu, 18 Aug 2022 18:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2022-08-17 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166084741758.25395.9815616549707720626.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 18:30:17 +0000
References: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220817171329.65285-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 17 Aug 2022 10:13:24 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Grzegorz prevents modifications to VLAN 0 when setting VLAN promiscuous
> as it will already be set. He also ignores -EEXIST error when attempting
> to set promiscuous and ensures promiscuous mode is properly cleared from
> the hardware when being removed.
> 
> [...]

Here is the summary with links:
  - [net,1/5] ice: Fix double VLAN error when entering promisc mode
    https://git.kernel.org/netdev/net/c/ffa9ed86522f
  - [net,2/5] ice: Ignore EEXIST when setting promisc mode
    https://git.kernel.org/netdev/net/c/11e551a2efa4
  - [net,3/5] ice: Fix clearing of promisc mode with bridge over bond
    https://git.kernel.org/netdev/net/c/abddafd4585c
  - [net,4/5] ice: Ignore error message when setting same promiscuous mode
    https://git.kernel.org/netdev/net/c/79956b83ed42
  - [net,5/5] ice: Fix VF not able to send tagged traffic with no VLAN filters
    https://git.kernel.org/netdev/net/c/664d4646184e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


