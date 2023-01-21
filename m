Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A21F67633B
	for <lists+netdev@lfdr.de>; Sat, 21 Jan 2023 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjAUDA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 22:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjAUDAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 22:00:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7D485362
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 19:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B232B82B88
        for <netdev@vger.kernel.org>; Sat, 21 Jan 2023 03:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE430C4339B;
        Sat, 21 Jan 2023 03:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674270018;
        bh=hYgdYGGZojG9s9bNf9YvSIvBtAESkL09kAhlvrIWFbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mtgWmxFX3aEVKaumEXFWYlyP6rUDq27CAkRBeO1DkeWpoQ4Dq5QFNltI8DjPejuFK
         Vnrz3ObrzMnQbvI3SFT7Qs7qEeLkYlqIQJQ347w6nyK/PnSUt++711dh64bS3xb/rt
         0lXxr3To5kCOWRXrgze42i+qIqImVpirei5d3vptiikU6S6C37C2/YOvv/aJ5//dTe
         6NcCqtbUQ8pc2V831XvRsNuglg82yS3DiT6oK4ObV8Yqv9T7mlOw1GJkUEg9W8dtjD
         Gk8nCzXbcmZM6bECvrDkaS15k0e0rHvo/rrVyVLivIWa05d5ccBQu17NiW9Y83Cn1F
         Lx+RIKvKh2kOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB215C04E34;
        Sat, 21 Jan 2023 03:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] mlxsw: Add support of latency TLV
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167427001876.13800.17696238078805509162.git-patchwork-notify@kernel.org>
Date:   Sat, 21 Jan 2023 03:00:18 +0000
References: <cover.1674123673.git.petrm@nvidia.com>
In-Reply-To: <cover.1674123673.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com
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

On Thu, 19 Jan 2023 11:32:26 +0100 you wrote:
> Amit Cohen writes:
> 
> Ethernet Management Datagrams (EMADs) are Ethernet packets sent between
> the driver and device's firmware. They are used to pass various
> configurations to the device, but also to get events (e.g., port up)
> from it. After the Ethernet header, these packets are built in a TLV
> format.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] mlxsw: reg: Add TLV related fields to MGIR register
    https://git.kernel.org/netdev/net-next/c/42b4f757ba9c
  - [net-next,2/6] mlxsw: Enable string TLV usage according to MGIR output
    https://git.kernel.org/netdev/net-next/c/d84e2359e621
  - [net-next,3/6] mlxsw: core: Do not worry about changing 'enable_string_tlv' while sending EMADs
    https://git.kernel.org/netdev/net-next/c/563bd3c490dc
  - [net-next,4/6] mlxsw: emad: Add support for latency TLV
    https://git.kernel.org/netdev/net-next/c/695f7306d942
  - [net-next,5/6] mlxsw: core: Define latency TLV fields
    https://git.kernel.org/netdev/net-next/c/6ee0d3a9dc00
  - [net-next,6/6] mlxsw: Add support of latency TLV
    https://git.kernel.org/netdev/net-next/c/49f5b769d5bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


