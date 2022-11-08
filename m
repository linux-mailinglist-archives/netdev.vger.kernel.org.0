Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55FD66206CA
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233314AbiKHCaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232693AbiKHCaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:30:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E5613D15;
        Mon,  7 Nov 2022 18:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69BB1B81897;
        Tue,  8 Nov 2022 02:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DA0EC4347C;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667874616;
        bh=9KfydVgSjM3cZjncm7PF0+qJF0xg7cNKU6hP+GeZcIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NQq+XL6T6qt9/x0yq+/643/AwMkuc4AH+Cpf6t67R1rv0s+ySYTBwckDnv8YtFe3i
         fOnJC6f7HVSJT1SH81Bgtg7FfO7VVhkGecXNpylClZDGpos0w5FGC63/0czE/tmNe6
         e96c1zlkhxSQOPapr4QNP/C1Rb7W26ST33v9ZFN5ZWRtFWcIfRi2mmsb2LREMTy+rk
         iBoRoLFVV6XoQcJXgUT1MJT37wBuY5Qcat+qHRoQZLpCIB/kKK0RPohOZbsbvJg+Yp
         B9neMD/jZ9AwJkNSbGEaXwMWAYHTPCgeIrAbHPqqYzBP9/ou2MRk1El5r084Jr5EVH
         KmQh4b3DL7ieg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09AA5C4166D;
        Tue,  8 Nov 2022 02:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] netlink: Fix potential skb memleak in netlink_ack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787461603.16737.13661067186331397164.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:30:16 +0000
References: <bff442d62c87de6299817fe1897cc5a5694ba9cc.1667638204.git.chentao.kernel@linux.alibaba.com>
In-Reply-To: <bff442d62c87de6299817fe1897cc5a5694ba9cc.1667638204.git.chentao.kernel@linux.alibaba.com>
To:     Tao Chen <chentao.kernel@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, johannes@sipsolutions.net,
        socketcan@hartkopp.net, petrm@nvidia.com, keescook@chromium.org,
        harshit.m.mogalapalli@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  5 Nov 2022 17:05:04 +0800 you wrote:
> Fix coverity issue 'Resource leak'.
> 
> We should clean the skb resource if nlmsg_put/append failed.
> 
> Fixes: 738136a0e375 ("netlink: split up copies in the ack construction")
> Signed-off-by: Tao Chen <chentao.kernel@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] netlink: Fix potential skb memleak in netlink_ack
    https://git.kernel.org/netdev/net-next/c/e69761483361

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


