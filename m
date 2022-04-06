Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752D74F6645
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 19:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbiDFQ5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238258AbiDFQ4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:56:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8241A61EB;
        Wed,  6 Apr 2022 07:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D87EC618DE;
        Wed,  6 Apr 2022 14:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 331B2C385AB;
        Wed,  6 Apr 2022 14:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649254813;
        bh=NjAY/TDoGmYtGZyxR8hNifrPxSWZAXsxdhcYcs/wqG4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=egFCV0BGmQszNwcNBOnVVCmdZ/FO3mwsXpkIh2CxabAZlvYgmYAyAqX3pjU3G8PVV
         4OteZab9UBNVOeCl56ybzs/zl9E7cRfTuA4Ak89krQX+2GEPZxE8KUKZxEUQRHQq8O
         0E+wwfOykt4TYbz6oeIZeqpunw8+BmNfqd7onNgJH92Puum/Zfdf2OLbN9DkxhI8rn
         vtUmKPWNTT6fyAAHSGrO/19D19bvKmws3Pi5+D2DokgN+kuj41fKrksi6QkH7bJ4xQ
         8mEM2ZLKjv/+62jSzTIvvKBqsAjZYI+NmiXoBV5O8wRLh80MS71TKV88OFkMp5i8Xv
         PpffY+yeZMOYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09442E8DCCE;
        Wed,  6 Apr 2022 14:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qede: confirm skb is allocated before using
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164925481303.16469.8192990223353492835.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 14:20:13 +0000
References: <b86829347bc923c3b48487a941925292f103588d.1649210237.git.jamie.bainbridge@gmail.com>
In-Reply-To: <b86829347bc923c3b48487a941925292f103588d.1649210237.git.jamie.bainbridge@gmail.com>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ariel.elior@cavium.com,
        manish.chopra@cavium.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Apr 2022 21:19:19 +1000 you wrote:
> qede_build_skb() assumes build_skb() always works and goes straight
> to skb_reserve(). However, build_skb() can fail under memory pressure.
> This results in a kernel panic because the skb to reserve is NULL.
> 
> Add a check in case build_skb() failed to allocate and return NULL.
> 
> The NULL return is handled correctly in callers to qede_build_skb().
> 
> [...]

Here is the summary with links:
  - [net] qede: confirm skb is allocated before using
    https://git.kernel.org/netdev/net/c/4e910dbe3650

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


