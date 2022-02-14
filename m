Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82C24B5315
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344951AbiBNOUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:20:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbiBNOUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8211749FB8
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 06:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DCDD61038
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 824D9C340F1;
        Mon, 14 Feb 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644848410;
        bh=RJ8aFWt8KbWomSmeyV7rHwUkqakC0AxW9u4ytYDb0Q8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j5F4rUrrbBMN6Ultse7DxBOSEHcfDBknqH27WGml0CUCfMdlv+SSfshbdQbaKuyyW
         LT+T2lnc9aukGtRl+MLZsXelJmmP8WNtxlfVlPvYB9iHMrYEMhkI8GaZq3DUM3UzNZ
         4W43SH9werPinT9HpU6B33iqv3A2YFbUlbCwZ56AEGb6pw0eI3oIvrEQbjjAFJvZ7f
         qftSTYvonbWvNuZ190Q33AoXYXOkVVCrkMn6zvUNgOw7kOYaluETBLXnU1FQZKUgFV
         ILh9IhDixD/NS9vRJvcVm1KeBJXaqk1mi3/mtDXioBmPigqs/9fWCFvB9TCs/PBBoy
         P68mCF16/WUnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CDCBE5D09D;
        Mon, 14 Feb 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: wwan: debugfs dev reference not dropped
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484841044.14634.18025566028520952249.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:20:10 +0000
References: <20220214071653.813010-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20220214071653.813010-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Feb 2022 12:46:51 +0530 you wrote:
> This patch series contains WWAN subsystem & IOSM Driver changes to
> drop dev reference obtained as part of wwan debugfs dir entry retrieval.
> 
> PATCH1: A new debugfs interface is introduced in wwan subsystem so
> that wwan driver can drop the obtained dev reference post debugfs use.
> 
> PATCH2: IOSM Driver uses new debugfs interface to drop dev reference.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: wwan: debugfs obtained dev reference not dropped
    https://git.kernel.org/netdev/net-next/c/76f05d88623e
  - [net-next,2/2] net: wwan: iosm: drop debugfs dev reference
    https://git.kernel.org/netdev/net-next/c/163f69ae22e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


