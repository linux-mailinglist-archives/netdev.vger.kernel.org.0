Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96794C8E3D
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235404AbiCAOux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235396AbiCAOuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:50:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352E38BE25;
        Tue,  1 Mar 2022 06:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C57CB61604;
        Tue,  1 Mar 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D75FC340F3;
        Tue,  1 Mar 2022 14:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646146211;
        bh=T7EEDtDVpo/7MGcsNAe8humb29FdCCXgSHc3f6aTRi8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FyBnkroelMtrz9Lm0OdztFf/JJJPOf4KLs9gmCcyADwhUMHhQiMaObQ9oQdE6mp0g
         et4jFtCArYcUhYa+4t63NNYcRZRSaaoWCrbsvUeH/23UcP3Pd92OqzGpx5Fa1hPKIF
         e7whB/S0KbpTuC2h2/Ms1aBBUpFvnem1+H7crI1ZSEMGzyV/VJWjXfxMSekg0tdha8
         dB79YQIzdEfOcvV2eqjV+jUDuq4WAUhfAyZAeN6ELjWkZxrTIp8v6Rtdvr8zIr79S9
         5xaINpoBgoH3/tJRODhOKncve0RzKyo4CwCYFFQCxf1dNioesgZFFiSx5K7wKVcy/v
         t0WzUtz+CoUiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 00B1FEAC09D;
        Tue,  1 Mar 2022 14:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] wireless/nl80211: Handle errors for nla_memdup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164614621099.32176.8459771035422066340.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Mar 2022 14:50:10 +0000
References: <20220301100020.3801187-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20220301100020.3801187-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Johannes Berg <johannes.berg@intel.com>:

On Tue,  1 Mar 2022 18:00:20 +0800 you wrote:
> As the potential failure of the nla_memdup(),
> it should be better to check it, as same as kmemdup().
> 
> Fixes: a442b761b24b ("cfg80211: add add_nan_func / del_nan_func")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> ---
>  net/wireless/nl80211.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Here is the summary with links:
  - wireless/nl80211: Handle errors for nla_memdup
    https://git.kernel.org/netdev/net/c/6ad27f522cb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


