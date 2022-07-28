Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1440C583647
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiG1BaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 21:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbiG1BaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 21:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B09113F0F
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 18:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CB8EB8227A
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3710FC433D6;
        Thu, 28 Jul 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658971813;
        bh=WB6w4RN7Vwq1qAqkJLxQjPX7AC3PbbmMJGpzfQJY9Zc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bEtx9wvmxYqyRuJbztDWwzwkBKhvCROrvYcXw1QLg1uJtwJOVcDOB4Ze5UnmYpRP0
         SbC4S0eaoDGhQxb5XEp3g+d12x7prGSNM0+xSJQyUG4i5e6NfuMI+hbsta1st2C2+s
         w8YvaZD/dQRBHsjA6l9oNisvJB5BJkU5NiWxK953U32PUk3yBqxV+GuExrdQpaT8oS
         FBxT+KvFK+s9kGX4rU6EQUjihm11OS/Mcrg9Y+/R2E2lSlW3KOKokD9GYZ+OZ3mnhG
         I011U0WR2K37FG90tSE6Iru/cLH7WxTFcE//kvY29ULTBzR6fW2wDN/3xWW9MtI37W
         4NTLZzxtbxziQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1955FC43143;
        Thu, 28 Jul 2022 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: ocp: Select CRC16 in the Kconfig.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165897181309.2015.1161352305905764264.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jul 2022 01:30:13 +0000
References: <20220726220604.1339972-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220726220604.1339972-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, kernel-team@fb.com,
        lkp@intel.com, richardcochran@gmail.com, vadfed@fb.com
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

On Tue, 26 Jul 2022 15:06:04 -0700 you wrote:
> The crc16() function is used to check the firmware validity, but
> the library was not explicitly selected.
> 
> Fixes: 3c3673bde50c ("ptp: ocp: Add firmware header checks")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] ptp: ocp: Select CRC16 in the Kconfig.
    https://git.kernel.org/netdev/net/c/0c1045562672

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


