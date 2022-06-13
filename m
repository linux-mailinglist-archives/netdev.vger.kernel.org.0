Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21A42549717
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350838AbiFMMJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 08:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358813AbiFMMId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 08:08:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2727151E61;
        Mon, 13 Jun 2022 04:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D2C76144A;
        Mon, 13 Jun 2022 11:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE64EC3411E;
        Mon, 13 Jun 2022 11:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655118013;
        bh=JgpchjD40vF8E9DhKlEBOn+h/yMlnzYJD8uDO46SrLs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ra8w3rtLxe+HoYJd1Mru65Gxl05xCw+I9Kt6AuWFJRvTjC26EHmfEITGY4JS5mfOP
         7o8pLQ03jStR/zS4+ijkcfBH/oiWUY4bKLBBmtqSyKdWDExjrRIB/X4vCmbqTWPPj7
         QNyU0uKde/NWWhlu57u/nWGcQ+nRlyxjv/fVTwVrCx/mZKX0J6gyIy++THneOWqYo/
         0z8IDYhdOvYJ9AIYMkH9g5QLM0aP8UfTFFN01BidUAi91YCit/7v8Eqdi8IuGB9jih
         wqThCV9do9Fim8wIrSyHkMYACHSZTirvH9umC1mQwk7e4RDpBZy97lxbq2oFWCHysp
         HCNFVVVODwmsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4518E57538;
        Mon, 13 Jun 2022 11:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/6] net: hns3: add some fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165511801380.27055.5976208563800390037.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 11:00:13 +0000
References: <20220611122529.18571-1-huangguangbin2@huawei.com>
In-Reply-To: <20220611122529.18571-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
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
by David S. Miller <davem@davemloft.net>:

On Sat, 11 Jun 2022 20:25:23 +0800 you wrote:
> This series adds some fixes for the HNS3 ethernet driver.
> 
> Guangbin Huang (3):
>   net: hns3: set port base vlan tbl_sta to false before removing old
>     vlan
>   net: hns3: restore tm priority/qset to default settings when tc
>     disabled
>   net: hns3: fix tm port shapping of fibre port is incorrect after
>     driver initialization
> 
> [...]

Here is the summary with links:
  - [net,1/6] net: hns3: set port base vlan tbl_sta to false before removing old vlan
    https://git.kernel.org/netdev/net/c/9eda7d8bcbdb
  - [net,2/6] net: hns3: don't push link state to VF if unalive
    https://git.kernel.org/netdev/net/c/283847e3ef6d
  - [net,3/6] net: hns3: modify the ring param print info
    https://git.kernel.org/netdev/net/c/cfd80687a538
  - [net,4/6] net: hns3: restore tm priority/qset to default settings when tc disabled
    https://git.kernel.org/netdev/net/c/e93530ae0e5d
  - [net,5/6] net: hns3: fix PF rss size initialization bug
    https://git.kernel.org/netdev/net/c/71b215f36dca
  - [net,6/6] net: hns3: fix tm port shapping of fibre port is incorrect after driver initialization
    https://git.kernel.org/netdev/net/c/12a367088772

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


