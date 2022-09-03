Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB995ABE44
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiICJuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiICJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53DD83FA11
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 02:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E7A3B82012
        for <netdev@vger.kernel.org>; Sat,  3 Sep 2022 09:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AE14DC433D7;
        Sat,  3 Sep 2022 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662198614;
        bh=EGl2GswhJRupECLwB2eBUwQpX4o36Ry1sXv2AY/fp8g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z05QIfufoerMnRbwVLaZcolsWoZnEc+So0zU7jYe33+fxjMfCFA209LreHJCHCQXx
         L9scR6YdDpkbwYAUpDZLDrd3t2/xjcuMrgDRBOIFIoqC6H/tbJsh0SYp8IyiHSMcsT
         KBMJ+VbevqNOyJneU0sH9Av5ikil0OU8ENQgvUfaARgfcfadtK/gDdEECUTH3Zi5tE
         HFj8sZimmH8eflZqJJdC9+z+9hm4zsPkxi1HDOZXYK0povwpKqMBu4VzkWI33v38ix
         rH8MEyhNipfWRkxVuaoDh1NuTo4gQN3MIPgu/oZuCgoH8lnh1XoPxgont5bGX3OEaS
         Gwydd+Q8Ng6+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 91ECBE924D9;
        Sat,  3 Sep 2022 09:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates
 2022-09-02 (ice)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166219861459.29702.12188455675192786111.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 09:50:14 +0000
References: <20220902175703.1171660-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220902175703.1171660-1-anthony.l.nguyen@intel.com>
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

On Fri,  2 Sep 2022 10:57:01 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Przemyslaw fixes memory leak of DMA memory due to incorrect freeing of
> rx_buf.
> 
> Michal S corrects incorrect call to free memory.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] ice: Fix DMA mappings leak
    https://git.kernel.org/netdev/net/c/7e753eb675f0
  - [net,v2,2/2] ice: use bitmap_free instead of devm_kfree
    https://git.kernel.org/netdev/net/c/59ac325557b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


