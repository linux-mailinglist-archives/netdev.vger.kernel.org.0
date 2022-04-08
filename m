Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2910B4F9624
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 14:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbiDHMwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 08:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbiDHMwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 08:52:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5972EF47D6
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 05:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 883F66215D
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6F28C385A3;
        Fri,  8 Apr 2022 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649422217;
        bh=4QGZsnXo6q8MBAsvTUJpmfrtoQw7CAJhuE9dyyCAP2Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H3GvLmQeVwU2vRPrbE+wRAV2oNqX1v/L8qN9lEbE+arkNXpqZBxuLIv2DIIhpaJjn
         jpFkKh34dFFV0vRdRnQTlmgxriN/oxFgMxkhmIfHW9ethJ5qoRzY0iqSXav2u/QxOt
         SBYGKKkfc6BGVFhmNoJ/9T07uCgkHTvPwsrQs4zf2trFAVjQreoG3EzcvqiZBLG7XW
         T6ICXcwpjOsSikmHiOsa0hcVPgWZbowJePqfV18ihDjt5FoLui1xgNFyoUH3MnBZ4k
         DjLKQCLL33h4MMOa4mnSzquCrdYQYl5j2kmN5GMaVXG4Te+4vmHLE8lB24X5qqynlp
         70fw2bwfGMU1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CAECDE6D402;
        Fri,  8 Apr 2022 12:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14] net/sched: Better error reporting for offload
 failures
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164942221682.10804.2065514338670048792.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 12:50:16 +0000
References: <20220407073533.2422896-1-idosch@nvidia.com>
In-Reply-To: <20220407073533.2422896-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, petrm@nvidia.com, jianbol@nvidia.com,
        roid@nvidia.com, vladbu@nvidia.com, olteanv@gmail.com,
        simon.horman@corigine.com, baowen.zheng@corigine.com,
        marcelo.leitner@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Apr 2022 10:35:19 +0300 you wrote:
> This patchset improves error reporting to user space when offload fails
> during the flow action setup phase. That is, when failures occur in the
> actions themselves, even before calling device drivers. Requested /
> reported in [1].
> 
> This is done by passing extack to the offload_act_setup() callback and
> making use of it in the various actions.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] net/sched: matchall: Take verbose flag into account when logging error messages
    https://git.kernel.org/netdev/net-next/c/4c096ea2d67c
  - [net-next,02/14] net/sched: flower: Take verbose flag into account when logging error messages
    https://git.kernel.org/netdev/net-next/c/11c95317bc1a
  - [net-next,03/14] net/sched: act_api: Add extack to offload_act_setup() callback
    https://git.kernel.org/netdev/net-next/c/c2ccf84ecb71
  - [net-next,04/14] net/sched: act_gact: Add extack messages for offload failure
    https://git.kernel.org/netdev/net-next/c/69642c2ab2f5
  - [net-next,05/14] net/sched: act_mirred: Add extack message for offload failure
    https://git.kernel.org/netdev/net-next/c/4dcaa50d0292
  - [net-next,06/14] net/sched: act_mpls: Add extack messages for offload failure
    https://git.kernel.org/netdev/net-next/c/bca3821d19d9
  - [net-next,07/14] net/sched: act_pedit: Add extack message for offload failure
    https://git.kernel.org/netdev/net-next/c/bf3b99e4f9ce
  - [net-next,08/14] net/sched: act_police: Add extack messages for offload failure
    https://git.kernel.org/netdev/net-next/c/b50e462bc22d
  - [net-next,09/14] net/sched: act_skbedit: Add extack messages for offload failure
    https://git.kernel.org/netdev/net-next/c/a9c64939b669
  - [net-next,10/14] net/sched: act_tunnel_key: Add extack message for offload failure
    https://git.kernel.org/netdev/net-next/c/ee367d44b936
  - [net-next,11/14] net/sched: act_vlan: Add extack message for offload failure
    https://git.kernel.org/netdev/net-next/c/f8fab3169464
  - [net-next,12/14] net/sched: cls_api: Add extack message for unsupported action offload
    https://git.kernel.org/netdev/net-next/c/c440615ffbcb
  - [net-next,13/14] net/sched: matchall: Avoid overwriting error messages
    https://git.kernel.org/netdev/net-next/c/0cba5c34b8f4
  - [net-next,14/14] net/sched: flower: Avoid overwriting error messages
    https://git.kernel.org/netdev/net-next/c/fd23e0e250c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


