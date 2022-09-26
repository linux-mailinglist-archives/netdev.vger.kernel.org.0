Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1685EB049
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbiIZSmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiIZSlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:41:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A6236DD1;
        Mon, 26 Sep 2022 11:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85743B80D6D;
        Mon, 26 Sep 2022 18:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36DEAC43145;
        Mon, 26 Sep 2022 18:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664217616;
        bh=c9t01XksT+oembUr1RDy0+WGWqE7NmA3OHSQd7BOm28=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rjowAN3KDTfupNjuBdVRphyBtjVkD7uyz+inNiJ7x8/aRy9BI2yziLR2WbiEOgZut
         +I4P59qIVhaCZ4/EPb7ycbHhnCo4UVZZJwNpholCmrtnOIraUyolZwzfwbaROY7int
         7RzlSIS72IisKMKReijhn6vrjTuarZ4MGEf5sw2YMEAimtWlKbXf3qEiSjwC42g60H
         B2XIkwCRl59Igy6QY4Z1w8cU8Q1V/vbkvViVqPxK7r6f1l+Pb5fDhYobRbsYCTTH4D
         4LzJk1N9H2eZRTNXitKRDvrcnRaPa5Bf8uDSk8Pdac6n2XGHzsnmTShUAf/CGSWmMp
         uF7gjsVsRIcyQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FBE4E21EC6;
        Mon, 26 Sep 2022 18:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xdp: improve page_pool xdp_return performance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166421761605.17810.8276670438642023856.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 18:40:16 +0000
References: <166377993287.1737053.10258297257583703949.stgit@firesoul>
In-Reply-To: <166377993287.1737053.10258297257583703949.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lorenzo@kernel.org, mtahhan@redhat.com,
        mcroce@microsoft.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 21 Sep 2022 19:05:32 +0200 you wrote:
> During LPC2022 I meetup with my page_pool co-maintainer Ilias. When
> discussing page_pool code we realised/remembered certain optimizations
> had not been fully utilised.
> 
> Since commit c07aea3ef4d4 ("mm: add a signature in struct page") struct
> page have a direct pointer to the page_pool object this page was
> allocated from.
> 
> [...]

Here is the summary with links:
  - [net-next] xdp: improve page_pool xdp_return performance
    https://git.kernel.org/netdev/net-next/c/fb33ec016b87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


