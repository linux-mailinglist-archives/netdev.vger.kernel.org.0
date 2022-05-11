Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780615231A7
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 13:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbiEKLaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 07:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbiEKLaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 07:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF7C229056
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 04:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1B8C61883
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 11:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AA33C340F3;
        Wed, 11 May 2022 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652268617;
        bh=NaIndOkhOJIxG4uA/pvJSTEtSLtOimmTV9zC4SRopmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ATh25b7FF1pQsmvIRfwo08E1ApHpSomGovFNWZc9sPzsXA+ow18FuMi0KNLl38TF3
         MNVjvTp9k2whI9pNrZ68H/IQ+Prkcv7s8/6dDGXw0oI2vFa4jMq6l/DCMhSRLi+zaF
         6F5ORa96nHywVcbgqw9PCqj3Q9klcR9mSPgNFMm3zKekRbQWfjd8qSEYy2EaMGAcjX
         nib/gNswIAd1yFEii2xMlgA0FZOftU7YuiFQNAt1ikKV4cINP0810iQj4AEsevET8j
         ubyRZ8ZmAId4PdcGEK9j4+GTsaM1WX+UlWNUicT3wQBBZ65gjlpsWr8jleXLNVPagb
         KkP5OLGEZ4ZOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15953E8DBDA;
        Wed, 11 May 2022 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Add exit route when waiting for FW
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165226861708.11801.13872924745488946421.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 11:30:17 +0000
References: <20220510055743.118828-2-saeedm@nvidia.com>
In-Reply-To: <20220510055743.118828-2-saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, gavinl@nvidia.com, moshe@nvidia.com
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
by Saeed Mahameed <saeedm@nvidia.com>:

On Mon,  9 May 2022 22:57:29 -0700 you wrote:
> From: Gavin Li <gavinl@nvidia.com>
> 
> Currently, removing a device needs to get the driver interface lock before
> doing any cleanup. If the driver is waiting in a loop for FW init, there
> is no way to cancel the wait, instead the device cleanup waits for the
> loop to conclude and release the lock.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Add exit route when waiting for FW
    https://git.kernel.org/netdev/net-next/c/8324a02c342a
  - [net-next,02/15] net/mlx5: Increase FW pre-init timeout for health recovery
    https://git.kernel.org/netdev/net-next/c/37ca95e62ee2
  - [net-next,03/15] net/mlx5: Lag, expose number of lag ports
    https://git.kernel.org/netdev/net-next/c/34a30d7635a8
  - [net-next,04/15] net/mlx5: devcom only supports 2 ports
    https://git.kernel.org/netdev/net-next/c/8a6e75e5f57e
  - [net-next,05/15] net/mlx5: Lag, move E-Switch prerequisite check into lag code
    https://git.kernel.org/netdev/net-next/c/4202ea95a6b6
  - [net-next,06/15] net/mlx5: Lag, use lag lock
    https://git.kernel.org/netdev/net-next/c/ec2fa47d7b98
  - [net-next,07/15] net/mlx5: Lag, filter non compatible devices
    https://git.kernel.org/netdev/net-next/c/bc4c2f2e0179
  - [net-next,08/15] net/mlx5: Lag, store number of ports inside lag object
    https://git.kernel.org/netdev/net-next/c/e9d5bb51c592
  - [net-next,09/15] net/mlx5: Lag, support single FDB only on 2 ports
    https://git.kernel.org/netdev/net-next/c/e2c45931ff12
  - [net-next,10/15] net/mlx5: Lag, use hash when in roce lag on 4 ports
    https://git.kernel.org/netdev/net-next/c/cdf611d17094
  - [net-next,11/15] net/mlx5: Lag, use actual number of lag ports
    https://git.kernel.org/netdev/net-next/c/7e978e7714d6
  - [net-next,12/15] net/mlx5: Support devices with more than 2 ports
    https://git.kernel.org/netdev/net-next/c/4cd14d44b11d
  - [net-next,13/15] net/mlx5: Lag, refactor dmesg print
    https://git.kernel.org/netdev/net-next/c/24b3599effe2
  - [net-next,14/15] net/mlx5: Lag, use buckets in hash mode
    https://git.kernel.org/netdev/net-next/c/352899f384d4
  - [net-next,15/15] net/mlx5: Lag, add debugfs to query hardware lag state
    https://git.kernel.org/netdev/net-next/c/7f46a0b7327a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


