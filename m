Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D66C5BFD6F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 14:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiIUMAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 08:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiIUMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 08:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721E779A67;
        Wed, 21 Sep 2022 05:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 15322B82660;
        Wed, 21 Sep 2022 12:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C561AC43142;
        Wed, 21 Sep 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663761616;
        bh=E02e+hoIQeYIk2g7WNSzSQ02bNWEZd2HsBba+366tss=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=twUgGB2GUtD7i4xNseqkTp9t3r8W/a0Vs3MSeNGZ3W5MbJgBqX1wC7h06P3l7kP4o
         bxDLcSAg4SiMroiq5+1gzpIrMlU5+HsuBXKGrhcaT288jOSvuh9PqwEzgphzsp8JvN
         8nihKEUETOzlrhjRCq7POVoLh7sUbq0ksqfMV5LIYE7DXTg7q11hmJ+NdG35j6V1EM
         SfcVVSIPNBkDh0suhdmulk2qqylK+9zsBJqY68pDxqRacOsg2faRlL5XJ2BDSlBSat
         pgIHJN+MMBUEm/XMiAdauy9ZEwlWW019qDLDxDRSyLumnJanLurhxk7oF1RakpUBMm
         3BnuoNVGBl1zg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AABDDE4D03C;
        Wed, 21 Sep 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] net: sched: act_ct: remove redundant variable err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166376161669.20264.12045853949285858006.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 12:00:16 +0000
References: <20220913161326.21399-1-cui.jinpeng2@zte.com.cn>
In-Reply-To: <20220913161326.21399-1-cui.jinpeng2@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cui.jinpeng2@zte.com.cn,
        zealci@zte.com.cn
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
by David S. Miller <davem@davemloft.net>:

On Tue, 13 Sep 2022 16:13:26 +0000 you wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> Return value directly from pskb_trim_rcsum() instead of
> getting value from redundant variable err.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [linux-next] net: sched: act_ct: remove redundant variable err
    https://git.kernel.org/netdev/net-next/c/2a566f0148ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


