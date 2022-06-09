Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4462A54425B
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 06:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235381AbiFIEKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 00:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiFIEKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 00:10:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AAF9272D
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 21:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87C5A61CB6
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 04:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2E25C34115;
        Thu,  9 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654747813;
        bh=DyD/HPVsFaNe3QWMIos7ZlKu3EkCs29tkiftRNJ6qGg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X3r30PcgLxy9bUc0Zc86q6Lp8RQzHmiUorJo0b4eZoKFleyDEMWP84bAiPpRAvGxc
         qOsigt+Il4NqsJWYVnV/ns7KLh6ZJ7IDyFEW99vgcjOE/TupB0A7rPrn82hj4rHpl2
         lb1fXYa1I+u8c5bKWnZx12a5X0Peluoe/Rr3gSKjNgL4NYiqNr9U+baIGm+Ldui3hn
         cv1s1kO1O7vHTuvVzTzAXeJa1qmiFwXZmnMDYInV+rkNg6XXHlf01Qr9HRFKoZnXoL
         1pVjaEbPJMmbTOJS9o+S+l50QlEmPdjP3TswPHfdoSrwX+nHcmTGnU8YXKdBTWNzR8
         GWEiF3Rwz128Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6CE9E737E8;
        Thu,  9 Jun 2022 04:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-06-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165474781381.435.16953073380913064415.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 04:10:13 +0000
References: <20220607181538.748786-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220607181538.748786-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  7 Jun 2022 11:15:36 -0700 you wrote:
> This series contains updates to ixgbe driver only.
> 
> Olivier Matz resolves an issue so that broadcast packets can still be
> received when VF removes promiscuous settings and removes setting of
> VLAN promiscuous, in promiscuous mode, to prevent a loop when VFs are
> bridged.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ixgbe: fix bcast packets Rx on VF after promisc removal
    https://git.kernel.org/netdev/net/c/803e9895ea2b
  - [net,2/2] ixgbe: fix unexpected VLAN Rx in promisc mode on VF
    https://git.kernel.org/netdev/net/c/7bb0fb7c63df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


