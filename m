Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0A662F445
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241682AbiKRMKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241676AbiKRMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8593F8FF8B;
        Fri, 18 Nov 2022 04:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E5ECB82398;
        Fri, 18 Nov 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5FDAC433D7;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668773416;
        bh=iM9YtUIsOab6WeIwJz+h09z5bY3C5GD2/zgEJN97YQk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HArKT+CbfoTfcWwtS6CYtZ6PjABxMss5IOw05NBsUf94dKPU7VXht5GLPU4fpfqAT
         tXQUYkZ02Du9jDhQ5J38oSFCrxhLiQAaOy0/Py3w6YJiyd8ODc6K2NzVDN+Vq4qhig
         awhu0ySRLg8MtjPt8vp+SdXvoKMOmK+BVkNgWZWQCdQdIS70vJKlyZBjMj2ekyq8+U
         65ZkLTrstyV4jScs3leuIv54DxvdoRYmeCklD3J1efUUaqGIAOi9f92NtuIPbY+Wzg
         AmuYqTwoEb8a8rFsBMqIUSl+CC2bFvBWDdrwjWvhGMJOPwmKdeHbZ8r9MaPU2FbVCc
         sonC12UEZLeaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3808E29F44;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rxrpc: fix rxkad_verify_response()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877341679.19277.6962770053975463496.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:10:16 +0000
References: <Y3XmKhBt5fclE6XC@kili>
In-Reply-To: <Y3XmKhBt5fclE6XC@kili>
To:     Dan Carpenter <error27@gmail.com>
Cc:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
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

On Thu, 17 Nov 2022 10:43:38 +0300 you wrote:
> The error handling for if skb_copy_bits() fails was accidentally deleted
> so the rxkad_decrypt_ticket() function is not called.
> 
> Fixes: 5d7edbc9231e ("rxrpc: Get rid of the Rx ring")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This applies to net-next.  It might go throught some kind of an AFS
> tree judging by the S-o-b tags on the earlier patches?  Tracking
> everyone's trees is really complicated now that I'm dealing with over
> 300 trees.
> 
> [...]

Here is the summary with links:
  - [net-next] rxrpc: fix rxkad_verify_response()
    https://git.kernel.org/netdev/net-next/c/101c1bb6c556

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


