Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476A5612041
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 06:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJ2Eua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 00:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbiJ2EuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 00:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077335FC18
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 21:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A62E7B82E32
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 04:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EB77C433D7;
        Sat, 29 Oct 2022 04:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667019018;
        bh=/1kTIWNHf4eq5twObHNp7CIa5QXSYOBR5nI0y1NgC5k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WC/eUGqGLDEbarMts3pbObnSXtyQLOyYqaSX5wosTdtVnlPjH8xcgZKPscLJDtUZE
         0TI6KXzh7UceTEbWrTZD2Rg670L8xgw5o5JAP+OAKi1QyjOva2G0zQaQQQpAURvWpY
         waGdCe8MVc/H7HDBxWx3ysV8jDsjZh4kIPt3y353wIa0ko+Px9S/K9J3JUuoRdGLit
         suCsVFu6TdHzP8cjZOhkgxdlZG5WIOLSoXb2/qVjlgcnCiQlnalfQS8nhAXpXspQU6
         sf4pt/xs2exTSuBa+dqz4Kz68dj0l6TQwworUpiHCfove887PP9/3vg9fEOJ9GLJM2
         X2x8st2hHYjgw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F504C4166D;
        Sat, 29 Oct 2022 04:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: openvswitch: add missing .resv_start_op
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166701901811.13014.15425513761434475256.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 04:50:18 +0000
References: <20221028032501.2724270-1-kuba@kernel.org>
In-Reply-To: <20221028032501.2724270-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+40eb8c0447c0e47a7e9b@syzkaller.appspotmail.com,
        pshelar@ovn.org, paul@paul-moore.com, dev@openvswitch.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 20:25:01 -0700 you wrote:
> I missed one of the families in OvS when annotating .resv_start_op.
> This triggers the warning added in commit ce48ebdd5651 ("genetlink:
> limit the use of validation workarounds to old ops").
> 
> Reported-by: syzbot+40eb8c0447c0e47a7e9b@syzkaller.appspotmail.com
> Fixes: 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: openvswitch: add missing .resv_start_op
    https://git.kernel.org/netdev/net/c/e4ba4554209f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


