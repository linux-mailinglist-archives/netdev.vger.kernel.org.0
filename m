Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5591C4AE945
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 06:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbiBIF1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 00:27:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiBIFU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 00:20:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA658C03C19E
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 21:20:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4428ACE1E35
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 05:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F002C340F2;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644384028;
        bh=PrA5QMS8xo08VoAY9HU/evCSWK/IalAT06Y1QfXAg/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cQFx3dhKJbBDJ/tM3okHDJ1CNdSwdXueN1ODtb4MYgC9XIwR8c2NJXyMGLQ1ZJGoI
         xYQVk3gkZqARDlZl1b0rUd7MVe1erqSo2jAd12g07pBTTxdl90QpMZpdTGmuz0fYW+
         upEOZFnVD/mlXY6PGHhw3prvb6NibWF4fobfGbRL+bsI+DUqvE17DdxLVyndyJ3EbN
         ijZ/iZ6K7OPJEycCBTrXI+azMdM9Rh1p0KZXpgawEeU/UfqIQG1XmRd0rBLlY6R1fK
         RZ14IanrMaSqIN/TpaznFfknGEcTtHOmgc/aKTJqMutAGJJxMuhOp10M3EcWLe+IYy
         rno9Fr/eB+WbQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6ACD4E6D3DE;
        Wed,  9 Feb 2022 05:20:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] bonding: pair enable_port with slave_arr_updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164438402843.12376.11555664750382688882.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 05:20:28 +0000
References: <20220207222901.1795287-1-maheshb@google.com>
In-Reply-To: <20220207222901.1795287-1-maheshb@google.com>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, andy@greyhouse.net,
        vfalico@gmail.com, davem@davemloft.net, kuba@kernel.org,
        mahesh@bandewar.net, jay.vosburgh@canonical.com
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

On Mon,  7 Feb 2022 14:29:01 -0800 you wrote:
> When 803.2ad mode enables a participating port, it should update
> the slave-array. I have observed that the member links are participating
> and are part of the active aggregator while the traffic is egressing via
> only one member link (in a case where two links are participating). Via
> kprobes I discovered that slave-arr has only one link added while
> the other participating link wasn't part of the slave-arr.
> 
> [...]

Here is the summary with links:
  - [v4] bonding: pair enable_port with slave_arr_updates
    https://git.kernel.org/netdev/net/c/23de0d7b6f0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


