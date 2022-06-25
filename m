Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD4B55A757
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 07:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232051AbiFYFkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 01:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231598AbiFYFkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 01:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF93F5133F;
        Fri, 24 Jun 2022 22:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B2E9B82475;
        Sat, 25 Jun 2022 05:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 442B5C341CA;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656135614;
        bh=BPY0rZoFapSHi7kmQIicnZbqOZa2v+cLm7nKfFmg0KA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KpVTnOutCeyKOKAS+p87m2B1mXRsC0zatrhYCJ+CrCVohgw7HAuhUcdvnX+MBityy
         ZQvc6jlS2dUGOZGR+yh96JOG93pVQyciSfE1ISuh0cBfOV0QoUJrUFEhmEYCOCgwOr
         ap2XCM7zNJdq++XXai5BJDoRpA9unQQhwNyV+DPCEiNoXoUQy7SSc9OrKkKiWBt3IY
         /q3hkOlntm68zDytcERnh+jFBnRzXEmqqyHR+BuxJdue4drKmoOOX8pmqa2sLhISEk
         /Y5XdV6E+mpp3d9IklKcTs4yWCD2fTKfqhE7/LVyfYJXLikgdJbgRYExJpOBGsCVPq
         cAHNcwbcl6A6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A68CE8DBCB;
        Sat, 25 Jun 2022 05:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] i40e: read the XDP program once per NAPI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165613561417.1389.16592018504137661188.git-patchwork-notify@kernel.org>
Date:   Sat, 25 Jun 2022 05:40:14 +0000
References: <20220623100852.7867-1-ciara.loftus@intel.com>
In-Reply-To: <20220623100852.7867-1-ciara.loftus@intel.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        kuba@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, maciej.fijalkowski@intel.com,
        zeffron@riotgames.com
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 10:08:52 +0000 you wrote:
> Similar to how it's done in the ice driver since 'eb087cd82864 ("ice:
> propagate xdp_ring onto rx_ring")', read the XDP program once per NAPI
> instead of once per descriptor cleaned. I measured an improvement in
> throughput of 2% for the AF_XDP xdpsock l2fwd benchmark for zero copy mode
> and 1% for copy mode.
> 
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] i40e: read the XDP program once per NAPI
    https://git.kernel.org/netdev/net-next/c/78f319315764

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


