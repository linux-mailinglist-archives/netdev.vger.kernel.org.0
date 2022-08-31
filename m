Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94285A8648
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbiHaTAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiHaTAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F101BB49E;
        Wed, 31 Aug 2022 12:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6AC676151B;
        Wed, 31 Aug 2022 19:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B790AC433D7;
        Wed, 31 Aug 2022 19:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661972416;
        bh=fS7uZ2UAWTMlWgJRbaxFDtbVCOaJtR4Iy2guBz8lY+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HqMUGYZYozSDw9FDjRw6HQoAfBGqvy8sRSxMHj609FuQfvHmKysI324MgcKrbC7/z
         U1m5DqwLrCJotgiGsFnVRo/7gqeaDpSsbF9nZVXJ/jryzbT7ASRVPY224Sk3Aqv/UM
         h7F/3RTG0tglC5NZRjM1yMYPr826Bg+QElxgYfSCi8fMskN8U4moL8Rwv8qNL0cdzv
         shOR5C8f9HmZ3k2uEc0KCSVNtCYuCPgT3vnyBEnGpNMm6DDOLFofF5vEcS0hNISd3a
         6YeWQHU8HYGHIVUVI9+JvUwjFl0KXKmtFp1zH/CD8TlE6ZXIJgniljVajwCzrF87Tm
         LZfdFFz91Lv7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DB83E924DC;
        Wed, 31 Aug 2022 19:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] xsk: fix backpressure mechanism on Tx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166197241664.25924.2251961834366979547.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 19:00:16 +0000
References: <20220830121705.8618-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220830121705.8618-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org
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

This patch was applied to bpf/bpf.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 30 Aug 2022 14:17:05 +0200 you wrote:
> Commit d678cbd2f867 ("xsk: Fix handling of invalid descriptors in XSK TX
> batching API") fixed batch API usage against set of descriptors with
> invalid ones but introduced a problem when AF_XDP SW rings are smaller
> than HW ones. Mismatch of reported Tx'ed frames between HW generator and
> user space app was observed. It turned out that backpressure mechanism
> became a bottleneck when the amount of produced descriptors to CQ is
> lower than what we grabbed from XSK Tx ring.
> 
> [...]

Here is the summary with links:
  - [bpf] xsk: fix backpressure mechanism on Tx
    https://git.kernel.org/bpf/bpf/c/c00c4461689e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


