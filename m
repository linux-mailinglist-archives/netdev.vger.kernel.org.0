Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4B9E554055
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 04:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356034AbiFVCAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 22:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344874AbiFVCAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 22:00:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28BB433376;
        Tue, 21 Jun 2022 19:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8B44B81995;
        Wed, 22 Jun 2022 02:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B35BC341C4;
        Wed, 22 Jun 2022 02:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655863212;
        bh=eyqTJvsf0+JAYQg4PVv4vGn/KR4fykNsjwWyXIEgJNE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BdJv342r8OuJLCZfl+bnreYh4r+eJmd3/9gyGablIF4QuCCbvdK2EMMhyzedRQ3/y
         Usd0OLyqlqIjuF3TQlFPTusTAv0V0SQGLSEb74kMutbnIpZxz2vf3KGzOOzIza7i23
         fzcuApePX0+AC5mhuoxc20b2NbIYqsBXwpEFk+DAlFUUe24ujGZRfX1oHb1SMQefSD
         b5SN+ByzBXpngDUnxCZAckIW5bEPVAcZdvPa956BCAlaNO0vlHEkaGivXMIcQLFp5/
         rV2/hCe1C12/Ub3sUgScYLh2TokHINnKNo4/anyfrywHjqB3ZO2e+SX8HD5eb4UhqQ
         uf5I4dePFU/sA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6ED1BE574DA;
        Wed, 22 Jun 2022 02:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165586321244.12721.10386124108651169178.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 02:00:12 +0000
References: <20220621175402.35327-1-gospo@broadcom.com>
In-Reply-To: <20220621175402.35327-1-gospo@broadcom.com>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, toke@redhat.com, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, gospo@broadcom.com,
        lorenzo@kernel.org
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

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Tue, 21 Jun 2022 17:54:02 +0000 you wrote:
> This changes the section name for the bpf program embedded in these
> files to "xdp.frags" to allow the programs to be loaded on drivers that
> are using an MTU greater than PAGE_SIZE.  Rather than directly accessing
> the buffers, the packet data is now accessed via xdp helper functions to
> provide an example for those who may need to write more complex
> programs.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] samples/bpf: fixup some tools to be able to support xdp multibuffer
    https://git.kernel.org/bpf/bpf-next/c/772251742262

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


