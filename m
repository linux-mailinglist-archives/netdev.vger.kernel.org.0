Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B5E4B14FC
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244820AbiBJSKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:10:11 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiBJSKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:10:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB6C110C
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 10:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA87761E43
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 18:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14FC0C340EB;
        Thu, 10 Feb 2022 18:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644516610;
        bh=iMM9KVxk+GDqVz2qmQDYWhdgKoItbsg6IPYxH0pl54M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CSnh0VSzAIKARfqQnLBMH6PKkaPcab+4VYTygeOPOH5ReqyfIJjleBPsamJs5oxvB
         Xb0tYwG461/6YJgxGm0nm3osBZWtKhOjLKdAMpfkysWbbQOv/lnveKU9JjAumgrsqz
         quQQV5sO0x9vZ6jqg7pZsExiVQV+UYww4nG0PhCipdDHqJCOQnRtST9d9tXJrZtdnv
         LnDkiy35Xs9uzmye31x6bJI9tE+IawZbNbSqnBzY23pxJ32GnpppvJTRdnv00zz04B
         0MiensuAYLcZw7NnkBRbDr/c0uIMeW5UkKkqaBf2toPpNN8dxL9G0r01RQIAlOL6Fw
         6LT3BChzoNHAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECD90E5D084;
        Thu, 10 Feb 2022 18:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] tunnel: Fix missing space after local/remote
 print
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164451660996.28542.17555893745139008598.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 18:10:09 +0000
References: <20220209065415.7068-1-gal@nvidia.com>
In-Reply-To: <20220209065415.7068-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        netdev@vger.kernel.org
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

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed, 9 Feb 2022 08:54:15 +0200 you wrote:
> The cited commit removed the space after the local/remote tunnel print
> and resulted in "broken" output:
> 
> gre remote 1.1.1.2local 1.1.1.1ttl inherit erspan_ver 0 addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 65536 gso_max_segs 65535
>     ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Fixes: 5632cf69ad59 ("tunnel: fix clang warning")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next] tunnel: Fix missing space after local/remote print
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=25a9c4fa81c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


