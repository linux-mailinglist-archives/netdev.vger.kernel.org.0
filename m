Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769C16AFCEC
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 03:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjCHCa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 21:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCHCaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 21:30:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773AE96F3E
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 18:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F160B81B95
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 02:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8F8F7C433EF;
        Wed,  8 Mar 2023 02:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678242621;
        bh=DudkiCrQiOhz2qeZEhjNlJ99KEDGD+bjl0kDI11ZgiU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iMuTi8Q5QjYd0svhPTX5ui3sptDuXC1PtvkByg6DtqNihS28jcTUfyf1Q9jWPT2Yh
         IgJ1ickIXMRaweQ1nV/jkXbEHVPz0Lap5yhA8+N43HvjaIZhr0J1dSIM171z7za9bT
         UBuZkHFi4oB4Snf/7UgSF9UWb3CvZvJfBUIev+eKuVH1wz3+cegtF+3FscgZNVn5EK
         l+LOXK0/wJrRu+sSNoMXCaU9PJ901aeo/+qD7CTuhl5aGoCjsi6gpFQpftxiyDqiCo
         ukz23M0lXs+8YJfnHEmwC9BbPJvAOZl7Sjlwqc6exg2aJIrsbQhlVEjvrgDyTvdoX8
         uydn5guXRB9jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FBF6E61B63;
        Wed,  8 Mar 2023 02:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: improve phy_read_poll_timeout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167824262145.14328.4294439007487690246.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 02:30:21 +0000
References: <6d8274ac-4344-23b4-d9a3-cad4c39517d4@gmail.com>
In-Reply-To: <6d8274ac-4344-23b4-d9a3-cad4c39517d4@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 6 Mar 2023 22:51:35 +0100 you wrote:
> cond sometimes is (val & MASK) what may result in a false positive
> if val is a negative errno. We shouldn't evaluate cond if val < 0.
> This has no functional impact here, but it's not nice.
> Therefore switch order of the checks.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: improve phy_read_poll_timeout
    https://git.kernel.org/netdev/net-next/c/0194b64578e9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


