Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF225FC1DF
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 10:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiJLIVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 04:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiJLIUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 04:20:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CA0B1BB5
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 01:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9A36B819BB
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62EE0C433B5;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665562816;
        bh=2xatay4cW/kjR2m5IxDp5ouAVBEKJ/kysmY+f8VA4Gk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q7M+NuU6je3DHOxT4OR7TFkYb+oRw3He9mr2TIr6AgK2gAa3w2V78bmDj+WiccdpY
         EG4vLmFDLOuGwaw1aGkQiUEA5CbH4BXeA/oPjzv8upZ0hQ0Ol+cw7yxfyzIlOfiDU2
         +PUKr0kIlmaNFTQ63xpecAeRdr3PI5KR+gbGL9ou80eJML2zYUHkF4oHWI5zBcHR2U
         Zr/1Ro9ch70RpoWxW09xmAZT4V1q6jV1VMxCT9D5I1oc5vwB6/WQjCJw/dWGfIN0ii
         5wBHLAd9Cc+/dnNcuhi8eC9VCnTHN+AkXuCaNZHALRurGoo0WuR5wgDnHmeTrOnqeK
         JEroD+xWPzpMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 46FD1E29F37;
        Wed, 12 Oct 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] inet: ping: give ping some care
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166556281628.4495.13408031594561351591.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Oct 2022 08:20:16 +0000
References: <20221011212729.3777710-1-eric.dumazet@gmail.com>
In-Reply-To: <20221011212729.3777710-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, maze@google.com, asml.silence@gmail.com,
        edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 11 Oct 2022 14:27:27 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> First patch fixes an ipv6 ping bug that has been there forever,
> for large sizes.
> 
> Second patch fixes a recent and elusive bug, that can potentially
> crash the host. This is what I mentioned privately to Paolo and
> Jakub at LPC in Dublin.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipv6: ping: fix wrong checksum for large frames
    https://git.kernel.org/netdev/net/c/87445f369cca
  - [net,2/2] inet: ping: fix recent breakage
    https://git.kernel.org/netdev/net/c/0d24148bd276

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


