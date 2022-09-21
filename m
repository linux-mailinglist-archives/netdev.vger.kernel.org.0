Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A421E5BFEDC
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiIUNUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiIUNUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C95F923C3
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05C5362B7D
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 562E5C433C1;
        Wed, 21 Sep 2022 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663766416;
        bh=bDBQ4thEQLemg5zVvByngln+LY08d76Ua4jZWp+jpnc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ewU4gRsnLonNDuXDstcIRT2hWYD2dZKHzRt1LlS5RQy3WTJIuedhyV9p6CGa+XlL8
         LsajD9Sid79P7AN/xp1p/Pc/5iPhVfzDpPlWUIcTzEHE7EJvg9faH2cnTRoYT/SUxl
         TzPGzTCToz5rs0ekpiAvlrwtFjUzg51bkzc7k4OItNFtYXW+RquJc+vkYHZSllMO6n
         lVyORBgpZz4a00DTchdlHKuDPpgzAj4VwksseswcQIPUmEunLUBdhvRW/1CbIUY9aa
         UM9Ns2Cs4X3A0AkEqDH2MQCKetS+lBuTSjuxd8uSyQ9JlJQ2HoRXJzwrw/i5L5N8UH
         D0jv0XAVbdKWA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3135BE4D03D;
        Wed, 21 Sep 2022 13:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next 0/7] net: drivers: Switch to use dev_err_probe() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166376641619.564.3287358795822084713.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 13:20:16 +0000
References: <20220915114214.3145427-1-yangyingliang@huawei.com>
In-Reply-To: <20220915114214.3145427-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        hauke@hauke-m.de, andrew@lunn.ch, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 15 Sep 2022 19:42:07 +0800 you wrote:
> In the probe path, dev_err() can be replace with dev_err_probe()
> which will check if error code is -EPROBE_DEFER. It will print
> error code in a human readable way and simplify the code.
> 
> Yang Yingliang (7):
>   net: ethernet: ti: am65-cpts: Switch to use dev_err_probe() helper
>   net: ethernet: ti: cpsw: Switch to use dev_err_probe() helper
>   net: ethernet: ti: cpsw_new: Switch to use dev_err_probe() helper
>   net: dsa: lantiq: Switch to use dev_err_probe() helper
>   net: ibm: emac: Switch to use dev_err_probe() helper
>   net: stmmac: dwc-qos: Switch to use dev_err_probe() helper
>   net: ll_temac: Switch to use dev_err_probe() helper
> 
> [...]

Here is the summary with links:
  - [-next,1/7] net: ethernet: ti: am65-cpts: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/e2baa12608d4
  - [-next,2/7] net: ethernet: ti: cpsw: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/102947f9bb92
  - [-next,3/7] net: ethernet: ti: cpsw_new: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/2c22e42edc8d
  - [-next,4/7] net: dsa: lantiq: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/d02bb8bef457
  - [-next,5/7] net: ibm: emac: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/b6dc230fba4b
  - [-next,6/7] net: stmmac: dwc-qos: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/c222cd27dd96
  - [-next,7/7] net: ll_temac: Switch to use dev_err_probe() helper
    https://git.kernel.org/netdev/net-next/c/75ae8c284c00

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


