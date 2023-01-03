Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9E165BD2B
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:30:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbjACJaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbjACJaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:30:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14DAC5FB0;
        Tue,  3 Jan 2023 01:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 99A8F61225;
        Tue,  3 Jan 2023 09:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE160C433F1;
        Tue,  3 Jan 2023 09:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672738216;
        bh=Lrad1MM4W/2a1P4k2fvv9I/bnFCeaUnPA0mFcKiYI5I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uIAKQKYRzBIIQXcLRDcaSIXohu6uhjJoiNhZTWc9mBVIC6zZz+1fdr5nMH7aWlCEK
         somFb44aaNkzT6wo1/LREtx2jI9ND7u2X9lxOZwtrq3MgDSeWuoQ9mp84OZ0fsCpwH
         EHz0Gmmy3GG7zflcH2dz/j5joUrdtPJe0fEc5QD6+swnWrJbcpP8B0dboTMfH0ca6v
         2nwiIj/iPL8CBjTyL9YtQNw199oeX9NnI8vX8442RVX9TgISmqtGCrDqL9PBly+ptC
         rtjY6I82Cp6yeVYbk3drPWDd/gGSljQMriRP03JvVSIMhhDo4x0Y5jD9HSj2p8evlC
         MuSOIuIUaa0IA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5DC5E5724B;
        Tue,  3 Jan 2023 09:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usb: rndis_host: Secure rndis_query check against int
 overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167273821587.22243.5603167276916404325.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Jan 2023 09:30:15 +0000
References: <20230103091710.81530-1-szymon.heidrich@gmail.com>
In-Reply-To: <20230103091710.81530-1-szymon.heidrich@gmail.com>
To:     Szymon Heidrich <szymon.heidrich@gmail.com>
Cc:     davem@davemloft.ne, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Tue,  3 Jan 2023 10:17:09 +0100 you wrote:
> Variables off and len typed as uint32 in rndis_query function
> are controlled by incoming RNDIS response message thus their
> value may be manipulated. Setting off to a unexpectetly large
> value will cause the sum with len and 8 to overflow and pass
> the implemented validation step. Consequently the response
> pointer will be referring to a location past the expected
> buffer boundaries allowing information leakage e.g. via
> RNDIS_OID_802_3_PERMANENT_ADDRESS OID.
> 
> [...]

Here is the summary with links:
  - usb: rndis_host: Secure rndis_query check against int overflow
    https://git.kernel.org/netdev/net/c/c7dd13805f8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


