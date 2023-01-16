Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8EB66BBB4
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 11:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjAPKaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 05:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbjAPKaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 05:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FBE1A960
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 02:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0003860F55
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 10:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BC8CC433F2;
        Mon, 16 Jan 2023 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673865016;
        bh=IkVRx2s55BHlMxO0wsWSr9wTxJEdDoTBpTU+5dhRjiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HoKqioMvnQi5JwzMr7EGSvoyIEjAaUlevCPH/j0DyKLhydgYmyjhZJAq2APa+nlCY
         6H3+qHaSLifysCQjK9sZ0joCxeDPDmwE5W17+Yxj0SXoyS+ErGW0fccQS/8QW8Z9lK
         wOxxcVMV2+P4SzI9l42A3dmplyZ8OBJEpbRtEdrfviDsAK78CsHW/wqbO40vZk3gec
         VlZ13I1yNA4UvyqlSqJULLu+QyCUIuoFt68KLDjqDWWFt4MGvTmyY1HCLDFQ5920vq
         cgDP1NT18varX53fJbMPgw4v5u4Q4ujjxbVkogdz7NN9Ces2dsud76OeWOfBw8HRBn
         Q/SzEqNTplj1A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38F21E54D2A;
        Mon, 16 Jan 2023 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next,/8] octeontx2-af: update CPT inbound inline IPsec
 config mailbox
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167386501622.10012.6337060871356589637.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 10:30:16 +0000
References: <20230111122343.928694-7-schalla@marvell.com>
In-Reply-To: <20230111122343.928694-7-schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, jerinj@marvell.com,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 11 Jan 2023 17:53:41 +0530 you wrote:
> Updates CPT inbound inline IPsec configure mailbox to take
> CPT credit, opcode, credit_th and bpid from VF.
> This patch also adds a mailbox to read inbound IPsec
> configuration.
> 
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> 
> [...]

Here is the summary with links:
  - [v2,net-next,/8] octeontx2-af: update CPT inbound inline IPsec config mailbox
    https://git.kernel.org/netdev/net-next/c/5129bd8e8840

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


