Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7536E87C5
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232361AbjDTCBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232596AbjDTCAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:00:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B8D4C0A
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7729164478
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 02:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7499C433EF;
        Thu, 20 Apr 2023 02:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681956021;
        bh=9WbromZ7mg8mCUPJ9kLnfc6Cz2r1KJRy7y+/bTCJmgM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WhCTdfzmuHxkI6zRqEuKVplHVVWHCKOceiseOlqCJclgfP2pOBq8VJuzmPY2j+dmf
         2dB8RNPdpvnef73iXy1AAiTOe0C9dzCrKBALvnisX6vhTG5QuSWZ03Qb7jiEtoKft4
         gXKF+XXRw040GvE/8Ap5oxi7WMEhw6eJiNiWB3GwM4wdvauWvYBJSBnQYEQkzxb68c
         iyJOp6Ti9ul1CeRN9PW6NDyvzbq/rMyrjSumpvaggF2yAmt2ezqx2RvnfBPLh0d2Ki
         qU6RW2nExFZWtq/yWlFc/+HkCYjeAKs46uAUIaXcBv/NOo2O8k95BaFbQb3t79chlm
         Onp2YrCNQUccQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C35C1C561EE;
        Thu, 20 Apr 2023 02:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v10 0/4] Another crack at a handshake upcall mechanism
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195602179.17998.18228073558514714292.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 02:00:21 +0000
References: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
In-Reply-To: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
To:     Chuck Lever <cel@kernel.org>
Cc:     kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org, kernel-tls-handshake@lists.linux.dev
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

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 17 Apr 2023 10:32:12 -0400 you wrote:
> Hi-
> 
> Here is v10 of a series to add generic support for transport layer
> security handshake on behalf of kernel socket consumers (user space
> consumers use a security library directly, of course). A summary of
> the purpose of these patches is archived here:
> 
> [...]

Here is the summary with links:
  - [v10,1/4] .gitignore: Do not ignore .kunitconfig files
    https://git.kernel.org/netdev/net-next/c/2bc42f482bed
  - [v10,2/4] net/handshake: Create a NETLINK service for handling handshake requests
    https://git.kernel.org/netdev/net-next/c/3b3009ea8abb
  - [v10,3/4] net/handshake: Add a kernel API for requesting a TLSv1.3 handshake
    https://git.kernel.org/netdev/net-next/c/2fd5532044a8
  - [v10,4/4] net/handshake: Add Kunit tests for the handshake consumer API
    https://git.kernel.org/netdev/net-next/c/88232ec1ec5e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


