Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1C63534A05
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 06:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241494AbiEZEuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 00:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232322AbiEZEuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 00:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D799D9AE62
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 21:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 605686195B
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EAD9C385B8;
        Thu, 26 May 2022 04:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653540612;
        bh=eKPI+rt6AplecBib/eTkj8NpF+rjNLqwFSjB4/ZcBlk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eQzvrVgO4jyvEiNChMb06eEZR3MGGmPUDNCRIGKZWkM6VGCg1U+KahgfDeI8cbccH
         buuw5vdfX8Vzrw21rno/AtOXr27m4zjUFK9unNzR+9nsQ+spveb6xhSA1YEVHqmjBw
         5ligGvzcgWOaYcBCXQrUnbohVk4+Gc2j3YLfe3FWqAMJpmKdvHBsC7EkcNLSAryz38
         WP5EmI9AaE+ezfkRWd3FsFE3MElSliMWyghkpaRFIRHlSLHFS3u7In/7mAtB6MaEex
         YH/HEDC4e30L9DpCA5ztybgadheOIcHywgxmb0CbCyoDI4GlfFfNaJ51OWErfpEB76
         lTqs0fQaAampA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84C37E8DD61;
        Thu, 26 May 2022 04:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] amt: fix several bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165354061254.15550.162749976602408807.git-patchwork-notify@kernel.org>
Date:   Thu, 26 May 2022 04:50:12 +0000
References: <20220523161708.29518-1-ap420073@gmail.com>
In-Reply-To: <20220523161708.29518-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 May 2022 16:17:05 +0000 you wrote:
> This patchset fixes several bugs in amt module
> 
> First patch fixes typo.
> 
> Second patch fixes wrong return value of amt_update_handler().
> A relay finds a tunnel if it receives an update message from the gateway.
> If it can't find a tunnel, amt_update_handler() should return an error,
> not success. But it always returns success.
> 
> [...]

Here is the summary with links:
  - [net,1/3] amt: fix typo in amt
    https://git.kernel.org/netdev/net/c/4934609dda03
  - [net,2/3] amt: fix return value of amt_update_handler()
    https://git.kernel.org/netdev/net/c/ac1dbf55981b
  - [net,3/3] amt: fix possible memory leak in amt_rcv()
    https://git.kernel.org/netdev/net/c/1a1a0e80e005

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


