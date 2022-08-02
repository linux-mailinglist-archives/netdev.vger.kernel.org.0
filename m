Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8F75875E7
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 05:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbiHBDUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 23:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbiHBDUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 23:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F85262B;
        Mon,  1 Aug 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C33DB81993;
        Tue,  2 Aug 2022 03:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B97DDC433D7;
        Tue,  2 Aug 2022 03:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659410413;
        bh=vrJp6GcO+jYYAeP3AVrkWQ42YZmgEXnXE8fn6z/p80E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q9cxOISR/B37jnc7pY1xBUUhvozMXSOFNY9+CkCep6oURH/Y0G6mHfQb7LBXCLqza
         83OeFe0d/I+mVCfqFZvU8Zes0mx16KIomPNGEYyl5thBkDkKcPrU4sCEP0ANLYrRyJ
         MZLpfYZ5PzYooYpa+NaHjh1QAX3aRF0i2Kp+SSD7wymwc7WreSOJt9cjHnb5DHSueO
         cD650Iwea856ky/oLN34HzmqmqAaLVbYLhbpIwGU+9NJAKeiRGgHs7DqOSBAIs7FNV
         PlSbxzPAAExvDC58j3pUijl8mKt31mKBQoD8CPMlpUSB2/SbkkW8cXU1A+SDRPjT0K
         qCx3koqFZVPqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 994F5C43140;
        Tue,  2 Aug 2022 03:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH v2] octeontx2-pf: Reduce minimum mtu size to 60
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165941041362.29891.15985898898628153206.git-patchwork-notify@kernel.org>
Date:   Tue, 02 Aug 2022 03:20:13 +0000
References: <20220729092457.3850-1-naveenm@marvell.com>
In-Reply-To: <20220729092457.3850-1-naveenm@marvell.com>
To:     Naveen Mamindlapalli <naveenm@marvell.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sgoutham@marvell.com, sbhatta@marvell.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 29 Jul 2022 14:54:57 +0530 you wrote:
> From: Subbaraya Sundeep <sbhatta@marvell.com>
> 
> PTP messages like SYNC, FOLLOW_UP, DELAY_REQ are of size 58 bytes.
> Using a minimum packet length as 64 makes NIX to pad 6 bytes of
> zeroes while transmission. This is causing latest ptp4l application to
> emit errors since length in PTP header and received packet are not same.
> Padding upto 3 bytes is fine but more than that makes ptp4l to assume
> the pad bytes as a TLV. Hence reduce the size to 60 from 64.
> 
> [...]

Here is the summary with links:
  - [net,v2] octeontx2-pf: Reduce minimum mtu size to 60
    https://git.kernel.org/netdev/net/c/53e99496abc1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


