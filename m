Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3E75A19EE
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiHYUB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243513AbiHYUA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:00:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7E007EFF5;
        Thu, 25 Aug 2022 13:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5622BB82B1D;
        Thu, 25 Aug 2022 20:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF9F8C43470;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661457617;
        bh=BNrGzd7NIjVzi9s4eNma05jhnSco+a5fLzOuce10eYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UM8o3aa6sBMWyiKw8BTI+B50mPWJQJNlFNPmQkxu1v65DkCIrbplM0kcO4h2lmnDE
         +2imx4SqI4DcYBPVYlMt1V4eVwjX53HrB0mmbix/KW3NaG3txFw0uA+UlvT3uNBa0X
         +c0osoqE4vhh/0UAa0RwkC+W3cNKee9P3Lk0PKBMKq3iUginyaMXH75YHSYmhHcIz5
         JuvBq8xfcPyEo7e8qdvtC3LG+kyxpqPQVI17ZuLPjKKSzHE4WIooG4E7f2mNAUeFMT
         5Sz+LHQdlIgtp7+r8V8tI+xw8hWRAupi4b6AGrY2xq4iaq091QgGgUcdpoyxsjNFCM
         5sLKhBBG3QEjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C401CE2A040;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] net: lantiq_xrx200: fix errors under memory
 pressure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166145761779.4210.4722079449152201600.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 20:00:17 +0000
References: <20220824215408.4695-1-olek2@wp.pl>
In-Reply-To: <20220824215408.4695-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Aug 2022 23:54:05 +0200 you wrote:
> This series fixes issues that can occur in the driver under memory pressure.
> Situations when the system cannot allocate memory are rare, so the mentioned bugs
> have been fixed recently. The patches have been tested on a BT Home router with the
> Lantiq xRX200 chipset.
> 
> Changelog:
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] net: lantiq_xrx200: confirm skb is allocated before using
    https://git.kernel.org/netdev/net/c/c8b043702dc0
  - [net,v3,2/3] net: lantiq_xrx200: fix lock under memory pressure
    https://git.kernel.org/netdev/net/c/c4b6e9341f93
  - [net,v3,3/3] net: lantiq_xrx200: restore buffer if memory allocation failed
    https://git.kernel.org/netdev/net/c/c9c3b1775f80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


