Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959FC4BC867
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 13:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbiBSMkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 07:40:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiBSMka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 07:40:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C317C197000;
        Sat, 19 Feb 2022 04:40:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5DA7560AE9;
        Sat, 19 Feb 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCFAEC340F5;
        Sat, 19 Feb 2022 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645274410;
        bh=JDKK8isPTATGqHDIv4POiJ9KesqfHzhClGsuh7fvIEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jltWN75cl2QmxD89GeBqm8rqbwZzQmMB7X6BFSdU2RAv2gCk5Pj2fGK9j1OqCU4ft
         ME/2PXL2ZHx2UN5ReRgC6iucPXipd+mE96aWo5FZBqpqU5tXpC+vV7iSNEp9J/tDOQ
         mSgpJZ0BsL+3pLghGQRLns8arQZl7geylMlH2DjYXIX1BGLGCp2mxqjNkuKapUkPFI
         i6hu/5TjSz26xbxX4Y/dApZS8QEr2BAmbgXKFAE8+0gW9X3PwDJBws90fjY83JQXhy
         rdNHnJVteozlHkJ6RP2QNOag6/SyCFSAdzomdYJZO0zoBmEddg2yLmpA/hy53fjA4u
         KO2JKQrR58BCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA1B7E5D07D;
        Sat, 19 Feb 2022 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] i40e: remove dead stores on XSK hotpath
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164527441069.11752.16243635494122993373.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 12:40:10 +0000
References: <20220218215033.415004-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220218215033.415004-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, alexandr.lobakin@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, sassmann@redhat.com,
        hawk@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        ast@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, george.kuruvinakunnel@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 18 Feb 2022 13:50:33 -0800 you wrote:
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> The 'if (ntu == rx_ring->count)' block in i40e_alloc_rx_buffers_zc()
> was previously residing in the loop, but after introducing the
> batched interface it is used only to wrap-around the NTU descriptor,
> thus no more need to assign 'xdp'.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] i40e: remove dead stores on XSK hotpath
    https://git.kernel.org/netdev/net-next/c/7e1b54d07751

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


