Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B82528124
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbiEPKAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 06:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233968AbiEPKAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 06:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33FF26E3;
        Mon, 16 May 2022 03:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B21A4B81059;
        Mon, 16 May 2022 10:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56D1AC34100;
        Mon, 16 May 2022 10:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652695214;
        bh=DQq+yYclPxQWYoZcaQk2LLw++GQE1Lvq5DRigtRpmh8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ec0OIf9qtI2feSbFgpmGQAgtSZQHmkSuKJQFeYRVwj3R13XzWJgrtdndP1tnN1O9g
         kdJubzdtrZAd3xFcdGC4oSFVBxSZi0qM4AK0SsIV7iZoRiLdtKxc3GGUtfg967Ki77
         9CKrC+kmhB+kjubmWKAFYI8NO1AOMsiRbfHU6AOuyN9E+wY5gJR2OI/689kNMdoJFa
         pqEtDAXEKv8QH3vhIYtscLcmTZ8KcVkIzpR6u+4a6E/jfAl+vg2YpN05jpfUyx6q3V
         VpNBoo7VpUMB8rm2PFmFOxdjOcVq2EiFWNfcgcyLGA5/FD8e982Txf/i0eLNzee4bi
         3shaooRIxEJNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3548CF0392C;
        Mon, 16 May 2022 10:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 -next] net: hinic: add missing destroy_workqueue in
 hinic_pf_to_mgmt_init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165269521420.20448.15470965932259656253.git-patchwork-notify@kernel.org>
Date:   Mon, 16 May 2022 10:00:14 +0000
References: <20220513070922.3278070-1-zhengbin13@huawei.com>
In-Reply-To: <20220513070922.3278070-1-zhengbin13@huawei.com>
To:     Zheng Bin <zhengbin13@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaochao49@huawei.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 13 May 2022 15:09:22 +0800 you wrote:
> hinic_pf_to_mgmt_init misses destroy_workqueue in error path,
> this patch fixes that.
> 
> Fixes: 6dbb89014dc3 ("hinic: fix sending mailbox timeout in aeq event work")
> Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
> ---
> v1->v2: add Fixes tag
>  drivers/net/ethernet/huawei/hinic/hinic_hw_mgmt.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> [...]

Here is the summary with links:
  - [v2,-next] net: hinic: add missing destroy_workqueue in hinic_pf_to_mgmt_init
    https://git.kernel.org/netdev/net-next/c/382d917bfc1e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


