Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6554458F776
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 08:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234011AbiHKGKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 02:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233957AbiHKGKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 02:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3273AE09
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 23:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5C9DB81ECD
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 06:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94AC7C433D7;
        Thu, 11 Aug 2022 06:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660198214;
        bh=ZvfHXPi3czC9g/Kua6fMwN+0AGEbyQv7h7mniHNZAJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h5IJzBkGCmlMUuZgtFnaN6uZYR4fAO4Egd2j5bga2Xn6JzHMRwXDF5POo3HPTbpGC
         rSApbtplJyi+esDlndtJVccHfDOaZMgSVUCO2dyLE4LuxJmY48LYCkhU36Gvk0SjX9
         cfMmY4IVd7OhgG96EUA89CjPegQ74k04O2PqxksPI0JiWqKl2u13d9ql9XWatvRude
         r8SfTCh2Sxd0y8rw0olLjW6BKglYCcit+8FSCkwkNsFXwcP+nbxNi1dp8yrcirXwbZ
         fmZKukFv8qVwcPFv5cc5uhf0CZWNBTpfc8Es/UKCEwuNknJa5M6EEtbonkZp9PLUPx
         qy4FlDzAYpqRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B11DC43143;
        Thu, 11 Aug 2022 06:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] tls: rx: device: bound the frag walk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166019821450.2125.7481110299205019975.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 06:10:14 +0000
References: <20220809175544.354343-1-kuba@kernel.org>
In-Reply-To: <20220809175544.354343-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, tariqt@nvidia.com, maximmi@nvidia.com,
        borisp@nvidia.com, john.fastabend@gmail.com, ranro@nvidia.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Aug 2022 10:55:43 -0700 you wrote:
> We can't do skb_walk_frags() on the input skbs, because
> the input skbs is really just a pointer to the tcp read
> queue. We need to bound the "is decrypted" check by the
> amount of data in the message.
> 
> Note that the walk in tls_device_reencrypt() is after a
> CoW so the skb there is safe to walk. Actually in the
> current implementation it can't have frags at all, but
> whatever, maybe one day it will.
> 
> [...]

Here is the summary with links:
  - [net,1/2] tls: rx: device: bound the frag walk
    https://git.kernel.org/netdev/net/c/86b259f6f888
  - [net,2/2] tls: rx: device: don't try to copy too much on detach
    https://git.kernel.org/netdev/net/c/d800a7b3577b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


