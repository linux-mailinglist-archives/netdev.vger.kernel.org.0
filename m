Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 447776C4EC3
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjCVPAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCVPA1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:00:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E2412854
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:00:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2A245CE1DD6
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 15:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C7AEC4339B;
        Wed, 22 Mar 2023 15:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679497218;
        bh=3lMPq9Msn1oqIrd4+/wz0qh2dcbkz1vVC2SRlI4/t6M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y2hdO71i5AdgmE1LN929pZu9TicGxtIAWSajoD/AOf/48Zjew2E4nX6AKASYWjnki
         BujTwAH4bPuhF8Y8zMJWB+E9mT9IeYgfmp1hDAMaiUQomSP1H6wSxx9fhF+lonY5Gs
         /gJ9wFJNEhUEEWqMZLWQGdHf9cryS2Nq5oUv5UdYwJqPhgIecgtHkq7BDfJzGzUfHG
         6MacpY1jzMy4BVQg3krG/aRe3xWRNv8J2mh4z2KcykHwEMjMigU2jJc5b2N70VtlRY
         bPJwj94tTHcERyG3mxsYT0XRXVk5ixkJL/XTS0zT35DkSxhrVukdv3ykTPjL5rJKRH
         rNiyU76s6bEvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E35EE4F0DA;
        Wed, 22 Mar 2023 15:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mlxsw: spectrum_fid: Fix incorrect local port type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167949721831.25738.13825125885899226485.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Mar 2023 15:00:18 +0000
References: <eace1f9d96545ab8a2775db857cb7e291a9b166b.1679398549.git.petrm@nvidia.com>
In-Reply-To: <eace1f9d96545ab8a2775db857cb7e291a9b166b.1679398549.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com, danieller@nvidia.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 21 Mar 2023 12:42:00 +0100 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Local port is a 10-bit number, but it was mistakenly stored in a u8,
> resulting in firmware errors when using a netdev corresponding to a
> local port higher than 255.
> 
> Fix by storing the local port in u16, as is done in the rest of the
> code.
> 
> [...]

Here is the summary with links:
  - [net] mlxsw: spectrum_fid: Fix incorrect local port type
    https://git.kernel.org/netdev/net/c/bb765a743377

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


