Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47BEB61EF45
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 10:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbiKGJke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 04:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231587AbiKGJkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 04:40:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB01BCBF;
        Mon,  7 Nov 2022 01:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 491EACE118B;
        Mon,  7 Nov 2022 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69C6BC433B5;
        Mon,  7 Nov 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667814015;
        bh=eGeEgr0/KwhblYgi5vtUy4mDQ1/GCwRgKOb0nMCdRFI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DoFnS8+GAdtVtqK4E447+mL47anTSPVWtZ0KR/3cNJ1VaCRHC/SbbpzrSkGzapTBg
         A4c4lbLm7W8OkXtiN8SN8olJC3OIaClwFRNjWJR25D92FR8SoZ1keuPOjl+1x5LB26
         nWBchFAsOUqqVp/lz4pnwa7YyrjdmdjQwiYF7Rf8wmF3HGN3ebHgW0o+cIyGik8rWF
         RVddaEGYqm04/PvHWbrbpCl14ZyCUZiB4eHPT44+a/XATL/d8ouyed0r8IlGGDqb21
         r2kBmrpIE6n3+63nVm7q6EqyD4U0AbH1CImgGKIkbsUCa5Eaye8Mkbi+wxrSrbm+32
         J6xoPtEGwIJkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4FF2DE270CE;
        Mon,  7 Nov 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lapbether: fix issue of dev reference count leakage
 in lapbeth_device_event()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166781401532.17779.17066719090536498926.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Nov 2022 09:40:15 +0000
References: <20221103090537.282969-1-shaozhengchao@huawei.com>
In-Reply-To: <20221103090537.282969-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org, ms@dev.tdt.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
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

On Thu, 3 Nov 2022 17:05:37 +0800 you wrote:
> When following tests are performed, it will cause dev reference counting
> leakage.
> a)ip link add bond2 type bond mode balance-rr
> b)ip link set bond2 up
> c)ifenslave -f bond2 rose1
> d)ip link del bond2
> 
> [...]

Here is the summary with links:
  - [net] net: lapbether: fix issue of dev reference count leakage in lapbeth_device_event()
    https://git.kernel.org/netdev/net/c/531705a76549

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


