Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A81D6F2EEC
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 08:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbjEAGuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 02:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjEAGuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 02:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E656B10E7;
        Sun, 30 Apr 2023 23:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8645C61ABD;
        Mon,  1 May 2023 06:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD31CC4339B;
        Mon,  1 May 2023 06:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682923819;
        bh=A6KFFdY42cfYoWosR+X1mV1xQ+RgbAEJsGJWk3w7tck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DwYGLbUojmCuTl0iyI3wlfAgDURETdBKQE5X8H5F+1Gh0zwo00duMEPUSl45TouhW
         X7FbFdRR20qRylY30haTFR580wcdoQc5gSEYy5JZM1TqVOzeYJvkbIBJaFij37PiSo
         7UMMcVhk2yiql/5D0bgkBCIwTzdx5KP8LpQi+Pi1ElS5A7IUauUeG25aGDrGvqywvD
         18TdKZWyxyaZCKgLP5MLTUkJeDA/IGBJ1yWVdtPr5xlYofAJRzOfeBanNKC9a0XVYL
         UFkbLI4O8kh9ohrwOlrGo/5GOjbx5Ui6ERS4J+XynNm7SqJVLsslumuMWUup1ra4f1
         gPtsT5k8XHRQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B80E7C43158;
        Mon,  1 May 2023 06:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] rxrpc: Timeout handling fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168292381974.24254.3122897495393665483.git-patchwork-notify@kernel.org>
Date:   Mon, 01 May 2023 06:50:19 +0000
References: <20230428202756.1186269-1-dhowells@redhat.com>
In-Reply-To: <20230428202756.1186269-1-dhowells@redhat.com>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Apr 2023 21:27:53 +0100 you wrote:
> Here are three patches to fix timeouts handling in AF_RXRPC:
> 
>  (1) The hard call timeout should be interpreted in seconds, not
>      milliseconds.
> 
>  (2) Allow a waiting call to be aborted (thereby cancelling the call) in
>      the case a signal interrupts sendmsg() and leaves it hanging until it
>      is granted a channel on a connection.
> 
> [...]

Here is the summary with links:
  - [net,1/3] rxrpc: Fix hard call timeout units
    https://git.kernel.org/netdev/net/c/0d098d83c5d9
  - [net,2/3] rxrpc: Make it so that a waiting process can be aborted
    https://git.kernel.org/netdev/net/c/0eb362d25481
  - [net,3/3] rxrpc: Fix timeout of a call that hasn't yet been granted a channel
    https://git.kernel.org/netdev/net/c/db099c625b13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


