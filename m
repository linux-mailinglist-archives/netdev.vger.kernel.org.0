Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4A544D2F70
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 13:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbiCIMvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 07:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiCIMvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 07:51:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3771A997C;
        Wed,  9 Mar 2022 04:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81210619E1;
        Wed,  9 Mar 2022 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5638C340F4;
        Wed,  9 Mar 2022 12:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646830210;
        bh=I6ozOdglKxYbxHYFDFEkcL7osJhYjFDadHAfNPgMPFI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cGlkfYnpR/eAABCt2nS59oAeCyM60fcONQKj7SwKoaBj4ZNcyfKL8KcNY/qQceRpM
         C5RuSyJIxuC0NUVTCwJCsYrBJKFaBNRznFtoxt35vKJXC9FlFInaxj4yZCDgbvwyM/
         cTBO0hMp7SljK1ODE6OiYBSj6AcJ+HSczZD7QOxF2+M3vgFWxVOsA9nqqTdSfpjed1
         mJCfUUmiFC6m8Wfsj5OoLGBiXkB/DYwcOsBcojfWS7ZzEQ2e4Be1Cjg8ay0J6brBG6
         SoUJoBpgofDL/HZgfdhg2SmV2KxUacWKQluWVkkQYB3sh+ynNh4ZN9btkZ8GRQlLE3
         pIBuSbIIegs9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6B74E7BB08;
        Wed,  9 Mar 2022 12:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ax25: Fix NULL pointer dereference in ax25_kill_by_device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164683021074.2371.639793018206811147.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 12:50:10 +0000
References: <20220308081223.15919-1-duoming@zju.edu.cn>
In-Reply-To: <20220308081223.15919-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        ralf@linux-mips.org, jreuter@yaina.de
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 16:12:23 +0800 you wrote:
> When two ax25 devices attempted to establish connection, the requester use ax25_create(),
> ax25_bind() and ax25_connect() to initiate connection. The receiver use ax25_rcv() to
> accept connection and use ax25_create_cb() in ax25_rcv() to create ax25_cb, but the
> ax25_cb->sk is NULL. When the receiver is detaching, a NULL pointer dereference bug
> caused by sock_hold(sk) in ax25_kill_by_device() will happen. The corresponding
> fail log is shown below:
> 
> [...]

Here is the summary with links:
  - ax25: Fix NULL pointer dereference in ax25_kill_by_device
    https://git.kernel.org/netdev/net/c/71171ac8eb34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


