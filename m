Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65655F304B
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbiJCMaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 08:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiJCMaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8A227CCB;
        Mon,  3 Oct 2022 05:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2663C61038;
        Mon,  3 Oct 2022 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D15DC433B5;
        Mon,  3 Oct 2022 12:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664800215;
        bh=ra5p4TDbHH/MyogX7WQr6WkJNPkFdYxm41lh3797BPg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cz2oNJSfn4osQO/eBtSLTJQdCNfQH1YJocaZGJLqLySd3Aq+81zMIxP7Ejinl8gMv
         59CTj5IRh0yL2x/Is5fvpFQse7ba1h84Lsms/jZIJzUByrhrkmwm9wefb2sPPgdlwh
         6SqtcxBN67zJb97ZopK9uPmSaXv9xV7mt36eNc6yo3sx3QGSBS78epeSFC7ApwfCFN
         sz9DGmGZSJwGfiEVBboTuoQXrAwPE9H+z3r4Zyw0cxfOui2OxLREArTLEpGP6XLJyU
         dxj8SD75n0eRkqLj4DdJSSW4reT4V3RWUQRSNHkUbFPJkWvQUrXbWSN+upemClDKAu
         ClzmW2s8gDVUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 594F3E524CD;
        Mon,  3 Oct 2022 12:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/ieee802154: reject zero-sized raw_sendmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166480021535.14393.17575492399292423045.git-patchwork-notify@kernel.org>
Date:   Mon, 03 Oct 2022 12:30:15 +0000
References: <5e89b653-3fc6-25c5-324b-1b15909c0183@I-love.SAKURA.ne.jp>
In-Reply-To: <5e89b653-3fc6-25c5-324b-1b15909c0183@I-love.SAKURA.ne.jp>
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        shaozhengchao@huawei.com, ast@kernel.org, sdf@google.com,
        linux-wpan@vger.kernel.org,
        syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
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

On Sun, 2 Oct 2022 01:43:44 +0900 you wrote:
> syzbot is hitting skb_assert_len() warning at raw_sendmsg() for ieee802154
> socket. What commit dc633700f00f726e ("net/af_packet: check len when
> min_header_len equals to 0") does also applies to ieee802154 socket.
> 
> Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4
> Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
> Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> 
> [...]

Here is the summary with links:
  - net/ieee802154: reject zero-sized raw_sendmsg()
    https://git.kernel.org/netdev/net/c/3a4d061c699b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


