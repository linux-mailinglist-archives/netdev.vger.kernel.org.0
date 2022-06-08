Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB08E5425C1
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:55:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiFHGAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:00:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244921AbiFHFzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:55:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C277C253331
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64D65B823D1
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 04:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 006F1C3411F;
        Wed,  8 Jun 2022 04:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654660813;
        bh=J78qmcL3/83GPOhPPS0UeoDCI6UIp7tCQfg/62aGFNQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l8HC+pAwifzMh5nJC7xleDDXOokjWTQFlTPdxjQ4qj6S6vNLMy5Mn63Sj13M02v8L
         7I7LE8feL7eohuiqnM9VI7DIp+5Vl9MM6anyhGxAF5Zwg6oXSYp4PSszhnVT3yPAzM
         JJ5z2KWXOH21sby3/zXeMVamCSUafmS5W/D84nyjnvgs8voRTHHQK7uUxh7jLcJ4No
         jMFo7StNG1FqBgtYpflX82oD6rf7MP4eky92Zx6ED64Mwr3//wXsQHQiY2XyqlrZZ0
         x3Vu0FUupzZ+uya9MNzlfdEBW1/FD6dZPL958tgOLe8aSN7TvqoFdZjy8+u/UFrt2S
         mZ39eviTn89tg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7848E737EF;
        Wed,  8 Jun 2022 04:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/mlx4_en: Fix wrong return value on ioctl EEPROM query
 failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165466081287.15005.15481065449511570566.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 04:00:12 +0000
References: <20220606115718.14233-1-tariqt@nvidia.com>
In-Reply-To: <20220606115718.14233-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org, gal@nvidia.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 6 Jun 2022 14:57:18 +0300 you wrote:
> From: Gal Pressman <gal@nvidia.com>
> 
> The ioctl EEPROM query wrongly returns success on read failures, fix
> that by returning the appropriate error code.
> 
> Fixes: 7202da8b7f71 ("ethtool, net/mlx4_en: Cable info, get_module_info/eeprom ethtool support")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure
    https://git.kernel.org/netdev/net/c/f5826c8c9d57

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


