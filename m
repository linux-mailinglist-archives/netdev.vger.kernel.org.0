Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5517B6B86A6
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjCNAKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbjCNAKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA225FA51;
        Mon, 13 Mar 2023 17:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55A9D61570;
        Tue, 14 Mar 2023 00:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9A16C4339B;
        Tue, 14 Mar 2023 00:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678752620;
        bh=66Szy9fR0NRlrc9gFzH9Ab2TM2QHlx7Z6RaiwPJj6hs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OvxpCwjJ5KuQELyeZxMdN8HQbIXzSFr3+R6R0B5x54GVI2BNeFaJCtvtO2NMCVLYk
         5gRGejsFBGzuAv397rb872VBvvFVlK1DAS4yIGE2Wx4Gdm2i9hBxVjQup9oUFKPM+R
         PDNt7tIr1kMyEx0tQW3X6poXQuKrZr1zuydKTf8b9bDjSgbUJl6SBPFnvQbETDNxj4
         7NUCbBPe/AhPYEahfn63N2+Y5R5UlQ/wHYCVjzcul3Lsw5RPxQ/5/q3BzDXID7XiBh
         T/AzuRO9aUU9QgZHIDXSxFfhDvOn1st29YGl67oUpNkzHfQ6SHuk0DhTjTwEo9VUm/
         anGjtEDdpbF6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6963E66CB9;
        Tue, 14 Mar 2023 00:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/8][pull request] i40e: support XDP multi-buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875262067.15210.15177827583579328143.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 00:10:20 +0000
References: <20230309212819.1198218-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230309212819.1198218-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        tirthendu.sarkar@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  9 Mar 2023 13:28:11 -0800 you wrote:
> Tirthendu Sarkar says:
> 
> This patchset adds multi-buffer support for XDP. Tx side already has
> support for multi-buffer. This patchset focuses on Rx side. The last
> patch contains actual multi-buffer changes while the previous ones are
> preparatory patches.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/8] i40e: consolidate maximum frame size calculation for vsi
    https://git.kernel.org/netdev/net-next/c/a4ba62906db8
  - [net-next,v2,2/8] i40e: change Rx buffer size for legacy-rx to support XDP multi-buffer
    https://git.kernel.org/netdev/net-next/c/f7f732a7196d
  - [net-next,v2,3/8] i40e: add pre-xdp page_count in rx_buffer
    https://git.kernel.org/netdev/net-next/c/e2843f037127
  - [net-next,v2,4/8] i40e: Change size to truesize when using i40e_rx_buffer_flip()
    https://git.kernel.org/netdev/net-next/c/03e88c8a791c
  - [net-next,v2,5/8] i40e: use frame_sz instead of recalculating truesize for building skb
    https://git.kernel.org/netdev/net-next/c/2bc0de9aca3e
  - [net-next,v2,6/8] i40e: introduce next_to_process to i40e_ring
    https://git.kernel.org/netdev/net-next/c/e9031f2da1ae
  - [net-next,v2,7/8] i40e: add xdp_buff to i40e_ring struct
    https://git.kernel.org/netdev/net-next/c/01aa49e31e16
  - [net-next,v2,8/8] i40e: add support for XDP multi-buffer Rx
    https://git.kernel.org/netdev/net-next/c/e213ced19bef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


