Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6A25AE37A
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239610AbiIFIvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239604AbiIFIvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:51:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C92CF4D4FA
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 01:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B3C4B81665
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 08:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1A88C433D7;
        Tue,  6 Sep 2022 08:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662454214;
        bh=kGBaXhkfcNW1qTcO/1w0gh+ZJcmXCV+7W/axejpgCMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z+JbfQM2o9cLMYRHwvrB7lTStjOZTbURwz/FQV/6j4gQATBj6XqcXilkZVlyTQQBZ
         KsimWlw+Q58sbk0ZsZEyGZCX7tJwmi3rKYL/hvoAPo8EqGL1kQ7AUNT1bFdRV8nQ64
         RXmjKOt21C9Cid05vkDUR4u2G6DB3FLrrRTrBIFKM94tQy/t/bO5Z71sY5QSvQ9BTt
         cJ8+bfdfxYMDPIzgMrgckKEl0q4HMmn9Uq5Ut0NlDkwH0LNPuht8FEkdE93E92cnmC
         vX6/BT3vQh8yFkUDvwzs5UZAWPtE/pPLgnjs5CVRuu/NNQOqSG0R5pbborVPhTqPLP
         1j/DDCjRCdSRw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3712C4166E;
        Tue,  6 Sep 2022 08:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ftmac100: fix endianness-related issues from
 'sparse'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166245421386.19854.10123021050273510124.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Sep 2022 08:50:13 +0000
References: <20220902113749.1408562-1-saproj@gmail.com>
In-Reply-To: <20220902113749.1408562-1-saproj@gmail.com>
To:     Sergei Antonov <saproj@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Fri,  2 Sep 2022 14:37:49 +0300 you wrote:
> Sparse found a number of endianness-related issues of these kinds:
> 
> .../ftmac100.c:192:32: warning: restricted __le32 degrades to integer
> 
> .../ftmac100.c:208:23: warning: incorrect type in assignment (different base types)
> .../ftmac100.c:208:23:    expected unsigned int rxdes0
> .../ftmac100.c:208:23:    got restricted __le32 [usertype]
> 
> [...]

Here is the summary with links:
  - [net-next] net: ftmac100: fix endianness-related issues from 'sparse'
    https://git.kernel.org/netdev/net-next/c/9df696b3b3a4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


