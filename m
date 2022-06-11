Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE94547231
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiFKFUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiFKFUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C96F1F0;
        Fri, 10 Jun 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9411B83892;
        Sat, 11 Jun 2022 05:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AC5BC3411F;
        Sat, 11 Jun 2022 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654924814;
        bh=ekq1Y/T1TqC7nzW7M9+U+/ngE8vtcVc94z9y1KqxaT4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=szEFyCTNCyHQYQIjMav9YI1BHAgR5RuCDvDrF6056xyiI8w5YAD2pu1/115B/9q0i
         3Jui6bi1UVCiL9tKunbYLIptvPWTf8g//q74eP4e9jUhrGsoGiEEaXocjS4r+lxPLd
         ZgQ5Qx5B2pnjODv8374ej5A/QXClKwxzsSHfN6i38/EsyniCaI6MhZk8I2NW85UJqN
         Xyqp6KkFtF6ulrPcgW44IItKWXl7DXx63+TTF5Hxlubbq66+N8O6WA9uWvvnozVyh+
         l/vsp9pVPX0AQZNW+1gKYOJ1s5WucttYPaavPIAwOQg0t7tD6+DTSMM6gTVgpiuNl3
         uYPxyBydp6BVQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6D8DEE73803;
        Sat, 11 Jun 2022 05:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net 0/3] Documentation: add description for a couple of sctp
 sysctl options
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165492481444.17520.7811276570277303003.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Jun 2022 05:20:14 +0000
References: <cover.1654787716.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1654787716.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, marcelo.leitner@gmail.com,
        nhorman@tuxdriver.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Jun 2022 11:17:12 -0400 you wrote:
> These are a couple of sysctl options I recently added, but missed adding
> documents for them. Especially for net.sctp.intl_enable, it's hard for
> users to setup stream interleaving, as it also needs to call some socket
> options.
> 
> This patchset is to add documents for them.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net,1/3] Documentation: add description for net.sctp.reconf_enable
    https://git.kernel.org/netdev/net/c/c349ae5f831c
  - [PATCHv2,net,2/3] Documentation: add description for net.sctp.intl_enable
    https://git.kernel.org/netdev/net/c/e65775fdd389
  - [PATCHv2,net,3/3] Documentation: add description for net.sctp.ecn_enable
    https://git.kernel.org/netdev/net/c/249eddaf651f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


