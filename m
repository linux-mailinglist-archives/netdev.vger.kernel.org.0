Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F53E4ABF64
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:24:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386338AbiBGNBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442574AbiBGMVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:21:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08879C03FEDE;
        Mon,  7 Feb 2022 04:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9ADBB61128;
        Mon,  7 Feb 2022 12:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08B4EC340F7;
        Mon,  7 Feb 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644235810;
        bh=ZSwY6D1dPQLo5Vs+YISQejHv0Pl8CKARlT8TC0DNohI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BRggS/mEVRVq/r9ZFFD5yr1NDX2SCfAtkUJ0gBUSQS8z/+s1RMV4nPo3NPzczDr4v
         viOcdAoIZthzs8clChqseNEKTOzmSeN9OHf6hrltnQOxroUsWbLq6Z+cwIwT5ilNg7
         BD1DBbk6JaTqIP6AlFHuggvGFSMFjtnZuEfsHO9cHW/fDP1qbRFpRZYazS/poD/ccq
         /CAVx+gXgLSABWQYMKsY4BRMTCiElplGp4bUUDe+8L2Qv3d4B74cdZku5GALaWQWrs
         lZPiREzLCxkl55h/wKd9+gOBNQepik5qU/wYwc9k6uYNZZAnOaLRyAjzriKof4mBLS
         eT1wKgCw71eAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E26AEE6BBD2;
        Mon,  7 Feb 2022 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] caif: cleanup double word in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423580992.24406.12277989511475302333.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 12:10:09 +0000
References: <20220206145521.2011008-1-trix@redhat.com>
In-Reply-To: <20220206145521.2011008-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, paskripkin@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  6 Feb 2022 06:55:21 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Replace the second 'so' with 'free'.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---
>  net/caif/caif_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - caif: cleanup double word in comment
    https://git.kernel.org/netdev/net-next/c/0812beb705ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


