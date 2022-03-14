Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9394D7F7E
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 11:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbiCNKL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 06:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238372AbiCNKLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 06:11:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB6F3C48A;
        Mon, 14 Mar 2022 03:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 64042CE113D;
        Mon, 14 Mar 2022 10:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4C0FC340F7;
        Mon, 14 Mar 2022 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647252611;
        bh=bYIm4hVM0CHF3WLrx87iPpNZexuy3p8S541z5pRuYUk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n1v0gZF+Jhloy6nMoODxDf3Pqe5EyRCEi5hfQXIz13G1uFihyDaOIjLKL+3bUT9RX
         vPZP9EAR1N6YQ8yr/m4jfFGkjhSA00dWuQWIqpYHKOvsSyyKnT1q3/nqmEu9+2c/7h
         Tt/HCoAMaVrKvJfCmmHmf+MNo5VsD3aPggNHL9YGjAWoERFIEq34mffvPtEYurzmuy
         Z2NhYYCtBtw6sAivAjvgUVMxHrn63fWKUrPe2xi9jXRyr95Ln1qWw/ikXDw8SmmeO+
         cvuZfeSXOrJno8UkyBdKDKyXJmxn8l3RWYcIrL7LFNTBNQgfY/+caqULT3uGXvuf6g
         DZx3KaHUjL7Ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8F862E6D44B;
        Mon, 14 Mar 2022 10:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: macvlan: fix potential UAF problem for
 lowerdev
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164725261157.13129.12736326177131205389.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Mar 2022 10:10:11 +0000
References: <cover.1646989143.git.william.xuanziyang@huawei.com>
In-Reply-To: <cover.1646989143.git.william.xuanziyang@huawei.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Mar 2022 17:02:41 +0800 you wrote:
> Add the reference operation to lowerdev of macvlan to avoid
> the potential UAF problem under the following known scenario:
> 
> Someone module puts the NETDEV_UNREGISTER event handler to a
> work, and lowerdev is accessed in the work handler. But when
> the work is excuted, lowerdev has been destroyed because upper
> macvlan did not get reference to lowerdev correctly.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: macvlan: fix potential UAF problem for lowerdev
    https://git.kernel.org/netdev/net-next/c/291ac68478d9
  - [net-next,2/2] net: macvlan: add net device refcount tracker
    https://git.kernel.org/netdev/net-next/c/1f4a5983d623

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


