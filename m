Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3526B663854
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 05:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjAJEuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 23:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjAJEuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 23:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E1343FC92
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 20:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD5FBB8110F
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F310C433F0;
        Tue, 10 Jan 2023 04:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673326216;
        bh=J4BDly/Jwu5b22Yw2FWBnYrjhGDPoh1Ty8ZG+ET7BWw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tKcxGvjk1gg7K0P7HNCVqKB1DKNYu+LPiPhFXyW2n5wd8xUgkU+Ae40qD+XDuuHBZ
         TK0HH6x3Z99kwSfO+FofMJRryAeJMFza4WjNIVcESLYKefL9R1nRb61Ts5g0sRUwrT
         LBmQLzMjTjMRgnT39Fei7oKMsVGbV4BSjKn4cDAKu6gDQ5EmI/zyAxacen3pBKEgcx
         WgJG/JYtaiUN0tuyqhrZSR90J1g9GSq68Fmk1XOEHYYwtS65MfqmQTF5J2IDIOf2f0
         cYixwD49JLECRNpclc/nN20efT4RnKqwwbqbiK6LlFOiixM5t+iIAjgydordSw6W96
         VSa3DFnubDeUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2596FE524ED;
        Tue, 10 Jan 2023 04:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "r8169: disable detection of chip version 36"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167332621614.19916.13262258406705014864.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Jan 2023 04:50:16 +0000
References: <42e9674c-d5d0-a65a-f578-e5c74f244739@gmail.com>
In-Reply-To: <42e9674c-d5d0-a65a-f578-e5c74f244739@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 8 Jan 2023 20:37:53 +0100 you wrote:
> This reverts commit 42666b2c452ce87894786aae05e3fad3cfc6cb59.
> 
> This chip version seems to be very rare, but it exits in consumer
> devices, see linked report.
> 
> https://stackoverflow.com/questions/75049473/cant-setup-a-wired-network-in-archlinux-fresh-install
> 
> [...]

Here is the summary with links:
  - [net] Revert "r8169: disable detection of chip version 36"
    https://git.kernel.org/netdev/net/c/2ea26b4de6f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


