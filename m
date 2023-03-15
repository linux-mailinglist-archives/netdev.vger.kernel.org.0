Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B026BA964
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbjCOHdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbjCOHcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:32:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BC25C13F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 00:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A663161B16
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 011F4C4339B;
        Wed, 15 Mar 2023 07:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678865419;
        bh=5nH41gQl+1CjEKH3+/CinyLd1iYTWkcfHPWHi5LhEfY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kWEGVA9UTtzEs4aDrbcdzSkMd2tHIAjRiI3Ime7kj/QeciAlCLRxviLMuUwR/9myR
         SPbQczxZSnFHyMJn1+qIFmOcaJWMXKOjiVcWXb3gmKyjsNgRHQYnEZ/n5Qc9zn52aM
         ++ZA+PizqmVz8pD00M8Y6Tm3Yu+gidPZhG5QQ6DaL0GsUrJxr+Zd3q+mFCRXXXD9pE
         OCm/s8HZJcLNKWBiaS56G3KPTi4ov4drIdcy3RJ0DgRBrA7VIN861JJXleTpU/+dFw
         K5NFki7gBdav9PYRgXBX7ZlTQNp/bj/33LZqlhPApNIV2gJP5N/d8BX8LNCkI4L5me
         uoN1LJfH3YIeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBFB6C43161;
        Wed, 15 Mar 2023 07:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 0/2] tcp: Fix bind() regression for dual-stack wildcard
 address.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886541889.32297.4810741018223268568.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 07:30:18 +0000
References: <20230312031904.4674-1-kuniyu@amazon.com>
In-Reply-To: <20230312031904.4674-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, dsahern@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 11 Mar 2023 19:19:02 -0800 you wrote:
> The first patch fixes the regression reported in [0], and the second
> patch adds a test for similar cases to catch future regression.
> 
> [0]: https://lore.kernel.org/netdev/e21bf153-80b0-9ec0-15ba-e04a4ad42c34@redhat.com/
> 
> 
> Kuniyuki Iwashima (2):
>   tcp: Fix bind() conflict check for dual-stack wildcard address.
>   selftest: Add test for bind() conflicts.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/2] tcp: Fix bind() conflict check for dual-stack wildcard address.
    https://git.kernel.org/netdev/net/c/d9ba99342855
  - [v1,net,2/2] selftest: Add test for bind() conflicts.
    https://git.kernel.org/netdev/net/c/13715acf8ab5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


