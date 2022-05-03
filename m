Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F62E51822B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 12:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234155AbiECKXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 06:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbiECKXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 06:23:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A96B56
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 03:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39FFA6155C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 10:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9231EC385B0;
        Tue,  3 May 2022 10:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651573212;
        bh=9NfB3PlOpKoBvY5QOxpqc+nIML5zzz+HoABJz2g4bKo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pMO0MFr7zYyew5o+gszMSin2DikIJpcstIvZni/8CVeRewHPbGycPquKRyi7A5bw2
         gkp8w1PMKpmWxXvE/29GAPUxriLxaSD12AX2RCP886q5tVmafe/9XrszK4i7k1nYp5
         VgH89ocqmYyWHVuudmvkG1FqluLYMfkQc86UJbjyXA8Jd2/2yQzQvNfEZhEzG4udJI
         BsHQHaYp2gdRvtoM0aOcmevC0sltXLBkOIJUuwnmxEL42r7JHFH3opaPb+Sgilvav4
         AjhfNbNo3QeVzefAUCiGXUEftzmSRX9+24H0MOEN1QHCVwrM1ihUeEt6XqM07qy5ry
         kmz4gsg6LvAtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 73B17E8DD77;
        Tue,  3 May 2022 10:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] mlxsw: Remove size limitations on egress
 descriptor buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165157321247.11773.6202368589900505657.git-patchwork-notify@kernel.org>
Date:   Tue, 03 May 2022 10:20:12 +0000
References: <20220502084926.365268-1-idosch@nvidia.com>
In-Reply-To: <20220502084926.365268-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  2 May 2022 11:49:22 +0300 you wrote:
> Petr says:
> 
> Spectrum machines have two resources related to keeping packets in an
> internal buffer: bytes (allocated in cell-sized units) for packet payload,
> and descriptors, for keeping headers. Currently, mlxsw only configures the
> bytes part of the resource management.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] mlxsw: reg: Add "desc" field to SBPR
    https://git.kernel.org/netdev/net-next/c/135433b30a53
  - [net-next,2/4] mlxsw: Configure descriptor buffers
    https://git.kernel.org/netdev/net-next/c/c864769add96
  - [net-next,3/4] selftests: forwarding: lib: Add start_traffic_pktsize() helpers
    https://git.kernel.org/netdev/net-next/c/1531cc632d13
  - [net-next,4/4] selftests: mlxsw: Add a test for soaking up a burst of traffic
    https://git.kernel.org/netdev/net-next/c/1d267aa8699b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


