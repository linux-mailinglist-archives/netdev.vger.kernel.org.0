Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7329A653A61
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbiLVBuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiLVBuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D7818E16;
        Wed, 21 Dec 2022 17:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2819619B0;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 36BACC433D2;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671673816;
        bh=zzOFkL5fHJvVQ1JLo97VVDOdQUlWTSK9r2ih+mR06So=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DBVzJ2+hwvkOtPJqpNGqGMXBaBcv9gwZ7owhMtTLZhV7Yy9y6HMwLfeDBMNP3Vcym
         mNbzJSe2WbwkLVuhn7SO1TyWjN3y5d/zwC0ggxB/bmltJ4NkfFl9G7munfRkmgQ/S7
         UtOx1r43zxSo+OiU3l/pr/+8YOWsaszChHRSS0najSYuL2xclIanlLm86xQUmXycJU
         syUiU5VD99D1mgrO4Te1HAKwcpecqS4GJ1sMJ4j2MKwDSsaUrX0L03ILPljVwmrpdy
         Z2H+QFjGLK8WSHPKW342r6RsozmVGbWgkfwF7DjvKwalIgfF91fO9UWQaG0i1W7F44
         jXvlG4dHuof8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 18547C395DF;
        Thu, 22 Dec 2022 01:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: openvswitch: release vport resources on failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167167381609.8581.3845194833780051366.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Dec 2022 01:50:16 +0000
References: <20221220212717.526780-1-aconole@redhat.com>
In-Reply-To: <20221220212717.526780-1-aconole@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        tgraf@suug.ch, dev@openvswitch.org, echaudro@redhat.com,
        i.maximets@ovn.org, wangchuanlei@inspur.com,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 20 Dec 2022 16:27:17 -0500 you wrote:
> A recent commit introducing upcall packet accounting failed to properly
> release the vport object when the per-cpu stats struct couldn't be
> allocated.  This can cause dangling pointers to dp objects long after
> they've been released.
> 
> Cc: Eelco Chaudron <echaudro@redhat.com>
> Cc: wangchuanlei <wangchuanlei@inspur.com>
> Fixes: 1933ea365aa7 ("net: openvswitch: Add support to count upcall packets")
> Reported-by: syzbot+8f4e2dcfcb3209ac35f9@syzkaller.appspotmail.com
> Signed-off-by: Aaron Conole <aconole@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net] net: openvswitch: release vport resources on failure
    https://git.kernel.org/netdev/net/c/95637d91fefd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


