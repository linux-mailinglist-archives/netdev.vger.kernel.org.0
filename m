Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80784E4C48
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 06:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241702AbiCWFbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 01:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiCWFbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 01:31:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A900E70CD3
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 22:30:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C1AAB81DFF
        for <netdev@vger.kernel.org>; Wed, 23 Mar 2022 05:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07C91C340EE;
        Wed, 23 Mar 2022 05:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648013410;
        bh=melhuRLwyn0fe9pYl3yHUvFxOzQNFHo61sm/ZSaLw4E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FXGCQkpkpAfUN6mQZsLE0YYczttiYGRK6WDgbkOK36tnoeR0k7Guw1PHFjTRCgSOw
         1TaRDAxB6u9FNDHEtRHS2ck3Bre31nhnKvVY82EpWC9TSeUYFPfcEq14DRjssY3Z5X
         oXGN1+YSLN+a35xfqQB/t0izOvHRwQF1IoF2XRK8G1TdQfpc3jbiaCMwkURYJ7Ao7Q
         RSSGBAt/F0SbrU/JH0XT6LVI59XdI/JiRMvVodIvdNyFuuAJwc3obErfJGyJtpzZxb
         jznS58eHGG5QQXwWt20nGxQaAUvaWDoAtgLgbODAuVtyg8piY1f44x/XtXBtPKNxUu
         zY+AGXjrJAmHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1C83EAC09C;
        Wed, 23 Mar 2022 05:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] net: geneve: add missing netlink policy and size
 for IFLA_GENEVE_INNER_PROTO_INHERIT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164801340992.16633.4779843573435618547.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Mar 2022 05:30:09 +0000
References: <20220322043954.3042468-1-eyal.birger@gmail.com>
In-Reply-To: <20220322043954.3042468-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Mar 2022 06:39:54 +0200 you wrote:
> Add missing netlink attribute policy and size calculation.
> Also enable strict validation from this new attribute onwards.
> 
> Fixes: 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol")
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> 
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: geneve: add missing netlink policy and size for IFLA_GENEVE_INNER_PROTO_INHERIT
    https://git.kernel.org/netdev/net-next/c/36c2e31ad25b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


