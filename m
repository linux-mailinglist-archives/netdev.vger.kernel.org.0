Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90CD5FDE7A
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbiJMQuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJMQuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBDA60C94
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F5D061870
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 16:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC8FBC433D7;
        Thu, 13 Oct 2022 16:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665679816;
        bh=g3R1cWDC56K1w0qKeV/X0/h3RsN9fPRW4w6Xoqd0xts=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=abE94SKfJLZWjvD4dv2W6BGtmZC5pK2z/d7tHO5Aki41PTCE+Oe7JLdlxV9bLhfkc
         lcHzDD+bEOOHvmWPd/q7wdH6F+Ja6M7kzlhUirXXSeuctquzhYdr4JrrYq6vqZqtae
         Kf4m8FAWMxF9Tlx98yOTZhcL6h+ddynYLetKwN4nvhf3xvSmHf66FVz5xm15dx9mmq
         LMQOx+ZwGkDxkyYavclsQdAkLzjjzmzWmgFlmcL+P2dubG2RjfBhgUcjYx5oWYG23I
         CFD44AH/6jIwFllxiVr0OVK7l7aNPwl8EPQa/2HuBGMmBlu/Bzt1lr6oPnpVRNlju1
         jJ6zIaGeSTWOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D11AEE29F30;
        Thu, 13 Oct 2022 16:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] kcm: avoid potential race in kcm_tx_work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166567981585.2135.10710327054695792890.git-patchwork-notify@kernel.org>
Date:   Thu, 13 Oct 2022 16:50:15 +0000
References: <20221012133412.519394-1-edumazet@google.com>
In-Reply-To: <20221012133412.519394-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, tom@herbertland.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 12 Oct 2022 13:34:12 +0000 you wrote:
> syzbot found that kcm_tx_work() could crash [1] in:
> 
> 	/* Primarily for SOCK_SEQPACKET sockets */
> 	if (likely(sk->sk_socket) &&
> 	    test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
> <<*>>	clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
> 		sk->sk_write_space(sk);
> 	}
> 
> [...]

Here is the summary with links:
  - [net] kcm: avoid potential race in kcm_tx_work
    https://git.kernel.org/netdev/net/c/ec7eede369fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


