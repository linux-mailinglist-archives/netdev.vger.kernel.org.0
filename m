Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A88D5A5FD0
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiH3Ju2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiH3JuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EBB167168
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:50:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79643B8171A
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E069C433D6;
        Tue, 30 Aug 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661853016;
        bh=PpEkMpzfT0/Tcz3mHamQbG4C780aeuA1XIKMzhONsE4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jjfaWUvG8OX6RacD5l5dD+W28bUfJaqtpLxo8jAmPfcDGqi+RS2WnOMVzdhYRdbcJ
         Zc/rGl5aiMynfyF2Fs6b9k+M2mdw5XiM7lTRKvwglzPEbmIorpwkvEpUX5I5tGH/qz
         nwEbSNbiNOmQPSb2O3vH3A7Ee3jlg51HiFCVPpeH1LUcmoo7ZV8aFHIllNd/5UJDjN
         2+Cpo3M1mHRadG+442aaU7HbtyMiSPSLNX7o79yXbSKGGkRTU5IZKNu943WbbfPG3c
         xD/dSRFIZ/e2fa4EfKJHwocAkF74C9PKxVFoaEu+2IV91La119N/OwAXiUEKXwhaF7
         oNi4vtsGWCwMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F33A8E924D4;
        Tue, 30 Aug 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] nfp: port speed and eeprom get/set updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166185301599.17214.16391499867275783784.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Aug 2022 09:50:15 +0000
References: <20220825141223.22346-1-simon.horman@corigine.com>
In-Reply-To: <20220825141223.22346-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 25 Aug 2022 16:12:20 +0200 you wrote:
> Hi,
> 
> this short series is the initial updates for the NFP driver for the v6.1
> Kernel. It covers two enhancements:
> 
> 1. Patches 1/3 and 2/3:
>    - Support cases where application firmware does not know port speeds
>      a priori by relaying this information from the management firmware
>      to the application firmware.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] nfp: propagate port speed from management firmware
    https://git.kernel.org/netdev/net-next/c/62fad9e6104c
  - [net-next,2/3] nfp: check if application firmware is indifferent to port speed
    https://git.kernel.org/netdev/net-next/c/2b88354d37ca
  - [net-next,3/3] nfp: add support for eeprom get and set command
    https://git.kernel.org/netdev/net-next/c/e6686745e327

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


