Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEFD6B2E0E
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 21:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCIUAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 15:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjCIUAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 15:00:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D30FA8DE;
        Thu,  9 Mar 2023 12:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C96DB82088;
        Thu,  9 Mar 2023 20:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1429BC433D2;
        Thu,  9 Mar 2023 20:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678392018;
        bh=ghTPUr8Y9UcJYMB55rlQXEdOc5NzVVj2fiPMBgsL30M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=caTMDFtjQSi0VwcxdjUUJh2Sm8c9jkyu8HFUs0dIdlfYQYO6ccKxhsyB0IxAy6on7
         ruapcN8UwXlrS7o/sDZEcxURwUSAoMtp56HHsF8+PyopsK7ukJ4u3zgFE4XJy7dkNS
         pCx2Za/HUTRJ9dtcW85QokuqgVnyj/x49coKSRg0qhbIDUembzgjLLsGMH2jMS2KS9
         UF4VJHyPxwN7i381H6JQ9KtqKISLdRqSSFGUnTNdy0BNFJh8FEQEs6NxOHeRhlqWP6
         PLQ0W6aHbOdW/8mOOydHqolO1dCSz3fbeMObVLf84zvN8sujVvPxCj0vYZsewfvYOs
         QrKWeQ3ZprrUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EADE3E4D008;
        Thu,  9 Mar 2023 20:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v2 0/2] selftests/bpf: use ifname instead of ifindex
 in XDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167839201795.28882.17670469043875720414.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 20:00:17 +0000
References: <cover.1678382940.git.lorenzo@kernel.org>
In-Reply-To: <cover.1678382940.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        andrii@kernel.org, lorenzo.bianconi@redhat.com,
        daniel@iogearbox.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Thu,  9 Mar 2023 18:32:39 +0100 you wrote:
> Use interface name instead of interface index in XDP compliance test tool logs.
> Improve XDP compliance test tool error messages.
> 
> Changes since v1:
> - split previous patch in two logically separated patches
> 
> Lorenzo Bianconi (2):
>   selftests/bpf: use ifname instead of ifindex in XDP compliance test
>     tool
>   selftests/bpf: improve error logs in XDP compliance test tool
> 
> [...]

Here is the summary with links:
  - [bpf-next,v2,1/2] selftests/bpf: use ifname instead of ifindex in XDP compliance test tool
    https://git.kernel.org/bpf/bpf-next/c/27a36bc3cdd5
  - [bpf-next,v2,2/2] selftests/bpf: improve error logs in XDP compliance test tool
    https://git.kernel.org/bpf/bpf-next/c/c1cd734c1bb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


