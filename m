Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918F062ED9E
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbiKRGad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241115AbiKRGa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:30:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A1197A99
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 22:30:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06870B80950
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 06:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA70EC433D7;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668753024;
        bh=T7kkdE5sR9l/oc3RSXNZaYnQ45wYCKJeReqNQut92/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z/vsX6AzlLEhd4Xy3mR2Zo5tHXewvHZahvYxfYOGzQ5BHw489kkf7p6SvVZPcEgLQ
         WwxATXlgG/Qseou0/GBFC7jfG8ciS8UeE0BPGnZHT8DvuPvCSZ09Jmq2tj8nvaMeZD
         CN46qBQVVRR1VPI0nKL6Cxum6oVS2rH9uIKGkC+j+AkaVQZv1gE9kPBZzZe2af7dgf
         NZ5FLsboQCowuxJDX4OPvvngWlfJbIHJm6NwZc8Dgb+34tJN6hZUVPBokttHdSput2
         mwjVu3pO5OxA6a0CcyYWYF14opa6HaDRnLZDSIfDeDKkkump0zxN4dw/BY6/km3aF6
         Sw1n0MN8km6ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 863BFE270D5;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v12 00/11] Implement devlink-rate API and extend it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166875302454.3603.8887758446964941746.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 06:30:24 +0000
References: <20221115104825.172668-1-michal.wilczynski@intel.com>
In-Reply-To: <20221115104825.172668-1-michal.wilczynski@intel.com>
To:     Michal Wilczynski <michal.wilczynski@intel.com>
Cc:     netdev@vger.kernel.org, alexandr.lobakin@intel.com,
        jacob.e.keller@intel.com, jesse.brandeburg@intel.com,
        przemyslaw.kitszel@intel.com, anthony.l.nguyen@intel.com,
        kuba@kernel.org, ecree.xilinx@gmail.com, jiri@resnulli.us
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 15 Nov 2022 11:48:14 +0100 you wrote:
> This patch series implements devlink-rate for ice driver. Unfortunately
> current API isn't flexible enough for our use case, so there is a need to
> extend it. Some functions have been introduced to enable the driver to
> export current Tx scheduling configuration.
> 
> Pasting justification for this series from commit implementing devlink-rate
> in ice driver(that is a part of this series):
> 
> [...]

Here is the summary with links:
  - [net-next,v12,01/11] devlink: Introduce new attribute 'tx_priority' to devlink-rate
    https://git.kernel.org/netdev/net-next/c/cd502236835b
  - [net-next,v12,02/11] devlink: Introduce new attribute 'tx_weight' to devlink-rate
    https://git.kernel.org/netdev/net-next/c/6e2d7e84fcfe
  - [net-next,v12,03/11] devlink: Enable creation of the devlink-rate nodes from the driver
    https://git.kernel.org/netdev/net-next/c/caba177d7f4d
  - [net-next,v12,04/11] devlink: Allow for devlink-rate nodes parent reassignment
    https://git.kernel.org/netdev/net-next/c/04d674f04e32
  - [net-next,v12,05/11] devlink: Allow to set up parent in devl_rate_leaf_create()
    https://git.kernel.org/netdev/net-next/c/f2fc15e271f2
  - [net-next,v12,06/11] ice: Introduce new parameters in ice_sched_node
    https://git.kernel.org/netdev/net-next/c/16dfa49406bc
  - [net-next,v12,07/11] ice: Add an option to pre-allocate memory for ice_sched_node
    https://git.kernel.org/netdev/net-next/c/bdf96d965a20
  - [net-next,v12,08/11] ice: Implement devlink-rate API
    https://git.kernel.org/netdev/net-next/c/42c2eb6b1f43
  - [net-next,v12,09/11] ice: Prevent ADQ, DCB coexistence with Custom Tx scheduler
    https://git.kernel.org/netdev/net-next/c/80fe30a8c1f4
  - [net-next,v12,10/11] ice: Add documentation for devlink-rate implementation
    (no matching commit)
  - [net-next,v12,11/11] Documentation: Add documentation for new devlink-rate attributes
    https://git.kernel.org/netdev/net-next/c/242dd64375b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


