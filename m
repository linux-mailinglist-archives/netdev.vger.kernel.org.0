Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5908364532E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbiLGEuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLGEuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F071B78F;
        Tue,  6 Dec 2022 20:50:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C513361A1B;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F138C43148;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670388617;
        bh=tw43Of0wcHK6MxbRZMdXCJpNagRSSOU276B/f1NfVGE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ToOPW2RKNE1t8RApk/4fZuXj9azJI6TQoVjs7XXmkLyF1pgA/Bc8UasHpMgqImfkf
         78FHpKgcHMN0LIkiNTiuaOIFYNSHKnOWshMoAzuHJ6PLzix0sGsbtFTFjox33Z4b4e
         RfBIGbsUlskbQPpniko8oRuJScmfvrHyglvODlBFJux4wMjJcHpAP8sjldDndUFv8k
         dhEP2Pzh3vxZANSIB63QhyXnyCxRt5C+a37cx4UUGZQV7JTgQ2Zq5BymeAkm2dXtz9
         A8QN7tdTroHb8NnqTa01bl2rdyyiEmeAt2KGF+9epXkKRGFU/6U60o2P/AexN0IYSt
         Awr2prPhag0NQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 025D9C5C7C6;
        Wed,  7 Dec 2022 04:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: =?utf-8?q?=5BPATCH_net-next_v2=5D_net=3A_microchip=3A_vcap=3A_Remov?=
        =?utf-8?q?e_unneeded_semicolons?=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038861700.25696.16360007989331129867.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:50:17 +0000
References: <202212051422158113766@zte.com.cn>
In-Reply-To: <202212051422158113766@zte.com.cn>
To:     <zhang.songyi@zte.com.cn>
Cc:     kuba@kernel.org, lars.povlsen@microchip.com,
        steen.hegelund@microchip.com, daniel.machon@microchip.com,
        unglinuxdriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Mon, 5 Dec 2022 14:22:15 +0800 (CST) you wrote:
> From: zhang songyi <zhang.songyi@zte.com.cn>
> 
> Semicolons after "}" are not needed.
> 
> Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
> ---
>  drivers/net/ethernet/microchip/vcap/vcap_api.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next,v2] net: microchip: vcap: Remove unneeded semicolons
    https://git.kernel.org/netdev/net-next/c/e3bd74c3d190

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


