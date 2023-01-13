Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0E3C66A50D
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 22:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjAMVU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 16:20:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjAMVU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 16:20:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31384FD6D
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 13:20:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 696D96233E
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 21:20:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA002C433F0;
        Fri, 13 Jan 2023 21:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673644854;
        bh=0jPBPnMLTppLiS/ZhgTSK1hqBkA0GzxFNF6xcfoIhFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t1jYM7TrPqXAFZR5HI/FMTAAELZo+bn0K/lkKO0VEkAjvbFJc1N+9IKW4ATblkE6E
         4qAi7Sj5iay2jztJTBNm+xhrZBrmzmB8sbxgJWefKVRjUbCq/MmSTtPXwHsTj7Jk+y
         pg5BzdMMREFOs23zlBlEfAtfwiwOWuiv2OwQ90sZRR9tY+5B5BGhW3c9mE7ESZZ/+T
         DV24tC/XxF3g+pKT+GhKnPs++Lavlzl/GSpfQaDNEVWVfhwiS/VUF6WSQF/ACWrfVn
         57dmQnEcyzfHRFhj7TUQg4uRmx7k1jnvuQF8HPbArpi1q7tlaPWeOZrEZCDEBn3ZHH
         Z2zW/2F0N11ww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B619AE21EE2;
        Fri, 13 Jan 2023 21:20:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] add tx packets aggregation to ethtool and
 rmnet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167364485474.21086.2352777507132025901.git-patchwork-notify@kernel.org>
Date:   Fri, 13 Jan 2023 21:20:54 +0000
References: <20230111130520.483222-1-dnlplm@gmail.com>
In-Reply-To: <20230111130520.483222-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, quic_subashab@quicinc.com,
        quic_stranche@quicinc.com, corbet@lwn.net,
        alexandr.lobakin@intel.com, gal@nvidia.com, dave.taht@gmail.com,
        bjorn@mork.no, gregkh@linuxfoundation.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 11 Jan 2023 14:05:17 +0100 you wrote:
> Hello maintainers and all,
> 
> this patchset implements tx qmap packets aggregation in rmnet and generic
> ethtool support for that.
> 
> Some low-cat Thread-x based modems are not capable of properly reaching the maximum
> allowed throughput both in tx and rx during a bidirectional test if tx packets
> aggregation is not enabled.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] ethtool: add tx aggregation parameters
    https://git.kernel.org/netdev/net-next/c/31de2842399a
  - [net-next,v4,2/3] net: qualcomm: rmnet: add tx packets aggregation
    https://git.kernel.org/netdev/net-next/c/64b5d1f8f2d1
  - [net-next,v4,3/3] net: qualcomm: rmnet: add ethtool support for configuring tx aggregation
    https://git.kernel.org/netdev/net-next/c/db8a563a9d90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


