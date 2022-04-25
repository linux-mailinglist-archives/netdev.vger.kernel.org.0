Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B98450DD2D
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 11:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbiDYJxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 05:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239935AbiDYJx0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 05:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9053ED2C;
        Mon, 25 Apr 2022 02:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A646B811F3;
        Mon, 25 Apr 2022 09:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C9B3C385A4;
        Mon, 25 Apr 2022 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650880213;
        bh=QHVJvRA1U4eyuchr2l0VzwZ/Ky+RUlBl3UeP3kD6evM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cZ2m59UWtqCJ7uTiFr70K7K/0Mm+61Bzpbm2mWz6KyhOJR4Dut/mtpDn2tXxV5Juo
         IYLpQc3gdGmK/hHspeoo535hvs9pXeq44d7sqKu1QFeK/0H1owpFULTUrg7X1j/oW2
         EsnZCU4hY4T5Tz5dFxp6i4pP8flroVm9YjogdXuGwkyyjhorWeDmmsUZnmwWDDwnOy
         6fjZxQbBPReSXDzpEYshxcUKFg1DAgc2Y5pqP2f5VWB9oARzIyK2N8oWRaWSAb+Naw
         DoMnC8Izvt2PP43W45KlPINh52FHPCvyXAtbqfIaQfagxvg50RqVpmMgaXdgEiWu1I
         OH/7sRubx+dOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1EB49E85D90;
        Mon, 25 Apr 2022 09:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088021312.12536.3233883953657719820.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 09:50:13 +0000
References: <20220424125725.43232-1-huangguangbin2@huawei.com>
In-Reply-To: <20220424125725.43232-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Apr 2022 20:57:19 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Hao Chen (1):
>   net: hns3: align the debugfs output to the left
> 
> Jian Shen (3):
>   net: hns3: clear inited state and stop client after failed to register
>     netdev
>   net: hns3: add validity check for message data length
>   net: hns3: add return value for mailbox handling in PF
> 
> [...]

Here is the summary with links:
  - [net,1/6] net: hns3: clear inited state and stop client after failed to register netdev
    https://git.kernel.org/netdev/net/c/e98365afc1e9
  - [net,2/6] net: hns3: align the debugfs output to the left
    https://git.kernel.org/netdev/net/c/1ec1968e4e43
  - [net,3/6] net: hns3: fix error log of tx/rx tqps stats
    https://git.kernel.org/netdev/net/c/123521b6b260
  - [net,4/6] net: hns3: modify the return code of hclge_get_ring_chain_from_mbx
    https://git.kernel.org/netdev/net/c/48009e997297
  - [net,5/6] net: hns3: add validity check for message data length
    https://git.kernel.org/netdev/net/c/7d413735cb18
  - [net,6/6] net: hns3: add return value for mailbox handling in PF
    https://git.kernel.org/netdev/net/c/c59d60629684

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


