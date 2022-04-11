Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F8A4FBAE8
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344415AbiDKLcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343562AbiDKLc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:32:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AB73F317;
        Mon, 11 Apr 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 445EBB81597;
        Mon, 11 Apr 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F00DCC385A6;
        Mon, 11 Apr 2022 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649676612;
        bh=pjZNzNv0uEjXH++teBDVZomE2/r2Y5twyj2fiWD0Wpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TLnYGQdQn+BbN0ezY+DZ+QoNKYucmVqyiNU6c0Nc1RC8xpZGNI8FdhIORk+Ppl4hW
         1U5ehBfKujRo6cD5UDpa5UfoZidptcsXPPnj0jMkogTtqVM+I8KtvjeJNQzppGK++E
         xY/w0DKwTEgsLut8xFbBc3jj2mtVWzBd3bVVwawilGq6QPmJ4/TXb38vC7NNMrTFLM
         fEE3PWww0d/dQNrW45cnx4uGoEi3wm6k3/TCWkA6NBGCUlEJU0XnSt3/zeAenvWJ5f
         og2bLGkgZ0B3z6pCDWk3gM/jTzFFf9g2UrH3vh+KVNqLCu6emFH3kpxtijbKHkI4op
         RhrzAZxcyN14g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D281FE85B76;
        Mon, 11 Apr 2022 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv6: fix panic when forwarding a pkt with no in6 dev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967661185.4707.11814594786150441538.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 11:30:11 +0000
References: <20220408140342.19311-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220408140342.19311-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     edumazet@google.com, kongweibin2@huawei.com, davem@davemloft.net,
        kuba@kernel.org, willemb@google.com, asml.silence@gmail.com,
        dsahern@kernel.org, vvs@virtuozzo.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        rose.chen@huawei.com, liaichun@huawei.com, stable@vger.kernel.org
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

On Fri,  8 Apr 2022 16:03:42 +0200 you wrote:
> kongweibin reported a kernel panic in ip6_forward() when input interface
> has no in6 dev associated.
> 
> The following tc commands were used to reproduce this panic:
> tc qdisc del dev vxlan100 root
> tc qdisc add dev vxlan100 root netem corrupt 5%
> 
> [...]

Here is the summary with links:
  - [net] ipv6: fix panic when forwarding a pkt with no in6 dev
    https://git.kernel.org/netdev/net/c/e3fa461d8b0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


