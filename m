Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DF45A60EE
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiH3KkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiH3KkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:40:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5743220D8
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 82755614C7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 10:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E54E4C433B5;
        Tue, 30 Aug 2022 10:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661856018;
        bh=eCb6O6zJz//LHTIBwpPGKBF/7hHFpA6KIDuA5ugmMEs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kS6GJ4w2rYvjGz7BOYhNNYiuffj0S1Yfpu7o8JbCG4THvbCbNJ3P7G+9X0kCngWo4
         ejuMzN8K1ebKnccEUE8A2ueT1czAtvI7iSbPz1whbthVhAEE7nIM3SUhT15x8GB/9v
         AmUCUgFs9bQtvir4jgtc9WW9gixN0Nzj1TTGMDKfZFtbKbKPQhQzOedXqndz/XU0l9
         IpUeserO3mzhhsuSiJ2L5FelCZQ3MM+G90vI9+i9T2jm9JArQ8aKMnwV7T9CDarfVX
         48iAiHmZk+fiFflbjAcqcU01yz+f09ShNXgshjcEhWQRzzvF8sJGolJFLCSNDGPdt8
         RB+5MMn8XYUPg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6581E924D8;
        Tue, 30 Aug 2022 10:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/6] netlink: support reporting missing attributes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166185601780.10964.10586221862767455516.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 10:40:17 +0000
References: <20220826030935.2165661-1-kuba@kernel.org>
In-Reply-To: <20220826030935.2165661-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, mkubecek@suse.cz, johannes@sipsolutions.net,
        idosch@idosch.org, dsahern@gmail.com, stephen@networkplumber.org
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

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 25 Aug 2022 20:09:29 -0700 you wrote:
> This series adds support for reporting missing attributes
> in a structured way. We communicate the type of the missing
> attribute and if it was missing inside a nest the offset
> of that nest.
> 
> Example of (YAML-based) user space reporting ethtool header
> missing:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/6] netlink: factor out extack composition
    https://git.kernel.org/netdev/net-next/c/0c95cea24f30
  - [net-next,v3,2/6] netlink: add support for ext_ack missing attributes
    https://git.kernel.org/netdev/net-next/c/690252f19f0e
  - [net-next,v3,3/6] netlink: add helpers for extack attr presence checking
    https://git.kernel.org/netdev/net-next/c/45dca1575964
  - [net-next,v3,4/6] devlink: use missing attribute ext_ack
    https://git.kernel.org/netdev/net-next/c/1f7633b58fac
  - [net-next,v3,5/6] ethtool: strset: report missing ETHTOOL_A_STRINGSET_ID via ext_ack
    https://git.kernel.org/netdev/net-next/c/08d1d0e78440
  - [net-next,v3,6/6] ethtool: report missing header via ext_ack in the default handler
    https://git.kernel.org/netdev/net-next/c/4f5059e62921

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


