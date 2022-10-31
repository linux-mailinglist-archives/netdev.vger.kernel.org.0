Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC307613280
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiJaJUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiJaJU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:20:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF34DDECA
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 02:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 551EB61042
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9F828C433B5;
        Mon, 31 Oct 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208016;
        bh=h342awF95YXI/klDliGmBEYIxzQZ45H1awT5wahx3Fs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=icQ+7/bbAsgeOwGMk1TMuhL0Yzuf+D+26RkFwN8FoWYRaVAcjYwLyPrb9jTTeVCLL
         zusDdieBhh2qLWBvWbBUT2SUGqNytx+PLQiqHfNQhynjU0q5QNgJcNkkzRhwWnfE5g
         Vzrp04yHCE1G39laSWabKaV/MGMX1iOrTk2I4OcASPuUw8BTH3d08lg4HoeQZI18OK
         9Q0o/TF1YagtTDiwlMMGpPT7lPTp+2sWsCDtlh+ack8sDl5A5ljb/42d4SUk3bOS/G
         OpaOtEG+FPBXozhZLxylsm4qR2UE4WUKJZSv0F1gOVGukBo5LJszD5PgMYTi3hQdY3
         l5eeF8D2PG+ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81273E270D6;
        Mon, 31 Oct 2022 09:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: hns: hnae: remove unnecessary __module_get()
 and module_put()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166720801652.13996.16734909615547912922.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 09:20:16 +0000
References: <20221028073457.3492371-1-yangyingliang@huawei.com>
In-Reply-To: <20221028073457.3492371-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, leon@kernel.org,
        kuba@kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 28 Oct 2022 15:34:57 +0800 you wrote:
> hnae_ae_register() is called from hns_dsaf_probe(), the refcount of
> module hnae has already be got in resolve_symbol() while calling the
> function, so the __module_get()/module_put() can be removed.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns/hnae.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net-next] net: hns: hnae: remove unnecessary __module_get() and module_put()
    https://git.kernel.org/netdev/net-next/c/47aeed9d2ccd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


