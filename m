Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE02550211
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383771AbiFRCkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbiFRCkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:40:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55229579A0;
        Fri, 17 Jun 2022 19:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1AD8B82C58;
        Sat, 18 Jun 2022 02:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 82D0CC3411C;
        Sat, 18 Jun 2022 02:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655520014;
        bh=o7jBpmMOKLjw6FNsH7yz2iryN+gyCjJm0mtwEcJEIaw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nTQosznrCVyvR+QvowEzCZbOVafPTFSqoANfL3Pcs1T3yk1RmfuOnp2YB4jXGhR7m
         guXyyvidnlbZG8Rs+Rf6eN+Gbjlw4pIvO/9s/YmwVhL78O7/8x/E2q7RW2kK9RfkGl
         4Ca4kxF4RaWQCngN9LZtkiXpC22fBFZxEQDKkyA+rMO4nisHDqTba+4oAIE5/N0izi
         AsznoLJgYFVdaf2VVWjnHiyko7uI42/NQwZB54WZdCGuYRa3+8QlLv5kzIc3U435sY
         HKiV4KRrCQnV+ez5GT3D/w4USPk8BNi7ZFWAJwaljfIT9dGZy3mxOzsoDA/6kaYLAr
         neRBDCNzujQWg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6540EE7387A;
        Sat, 18 Jun 2022 02:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf-next 2022-06-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165552001441.16997.16713667865294840408.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Jun 2022 02:40:14 +0000
References: <20220617220836.7373-1-daniel@iogearbox.net>
In-Reply-To: <20220617220836.7373-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 18 Jun 2022 00:08:36 +0200 you wrote:
> Hi David, hi Jakub, hi Paolo, hi Eric,
> 
> The following pull-request contains BPF updates for your *net-next* tree.
> 
> We've added 72 non-merge commits during the last 15 day(s) which contain
> a total of 92 files changed, 4582 insertions(+), 834 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf-next 2022-06-17
    https://git.kernel.org/netdev/net/c/582573f1b23d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


