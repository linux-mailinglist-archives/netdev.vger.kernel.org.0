Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 366676E5038
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbjDQSav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjDQSat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:30:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1785FE9;
        Mon, 17 Apr 2023 11:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CBA16294C;
        Mon, 17 Apr 2023 18:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A7FFC433EF;
        Mon, 17 Apr 2023 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681756219;
        bh=1izxcHkNYly87+CfZcjdcaLLjr0BS46zU1mSuyBANm8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dVT5pz66gYZHhxy8fmN6Wu1Bp++INuCcN5X4QQ5De1CiGudDBzWYaIqnfSVh5526v
         RT5G46GZIKgGq33KPvv4n4xOqFJKbLqo3kRSOwKNkHlxyBYUbcQmacPWDFXXtkROmM
         YpsrIq2RtImdAw4VALy4tpjfLsG+rh0ARDrmPkLT25KhsUbAFuXLKgA6Unr1FucgNT
         o32Fa/cu48cyVmQ03vA1acGe2zTqdyhUmyOUTAYru78T26Gt10t+aAwF0Layp82tFL
         XArgCrqv3vgcRStkAvYpvyN8PYV2HC7xl0vIIV7VwK+7SpEWsVXqNGtTDrENHEy6N8
         JJdZa1vj8kD4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 37CB5C40C5E;
        Mon, 17 Apr 2023 18:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: L2CAP: fix "bad unlock balance" in
 l2cap_disconnect_rsp
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <168175621922.2755.6852431348511333212.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 18:30:19 +0000
References: <20230417022754.4925-1-lm0963hack@gmail.com>
In-Reply-To: <20230417022754.4925-1-lm0963hack@gmail.com>
To:     Min Li <lm0963hack@gmail.com>
Cc:     syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, johan.hedberg@gmail.com,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Mon, 17 Apr 2023 10:27:54 +0800 you wrote:
> conn->chan_lock isn't acquired before l2cap_get_chan_by_scid,
> if l2cap_get_chan_by_scid returns NULL, then 'bad unlock balance'
> is triggered.
> 
> Reported-by: syzbot+9519d6b5b79cf7787cf3@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/000000000000894f5f05f95e9f4d@google.com/
> Signed-off-by: Min Li <lm0963hack@gmail.com>
> 
> [...]

Here is the summary with links:
  - Bluetooth: L2CAP: fix "bad unlock balance" in l2cap_disconnect_rsp
    https://git.kernel.org/bluetooth/bluetooth-next/c/ed62f7eeea0d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


