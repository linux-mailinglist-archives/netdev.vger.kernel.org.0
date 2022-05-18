Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9727B52B858
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 13:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbiERLKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbiERLKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA303326DE
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED4C9B81F37
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 962A1C385A5;
        Wed, 18 May 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652872213;
        bh=N/A6k0tnAZMWfmcRDOLOEoy3Q5m7zkCnQizl9c1BsY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kDxevs1fgYnY4bb2BpzRbw/FOF/zsW2+T+78PrwJ8cjh7YZXD4ibA/iY1bSncAzyv
         /g35M0ejuw1wCtcD5UYZ8EvLS7CwDzLNeznj4y+GoN9eMpE5Z2jNzUKFmTzsTOJiE4
         I5kBOscrWK/Jpxcdupe9B0OdP/Yx48QbEkpVKLITysqyjt7VjCFM5q0OkH4hOyNL0I
         TCzlKiFiVKJhPALidUPZZuUwf6hEKQ5cd8fxhSHRu7tDejXLpjtNynIWJ3zeEOTTMn
         701I4FWV7bmzgkXQIFLXI5STa2JGq2sWuqMMfXXTfVVzAS4P/5wo+ZF/tLvGUZLWad
         sydgt2HIxon3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7DC8AF0392C;
        Wed, 18 May 2022 11:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 01/11] net/mlx5: DR,
 Fix missing flow_source when creating multi-destination FW table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165287221351.23187.1673878219095186610.git-patchwork-notify@kernel.org>
Date:   Wed, 18 May 2022 11:10:13 +0000
References: <20220518063427.123758-2-saeed@kernel.org>
In-Reply-To: <20220518063427.123758-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, maord@nvidia.com, kliteyn@nvidia.com,
        saeedm@nvidia.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 17 May 2022 23:34:17 -0700 you wrote:
> From: Maor Dickman <maord@nvidia.com>
> 
> In order to support multiple destination FTEs with SW steering
> FW table is created with single FTE with multiple actions and
> SW steering rule forward to it. When creating this table, flow
> source isn't set according to the original FTE.
> 
> [...]

Here is the summary with links:
  - [net,01/11] net/mlx5: DR, Fix missing flow_source when creating multi-destination FW table
    https://git.kernel.org/netdev/net/c/2c5fc6cd269a
  - [net,02/11] net/mlx5: Initialize flow steering during driver probe
    https://git.kernel.org/netdev/net/c/b33886971dbc
  - [net,03/11] net/mlx5: DR, Ignore modify TTL on RX if device doesn't support it
    https://git.kernel.org/netdev/net/c/785d7ed29551
  - [net,04/11] net/mlx5e: Wrap mlx5e_trap_napi_poll into rcu_read_lock
    https://git.kernel.org/netdev/net/c/379169740b0a
  - [net,05/11] net/mlx5e: Block rx-gro-hw feature in switchdev mode
    https://git.kernel.org/netdev/net/c/15a5078cab30
  - [net,06/11] net/mlx5e: Properly block LRO when XDP is enabled
    https://git.kernel.org/netdev/net/c/cf6e34c8c22f
  - [net,07/11] net/mlx5e: Properly block HW GRO when XDP is enabled
    https://git.kernel.org/netdev/net/c/b0617e7b3500
  - [net,08/11] net/mlx5e: Remove HW-GRO from reported features
    https://git.kernel.org/netdev/net/c/6bbd723035ba
  - [net,09/11] net/mlx5e: CT: Fix support for GRE tuples
    https://git.kernel.org/netdev/net/c/8e1dcf499a67
  - [net,10/11] net/mlx5e: CT: Fix setting flow_source for smfs ct tuples
    https://git.kernel.org/netdev/net/c/04c551bad371
  - [net,11/11] net/mlx5: Drain fw_reset when removing device
    https://git.kernel.org/netdev/net/c/16d42d313350

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


