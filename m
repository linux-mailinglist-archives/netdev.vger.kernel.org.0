Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAD6B6E4100
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjDQHbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbjDQHah (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:30:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F42234221;
        Mon, 17 Apr 2023 00:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E6F8614C0;
        Mon, 17 Apr 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D60EDC43443;
        Mon, 17 Apr 2023 07:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681716617;
        bh=TGvWb7o02pcwu5H4iKd2ARsgnThMQ4UZ+S9yCNBtzNs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LXeOkOXo9DUf2dLO1MjRI9WN48jy90WqMTFr03ZLUJzGPybUJfu6WfPfiL1sUDp0G
         2wH/l8jfQko3C4ah4vNQXeo5Xj2e6RWivNos+SYPLTxFJxbYgminufblfUBpnmfpJh
         1HgIAjvNVE3CFqDvEICTf1j1I/VJzuCym3I2lj3XZ8leOOt5i2fYtMs11t4NZOnfPF
         11T0WR0QKJToCh+oq8cAsP7DCz8dsYAXTJe/7abkABSCrQE3TxfRegvZKAptQasbda
         HhlEaVxpvy1JUj97cXhOkL5NCX5GQY0mL7G3pNq7yVsKaepEBkovoWygFTthTqkWve
         j8PEBT0d5uHfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BE273C41671;
        Mon, 17 Apr 2023 07:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] sfc: Fix use-after-free due to selftest_work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168171661777.7386.17158832087507893738.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 07:30:17 +0000
References: <20230414152306.18150-1-dinghui@sangfor.com.cn>
In-Reply-To: <20230414152306.18150-1-dinghui@sangfor.com.cn>
To:     Ding Hui <dinghui@sangfor.com.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pengdonglin@sangfor.com.cn,
        huangcun@sangfor.com.cn
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Apr 2023 23:23:06 +0800 you wrote:
> There is a use-after-free scenario that is:
> 
> When the NIC is down, user set mac address or vlan tag to VF,
> the xxx_set_vf_mac() or xxx_set_vf_vlan() will invoke efx_net_stop()
> and efx_net_open(), since netif_running() is false, the port will not
> start and keep port_enabled false, but selftest_work is scheduled
> in efx_net_open().
> 
> [...]

Here is the summary with links:
  - [net,v2] sfc: Fix use-after-free due to selftest_work
    https://git.kernel.org/netdev/net/c/a80bb8e7233b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


