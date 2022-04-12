Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09E084FCD3B
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 05:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344342AbiDLDmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 23:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344757AbiDLDm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 23:42:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E86013E3C;
        Mon, 11 Apr 2022 20:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17A2161740;
        Tue, 12 Apr 2022 03:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75024C385A8;
        Tue, 12 Apr 2022 03:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649734811;
        bh=x5IqgRVdfCTDlvWYNRFSIidKHASxXB5BiP3YYe4XB+o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uU/iKHelPyNDXwSrwQxBgs+uigA0VUNI3jF1EARtnkGzHX9UqJTK3GTD3ORrsS1bb
         DVWweWffLi+9zfDtCneHcHp5sF9ojqLt4rRkfupW2g1jW6MJkoS6+Xc7XTLSdn1UOv
         gfDy1cY1uOUIgX7wKoS5pbg/6oz8fwzDDlfd4gb6jSu44d0XD9qj4oUm1iNhQqo59u
         rn0D7WOUrlRKmnVC+oV29dZiAEuOhHINBTv9QmA9hAzRhDmW26zHfqzxDekfQtLtdZ
         CWZHySx4yz/AQ0uGogaoEUwNAqKdgjeM177qOMhFmPTm+bAnA+bNlVisEb/5eyUClp
         inU9va3l+yAyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 556EFE8DBD1;
        Tue, 12 Apr 2022 03:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sctp: Initialize daddr on peeled off socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164973481134.21815.13991525286598495841.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 03:40:11 +0000
References: <20220409063611.673193-1-oss@malat.biz>
In-Reply-To: <20220409063611.673193-1-oss@malat.biz>
To:     Petr Malat <oss@malat.biz>
Cc:     netdev@vger.kernel.org, vyasevich@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  9 Apr 2022 08:36:11 +0200 you wrote:
> Function sctp_do_peeloff() wrongly initializes daddr of the original
> socket instead of the peeled off socket, which makes getpeername()
> return zeroes instead of the primary address. Initialize the new socket
> instead.
> 
> Fixes: d570ee490fb1 ("[SCTP]: Correctly set daddr for IPv6 sockets during peeloff")
> Signed-off-by: Petr Malat <oss@malat.biz>
> Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> [...]

Here is the summary with links:
  - sctp: Initialize daddr on peeled off socket
    https://git.kernel.org/netdev/net/c/8467dda0c265

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


