Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAD74EEC0E
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 13:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345351AbiDALMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 07:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345353AbiDALMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 07:12:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92C9274292
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 04:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51E27618C8
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8D93C340F3;
        Fri,  1 Apr 2022 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648811412;
        bh=QJzm2D321NMHRB8NQM3xVtBMZHXj4I0xti6eCeZ8w54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QGTFZ8YsMKz4n8JDtceKtb6ImJ/kjqggEoo3FDs70ZGjKkUpz4LzJqG/iRjU6osKl
         7SY/Ga/jHceA+2Mpzlee938abf8S6nHC+9b0lmV31wID4cg/AZEcuGWVYEctriH7pw
         yw+fPdsdfqD5JPpuua6f7F4+rqqS4TUniWHDPG3sBithjMFnW9yeQOOHg7PHcXsc4+
         pZiB6fH5OMKRkKpd/Wt2Ng13IFGDwk/WwtPeIKjtmPkXilJT7DM89mXslaf+sFH7Gt
         GeMx0G0UDGZc6Kavm8M1lxC8GpH4D+/VMzEBLyos6RMEjWgx4PdtUeHChY7k/w8RGd
         ebRjPW0/32nGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8CEE0E6BBCA;
        Fri,  1 Apr 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] MCTP fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164881141257.17879.16170877282046103440.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Apr 2022 11:10:12 +0000
References: <20220401024844.1578937-1-matt@codeconstruct.com.au>
In-Reply-To: <20220401024844.1578937-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, mjrinal@g.clemson.edu,
        jk@codeconstruct.com.au, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Apr 2022 10:48:41 +0800 you wrote:
> Hi,
> 
> The following are fixes for the mctp core and mctp-i2c driver.
> 
> Thanks,
> Matt
> 
> [...]

Here is the summary with links:
  - [net,1/3] mctp: Fix check for dev_hard_header() result
    https://git.kernel.org/netdev/net/c/60be976ac451
  - [net,2/3] mctp i2c: correct mctp_i2c_header_create result
    https://git.kernel.org/netdev/net/c/8ce40a2fd350
  - [net,3/3] mctp: Use output netdev to allocate skb headroom
    https://git.kernel.org/netdev/net/c/4a9dda1c1da6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


