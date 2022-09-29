Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6629F5EEB9C
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 04:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234635AbiI2CUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 22:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbiI2CUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 22:20:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9D69F761;
        Wed, 28 Sep 2022 19:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB827B822C8;
        Thu, 29 Sep 2022 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8743CC433B5;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664418017;
        bh=UfRX+snYQ9Drogz5WFaepxYKYKpI92DJvErXBH3DOBs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ypl2NGPB6fkFPLegmu4Msp5yHI8BcbsYFCF6i5p5p0alcs6cwPzago0ST0TVGGskB
         IvWEF0y52XJvzYC9qAbQfEkNw5oX7HpeJ/El6Mg81DKpTmqtq1mCN3OjsdNIAF/q1N
         MWsbV9POteT34fhZgFMjWb05Gu3EAinvDHs4yg++nzY1LQlD5W487FjnJvtZ3d77td
         57OjnWtjOT3McJxfU6UM7+0ovSqIVxgLQ6ufh36ImkaAsN7Jdd19YVaMns/bp4yR0w
         u1FV1GfqHV5r4x6giM/ZPH2QJ9I75KEgXT0gw5E7RIEb96bDF2LoIxr4RFMqKGFRYh
         aZhKMmE4UPSag==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 63E70E4D018;
        Thu, 29 Sep 2022 02:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] ice: xsk: ZC changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166441801740.18961.10346673692977885032.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 02:20:17 +0000
References: <20220927164112.4011983-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220927164112.4011983-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 27 Sep 2022 09:41:10 -0700 you wrote:
> Maciej Fijalkowski says:
> 
> This set consists of two fixes to issues that were either pointed out on
> indirectly (John was reviewing AF_XDP selftests that were testing ice's
> ZC support) mailing list or were directly reported by customers.
> 
> First patch allows user space to see done descriptor in CQ even after a
> single frame being transmitted and second patch removes the need for
> having HW rings sized to power of 2 number of descriptors when used
> against AF_XDP.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: xsk: change batched Tx descriptor cleaning
    https://git.kernel.org/netdev/net/c/29322791bc8b
  - [net,2/2] ice: xsk: drop power of 2 ring size restriction for AF_XDP
    https://git.kernel.org/netdev/net/c/b3056ae2b578

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


