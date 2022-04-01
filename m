Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839654EEBE8
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345282AbiDALCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:02:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345270AbiDALCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F6CE887B
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 04:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44795B8247E
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC9E8C34110;
        Fri,  1 Apr 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648810812;
        bh=iFbY05zd4ALOn0xJkV403Peo1O+vCd5qZMMAxijULY8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fgC39MvByoYkyjKdj6oI5v+3mOMy0EzQfjdYcpqPfAwrNLMWdkWFxpdzkdNvxxiiW
         fE5GFs6VRvoRP6eK/BfqR3RJnE450aD45GMmHEQYVlAzfBf1yuRSR9YfXU010dd4Ml
         schr5kRHuzJJcDwNwdwZfu668Uw2rLyMn9+x6eIMqNlgFwqA4LA9oUABAhkn2K6oOO
         jM6PlThKleu1bWn+G6CIpMYtHKiZ4agn1dmF/9Z+vriPnZQ6BfTIqv5G+ucw/g3Ojy
         Rjda5XTMvMpPZLSAGSBC1gzHsW/pj8S+OoS5n0NcyBQmtgZ28xlt5bngRbLq+Z2l0q
         /j9eTi+MVVlQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1C78E6BBCA;
        Fri,  1 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
 recycling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881081185.13357.12292482117653460974.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 11:00:11 +0000
References: <20220331102440.1673-1-jean-philippe@linaro.org>
In-Reply-To: <20220331102440.1673-1-jean-philippe@linaro.org>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc:     ilias.apalodimas@linaro.org, alexanderduyck@fb.com,
        linyunsheng@huawei.com, hawk@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
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

On Thu, 31 Mar 2022 11:24:41 +0100 you wrote:
> Fix a use-after-free when using page_pool with page fragments. We
> encountered this problem during normal RX in the hns3 driver:
> 
> (1) Initially we have three descriptors in the RX queue. The first one
>     allocates PAGE1 through page_pool, and the other two allocate one
>     half of PAGE2 each. Page references look like this:
> 
> [...]

Here is the summary with links:
  - [net,v3] skbuff: fix coalescing for page_pool fragment recycling
    https://git.kernel.org/netdev/net/c/1effe8ca4e34

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


