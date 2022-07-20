Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C24DC57B44A
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232239AbiGTKKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiGTKKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:10:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD20BC2E;
        Wed, 20 Jul 2022 03:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 140CA61B94;
        Wed, 20 Jul 2022 10:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6BB53C341C7;
        Wed, 20 Jul 2022 10:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658311813;
        bh=G5lcsN93lE1Lx2+6TicW+95uG/NcAeaab3JZC3ihO/8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BfhU6z0yYPnB7amQDZ/YrXuvjkp9QCfqExo1O3ctYBN2JLXNRc7bUQ8n0w5aRreV4
         LBQcoCcZDdbccOeAjVlLJetTuDNptreo0doe0C62iCCVLv1zXTfJCBTahT4fTnzjNy
         7Hrdc2vnfBrpkx5MUYjeiYXMp15AE+U7LBA9dkHVvagur2KFTPxyXb2YRIr24RA4De
         1I1RucmzNhjAVknCw4PGtIYeLOf3QkKrfrGH0WP9RIhgSPq/0GV8TuicX9hmX3WZA8
         k0ZA/xFvVEmZ7IquydBO+62RnCXKMyjGf5ybTjbpXoqCy0ux2djxngcfvgHkvRuhUd
         bN57kj+qPu1Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55A8ED9DDDD;
        Wed, 20 Jul 2022 10:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: spectrum_router: Fix IPv4 nexthop gateway
 indication
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165831181334.8290.14977545532597749218.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 10:10:13 +0000
References: <20220719122626.2276880-1-idosch@nvidia.com>
In-Reply-To: <20220719122626.2276880-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, nicolas.dichtel@6wind.com, dsahern@gmail.com,
        mlxsw@nvidia.com, stable@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 19 Jul 2022 15:26:26 +0300 you wrote:
> mlxsw needs to distinguish nexthops with a gateway from connected
> nexthops in order to write the former to the adjacency table of the
> device. The check used to rely on the fact that nexthops with a gateway
> have a 'link' scope whereas connected nexthops have a 'host' scope. This
> is no longer correct after commit 747c14307214 ("ip: fix dflt addr
> selection for connected nexthop").
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication
    https://git.kernel.org/netdev/net/c/e5ec6a251338

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


