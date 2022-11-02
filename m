Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53077615B78
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 05:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbiKBEa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 00:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiKBEaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 00:30:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40A71D65E
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 21:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6FF5B820C5
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 04:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F0DEC433C1;
        Wed,  2 Nov 2022 04:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667363418;
        bh=QsrGwWW1ZDYX0kUS5g+gjDLEtlY8PuGSFYmEOljbk+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XuoG1PaUW8tZlQ6dKvOACVHdsIXLgXVPBxt02m/XVi7eb58j0vp9UBdUIMydl0Dui
         3bV8sdM0M61SdlXkxCjjskTBLqzAtOayLcKmBkPE9cZEKN4rN6ylN/ZAeK0NttZjmB
         67FakpIaFdyxqEgAHBtrtfMOPkTmRpmRoCW68ce4X+fewivMexNEHj64rVGH3Cs11D
         +qKoyCUQ5gRZXySRsj7SHztkHQLL1KV1BR4DnKTeBb9PUinNYRTOePnSeBTKhJhX8r
         CttrlFsYl9YKe8BzfBrOHQIFeG9x5+tDvZprcf6uTbY31ELyiCBangR8FplUc/obbQ
         Y+DW3OoOjn//w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 39151E270D5;
        Wed,  2 Nov 2022 04:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: refine tcp_prune_ofo_queue() logic
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166736341823.16570.18075451513089381753.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Nov 2022 04:30:18 +0000
References: <20221101035234.3910189-1-edumazet@google.com>
In-Reply-To: <20221101035234.3910189-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        ncardwell@google.com, soheil@google.com, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Nov 2022 03:52:34 +0000 you wrote:
> After commits 36a6503fedda ("tcp: refine tcp_prune_ofo_queue()
> to not drop all packets") and 72cd43ba64fc1
> ("tcp: free batches of packets in tcp_prune_ofo_queue()")
> tcp_prune_ofo_queue() drops a fraction of ooo queue,
> to make room for incoming packet.
> 
> However it makes no sense to drop packets that are
> before the incoming packet, in sequence space.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: refine tcp_prune_ofo_queue() logic
    https://git.kernel.org/netdev/net-next/c/b0e01253a764

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


