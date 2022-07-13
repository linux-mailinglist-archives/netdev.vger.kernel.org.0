Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF37572AFD
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiGMBk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233825AbiGMBkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:40:51 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6AEB402D3;
        Tue, 12 Jul 2022 18:40:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC492CE1E89;
        Wed, 13 Jul 2022 01:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E37FEC341C8;
        Wed, 13 Jul 2022 01:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657676447;
        bh=RvKAnEEJesdch98m/rEThlS3HrM6WFJlB7n7UV6yKqk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HajjEpAylvK2TGWyrsx8xBPXweBXhqteMvrI9Kk1CLJLlvL/UMY7cOt1N26NHmvfF
         ImnPU/XW+H1y1JT4xCfAxK8NZXkyIHpLlYjtPyH/LZj7fwc+iBgvJhRzW1DBtXVPlp
         mIQXEkbJ4Zbb5zneOlrzpq4hN+pg+3yspBNl5pFmmLVDAkozn3mlpAtoI+03YbRW0a
         5VbzhYmvR5BfwPNJZEIGQ7YSxyjxOPQ+V7XpvgO8w5hySXWqSenTbALiAXVpe+A9QG
         QXba4Hm/Hz9pW9acILpB88U6ubC/l3UobwptV1qiTNZhRVdmrfIlgnFtTjknrZjPbj
         4yoxxPqhfNH1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CCE87E4522F;
        Wed, 13 Jul 2022 01:40:46 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ip_tunnel: use strscpy to replace strlcpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165767644683.18634.16075270514100040666.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jul 2022 01:40:46 +0000
References: <2a08f6c1.e30.181ed8b49ad.Coremail.chenxuebing@jari.cn>
In-Reply-To: <2a08f6c1.e30.181ed8b49ad.Coremail.chenxuebing@jari.cn>
To:     XueBing Chen <chenxuebing@jari.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 11 Jul 2022 21:55:37 +0800 (GMT+08:00) you wrote:
> The strlcpy should not be used because it doesn't limit the source
> length. Preferred is strscpy.
> 
> Signed-off-by: XueBing Chen <chenxuebing@jari.cn>
> ---
>  net/ipv4/ip_tunnel.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - net: ip_tunnel: use strscpy to replace strlcpy
    https://git.kernel.org/netdev/net-next/c/512b2dc48e8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


