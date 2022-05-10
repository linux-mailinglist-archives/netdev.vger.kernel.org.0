Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32454520AB2
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 03:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbiEJBeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 21:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbiEJBeK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 21:34:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CE1D283A1E
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50C8AB81A69
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B545C385C7;
        Tue, 10 May 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652146213;
        bh=0e7szcWNxD5+Cl3LtGIEmRehXKD8dn5mFngEOI2sidE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rskn/jFKwncoJB8n/ut/xeKVJAX9b/MVMnJjtY7V7Xm8Gg/SSBjWEEni5s298MkLS
         wtFhPARY8YKau/rJ7l5Z5v1tjVkT1HpRMZyhATgFXQy0B8CCYWiTTW4At98lS+QJ1v
         LMrcQ8p5HpfuqKSN7pKUpui2gpnq/Vh2UHStDtSOD8E4+cgGtGWDdgMM8MmoMoL6fx
         jAcz41V3v4SKN9Oa0Zit/YurTcj65u1FBbddgXqUyiEiVQ4qnawhJENu1Giq6siDKm
         /FhvEsWaGFvBSYiZ2DIoohPXtk6Fyx4TMTc8cZ/gK1EoKiK/jDn7NsLZIXtcV5IgP6
         oQCqZ5yswd0Pw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2492F0392B;
        Tue, 10 May 2022 01:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] nfp: support Corigine PCIE vendor ID
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165214621292.19985.10851056151206457947.git-patchwork-notify@kernel.org>
Date:   Tue, 10 May 2022 01:30:12 +0000
References: <20220508173816.476357-1-simon.horman@corigine.com>
In-Reply-To: <20220508173816.476357-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, yu.xiao@corigine.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  8 May 2022 19:38:14 +0200 you wrote:
> Historically the nfp driver has supported NFP chips with Netronome's
> PCIE vendor ID. This patch extends the driver to also support NFP
> chips, which at this point are assumed to be otherwise identical from
> a software perspective, that have Corigine's PCIE vendor ID (0x1da8).
> 
> This patchset begins by cleaning up strings to make them:
> * Vendor neutral for the NFP chip
> * Relate to Corigine for the driver itself
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] nfp: vendor neutral strings for chip and Corigne in strings for driver
    https://git.kernel.org/netdev/net-next/c/34e244ea1507
  - [net-next,2/2] nfp: support Corigine PCIE vendor ID
    https://git.kernel.org/netdev/net-next/c/299ba7a32a3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


