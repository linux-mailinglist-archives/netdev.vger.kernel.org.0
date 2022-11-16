Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D88262CAD8
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiKPUaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiKPUaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E559AA1A8
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 12:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A146DB81EB7
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 20:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44319C433B5;
        Wed, 16 Nov 2022 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668630616;
        bh=ukiZUKXrZ/8EaI+U+SXyMFA5xXTWb1s7Xc9w1dGNe7c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cb+4sZaFnNiJnVj1i8s56Orhyt1r/rRjp2sI4cUVdE/itdGbSdXKDnfrqVnIHd4Ey
         GcOo7m8AkE+wy7JpRdTUWG5k89t+lDR3QLo3EXPeiUV2HoXfsvCNOCtf0w7GA2sFyC
         6RQZZogq3NIKtUQ2f0PP8j5ya0qkv76DWo+P5xWbLTYpnpQBikPPmu2HUCpnu6irjB
         7LZj85QWU5sbCDaMJn/NLgnSSxfEWNZEfKBqlXDO2YMmkmfc0jP1bMZxycFYfPQCnr
         TTFqQ0UwExR7uK0tgIm5RlOg9aK32NPtKP53TA+ZybxLRPuLU9JTzFo0sfoYaOjIKG
         HjXE02QSGyzSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1DC9EE270F6;
        Wed, 16 Nov 2022 20:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mlxsw: update adjfine to use adjust_by_scaled_ppm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166863061611.7356.4858131080403603742.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 20:30:16 +0000
References: <20221114213701.815132-1-jacob.e.keller@intel.com>
In-Reply-To: <20221114213701.815132-1-jacob.e.keller@intel.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, amcohen@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 14 Nov 2022 13:37:01 -0800 you wrote:
> The mlxsw adjfine implementation in the spectrum_ptp.c file converts
> scaled_ppm into ppb before updating a cyclecounter multiplier using the
> standard "base * ppb / 1billion" calculation.
> 
> This can be re-written to use adjust_by_scaled_ppm, directly using the
> scaled parts per million and reducing the amount of code required to
> express this calculation.
> 
> [...]

Here is the summary with links:
  - [net-next] mlxsw: update adjfine to use adjust_by_scaled_ppm
    https://git.kernel.org/netdev/net-next/c/d82303df0648

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


