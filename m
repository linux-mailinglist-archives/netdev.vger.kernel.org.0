Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08E68637BD2
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 15:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbiKXOuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 09:50:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiKXOu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 09:50:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F145713F495
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 06:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8719162191
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 14:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E1490C433D7;
        Thu, 24 Nov 2022 14:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669301415;
        bh=ihYJaJ0FNzZVyqWOKrecQTAV2giHaPMyX5PVQhP2Vrk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=leVZAMSimqzyQPdqR1q/m04WvsXAuI9jIkaGjfBgLFX/Bl7ogaldaFDe8nmzYbWw2
         QctDdH/9N6eMAxcK6wNelWVVsFU3NxdddFP0hMhPMuOjNX5kwUPTk1ynbbpJ2KjtP8
         PFJj1c6a9DQGwj3Yp61EZJV6Z8r7Mjj0HJ6fOcRcaLtUMrlRCVL46jI1gQ/KP3NMNA
         KhZmXMSe2qekl+QKAtoyuMwae3iYmRCpy+YX5wWapHA/hDgjx+xCvsNn6uf11u5BE+
         2mfsC6SBNROidFAaqFDh9sb0L81dpW+ipAzInQk0MRsvY0dY05JPt3qgTASx6QjiyI
         bmqaRCic/DMxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7299E270C7;
        Thu, 24 Nov 2022 14:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: use %pS for kfree_skb tracing event location
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166930141581.2570.4056912566915255086.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 14:50:15 +0000
References: <20221123040947.1015721-1-sdf@google.com>
In-Reply-To: <20221123040947.1015721-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 22 Nov 2022 20:09:47 -0800 you wrote:
> For the cases where 'reason' doesn't give any clue, it's still
> nice to be able to track the kfree_skb caller location. %p doesn't
> help much so let's use %pS which prints the symbol+offset.
> 
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  include/trace/events/skb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: use %pS for kfree_skb tracing event location
    https://git.kernel.org/netdev/net-next/c/14e5f71e31ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


