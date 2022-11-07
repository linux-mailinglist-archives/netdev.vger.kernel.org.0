Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 741D761EF42
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbiKGJkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiKGJkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:40:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6336FB87D
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 01:40:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF02B60F9F
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5AFA3C433C1;
        Mon,  7 Nov 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667814015;
        bh=349HTjxGmClRj8yY9OL2jMygcPG5PjNUPi8SFj/PpnM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FPHoMhJ9SR6BGCwRK14ljA276yoIirUu4EDJ9Fdoc8nVKDxx0c73/zotS1cuC6URa
         luujGucEaVSRuEySIrRhw4x19lBsk8bpYUV0cwzTepWW42AD+kFaF3wqH241BhW+CI
         QIpp39PvmzT+4KaZ61hp3rMrpX+RHi3oHgT87d/8gytnzWZRxqiGmsVOoXBBnzqhmO
         RD7XAAh/rHqqC2kPqB8MsXrgs+kjKjPXt9nE7O8prV46WH/YSCzIKpI+rWBFcUuxt/
         +fswjSoqq5MxK3dIXFRRwsTJiP3KgBX1uNad8nSKlEFVbs5mc7SLJAKxNrmEc24IBD
         y2Iu8bqI7QETw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48673C4166D;
        Mon,  7 Nov 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] hamradio: fix issue of dev reference count leakage in
 bpq_device_event()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166781401529.17779.3116207604389752207.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 09:40:15 +0000
References: <20221103090905.284567-1-shaozhengchao@huawei.com>
In-Reply-To: <20221103090905.284567-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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

On Thu, 3 Nov 2022 17:09:05 +0800 you wrote:
> When following tests are performed, it will cause dev reference counting
> leakage.
> a)ip link add bond2 type bond mode balance-rr
> b)ip link set bond2 up
> c)ifenslave -f bond2 rose1
> d)ip link del bond2
> 
> [...]

Here is the summary with links:
  - [net] hamradio: fix issue of dev reference count leakage in bpq_device_event()
    https://git.kernel.org/netdev/net/c/85cbaf032d3c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


