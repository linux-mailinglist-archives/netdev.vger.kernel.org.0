Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0BD6C5F2D
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:50:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjCWFu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbjCWFuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B36A23669
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7FCB623EE
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F1E3C433A4;
        Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679550622;
        bh=DI1TbomJyapKhjcs+RP+MBT82PkfABf3XfPT3dObotA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V15XnQd0JnxyAaJ7ijyBzztkswbFXxdplyfsUQYAiKQXHKajWZIkx2wxgrklVGyoo
         NtMOaTTt04tyP/J4/P7rWdGWXEdyKKOHilX/ytibLHP1nDdDWWQMKTO4CvPGaegQG6
         QXpQUfkWxXdqwAtiIMMqRuDX/kYc10gQKMWN3I4qbs764/HEvNhHWI5yBf9/DFzkMS
         V0JCRmWZtQ5PsRXJV8hNumAOvA+WB1mNusaerhMBlRgBhLseq5UVHyxlIWhNKW877o
         fLz+V5vas8698JUgPXuFxhW1/u1+2rcmb2LnXdBX5jGgwyOnLZ5jGphSv1d1zfhUFI
         3NFgT+ZUJ3KYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 05110E61B89;
        Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] net: remove some skb_mac_header assumptions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955062201.14332.6717179750988330562.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:50:22 +0000
References: <20230321164519.1286357-1-edumazet@google.com>
In-Reply-To: <20230321164519.1286357-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        simon.horman@corigine.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 16:45:16 +0000 you wrote:
> Historically, we tried o maintain skb_mac_header available in most of
> networking paths.
> 
> When reaching ndo_start_xmit() handlers, skb_mac_header() should always
> be skb->data.
> 
> With recent additions of skb_mac_header_was_set() and
> DEBUG_NET_WARN_ON_ONCE() in skb_mac_header(), we can attempt
> to remove our reliance on skb_mac_header in TX paths.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: do not use skb_mac_header() in qdisc_pkt_len_init()
    https://git.kernel.org/netdev/net-next/c/f5fca219ad45
  - [net-next,2/3] sch_cake: do not use skb_mac_header() in cake_overhead()
    https://git.kernel.org/netdev/net-next/c/e495a9673caf
  - [net-next,3/3] net/sched: remove two skb_mac_header() uses
    https://git.kernel.org/netdev/net-next/c/b3be94885af4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


