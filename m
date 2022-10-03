Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE3BD5F304C
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiJCMaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 08:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbiJCMaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:30:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9999127B07
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 05:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5ABFB810A2
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E036C433C1;
        Mon,  3 Oct 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664800215;
        bh=ow6ubSFjikEaBML+irOtBZQtK5tWeLOpG+Y4Khi5uGM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iYd7HOY0x/flghLwKp+MZWYSWMp1PJzj2yeKiJGrUIzrIjmAutyq2G9iyJDsjK2su
         w44ahuvL15dDk9qcCBLcaqQm4QWxOYvD+OojJ6ASmxiSPyyQOavhM33hIdMZM/uLK4
         Oide8Ei9vpCwPcIhK/GnckrHrpzw974WOaK5BRpNRoqkKzopqzQiV3pf0ntvlspKqb
         uB4hS7sLcenLx4HQfj/10fHMPRDHl3+BZkUeqGbVTk8FlAQO/8xQUL6PerCcaKbIW2
         h5pEMAd05vhEITu/3v4dWGL86V8iHDlRYKFdpdilCt2UUZR//Mk+A5DpIVW3WocYwt
         eApl0ZUCSYCLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49052E49FA7;
        Mon,  3 Oct 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: wwan: iosm: Call mutex_init before locking it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166480021529.14393.10332909998214051231.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 12:30:15 +0000
References: <20221001105713.160666-1-maxtram95@gmail.com>
In-Reply-To: <20221001105713.160666-1-maxtram95@gmail.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
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

On Sat,  1 Oct 2022 13:57:13 +0300 you wrote:
> wwan_register_ops calls wwan_create_default_link, which ends up in the
> ipc_wwan_newlink callback that locks ipc_wwan->if_mutex. However, this
> mutex is not yet initialized by that point. Fix it by moving mutex_init
> above the wwan_register_ops call. This also makes the order of
> operations in ipc_wwan_init symmetric to ipc_wwan_deinit.
> 
> Fixes: 83068395bbfc ("net: iosm: create default link via WWAN core")
> Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: wwan: iosm: Call mutex_init before locking it
    https://git.kernel.org/netdev/net/c/ba0fbdb95da5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


