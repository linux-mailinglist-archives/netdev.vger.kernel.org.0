Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C0F62F444
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241729AbiKRMK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241645AbiKRMKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08DC8FF91;
        Fri, 18 Nov 2022 04:10:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90503624B9;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E99EFC433D7;
        Fri, 18 Nov 2022 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668773416;
        bh=mcnd5sv49vx5RuMi9Gl3j1FsHor/0AfmfG3Fc/ebeQ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S1hJQa8jyj/vElSehjC80zR8nksInrcviaFJ9RpVSdbu4acQPfjGxZQgx9BjFSton
         fRLUormIT+YSRiimm/w7bg01swoKDnIpxo+6M2Gj6lK+QLsuJ+Nn87cVi0mM8P+Bti
         cdS5JHj87Y2NszMVkzL7eksvMN6vWVc0VJwOaldU2UMiBmrAHXC9WK4XjKN3SrCJ2R
         /0tju210YmgmZ7mXVpiMkuZZW/98B/17xmX0Y0OMlEMZZ4ra7xAgmia75bw9Km0sha
         Y074Huc1JEY/YY4/HylZFU0rxY6kplTbYPdsty6BmQeU+TRlYO2P9y8D1E/HpqpucM
         CDHbRICBQf2gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D118AE270F6;
        Fri, 18 Nov 2022 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] rxrpc: Fix race between conn bundle lookup and bundle
 removal [ZDI-CAN-15975]
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877341585.19277.2863856871968966029.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:10:15 +0000
References: <166860734864.2970191.10633905995607769951.stgit@warthog.procyon.org.uk>
In-Reply-To: <166860734864.2970191.10633905995607769951.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, zdi-disclosures@trendmicro.com,
        marc.dionne@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 16 Nov 2022 14:02:28 +0000 you wrote:
> After rxrpc_unbundle_conn() has removed a connection from a bundle, it
> checks to see if there are any conns with available channels and, if not,
> removes and attempts to destroy the bundle.
> 
> Whilst it does check after grabbing client_bundles_lock that there are no
> connections attached, this races with rxrpc_look_up_bundle() retrieving the
> bundle, but not attaching a connection for the connection to be attached
> later.
> 
> [...]

Here is the summary with links:
  - [net] rxrpc: Fix race between conn bundle lookup and bundle removal [ZDI-CAN-15975]
    https://git.kernel.org/netdev/net/c/3bcd6c7eaa53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


