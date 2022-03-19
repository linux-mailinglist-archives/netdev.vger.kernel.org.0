Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBD5A4DE8ED
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 16:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243410AbiCSPLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 11:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242398AbiCSPLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 11:11:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AA453E16
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 08:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AFBAB80D71
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A5E29C340F0;
        Sat, 19 Mar 2022 15:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647702613;
        bh=EjkIrNel55pjErT1qPellPJ9PTlqbphm5Rqz9fp1eTw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X+cqDcZs2zd7MvnPJ2hea+Ers/loxyNC3AnfQvZdGF1cVSCdIdHq963cIoyce9BS4
         g49loEJ9+bwCHmPYZvCjoikuyYJHDUfyNFpyc/nHgAtAM1bNrxkPyAYD0loR4UbwR3
         HtTCPbXLcvdJ25HvgBVB3QfjMN23V5rjVxllEzyNIWZgYF6AWRS3yP3KbYPAcUxXbT
         eDkvIoet4SFNJAelXlhcE6ar7VHVJ1cXVcjPXD3bYOEWvMdBJv+Jp5D8ivXRWWzy/B
         9JTOVUm9/2YjaffvkNl2Lpdb5V+M7UBWEZg9cl74QdGBnpIDpv4KnTnf/ujw4jfmOI
         gtg7enPnmtbdQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87138E6D3DD;
        Sat, 19 Mar 2022 15:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] xfrm: delete duplicated functions that calls same
 xfrm_api_check()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164770261354.11599.16611522183353497205.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 15:10:13 +0000
References: <20220319074240.554227-2-steffen.klassert@secunet.com>
In-Reply-To: <20220319074240.554227-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Steffen Klassert <steffen.klassert@secunet.com>:

On Sat, 19 Mar 2022 08:42:39 +0100 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The xfrm_dev_register() and xfrm_dev_feat_change() have same
> implementation of one call to xfrm_api_check(). Instead of doing such
> indirection, call to xfrm_api_check() directly and delete duplicated
> functions.
> 
> [...]

Here is the summary with links:
  - [1/2] xfrm: delete duplicated functions that calls same xfrm_api_check()
    https://git.kernel.org/netdev/net-next/c/2ecda181682e
  - [2/2] xfrm: rework default policy structure
    https://git.kernel.org/netdev/net-next/c/b58b1f563ab7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


