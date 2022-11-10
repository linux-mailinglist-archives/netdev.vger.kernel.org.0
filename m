Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD6F62404C
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbiKJKuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:50:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKJKuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:50:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683F927CDE;
        Thu, 10 Nov 2022 02:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F33026129D;
        Thu, 10 Nov 2022 10:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57EB0C433B5;
        Thu, 10 Nov 2022 10:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668077415;
        bh=bNYbHiXY2MmJqnSJr5STDbI2eLV6tOD1n9vNron9dnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JmwQVnMpJE/AIB+K+u//D9NcDTWrWGmE8SyVJ0MPYk4D4OMJ8C28FESQ5xoli5lra
         f4bC4idCQegH1r2zYglGlmrdwAyV8FHKuosOwzg7K0fj8I7PIN94nwS+m0PB9UDAc9
         WGihYimBXJ4MeQDWi02MIbd4i1X01KVR8WbppO+/hf5ieVKE1kkUgbfCO+npei19pE
         FRFCTH9L4Jr0bovPon56iS5g0SMRZpoGhSSvOmFJD2fH5U8v0+tCkCp5DL7bIHk+QJ
         nPG18p7lJevglQaanunJ6Ypj1Q7hEjh6tb0fos1G4jZab0YSkah6UpaxufRdhEZam3
         p3jynq+4VqvpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3E12FC395FD;
        Thu, 10 Nov 2022 10:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] gro: avoid checking for a failed search
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166807741525.15769.13929946199010333247.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 10:50:15 +0000
References: <20221108123320.GA59373@debian>
In-Reply-To: <20221108123320.GA59373@debian>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lixiaoyan@google.com, alexanderduyck@fb.com,
        steffen.klassert@secunet.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, 8 Nov 2022 13:33:28 +0100 you wrote:
> After searching for a protocol handler in dev_gro_receive, checking for
> failure is redundant. Skip the failure code after finding the
> corresponding handler.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] gro: avoid checking for a failed search
    https://git.kernel.org/netdev/net-next/c/e081ecf084d3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


