Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F7D6E434C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 11:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbjDQJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 05:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjDQJKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 05:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01428138
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 02:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90DB461456
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 09:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB213C433EF;
        Mon, 17 Apr 2023 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681722618;
        bh=WHX2yByJ+t03oqDXTTKBWDkIBbHgDX1osnfLk205RJo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Re0jNK/dTdz9p1vN+Khm5ySUwMCk2smSHpWJav7nLnAKvAUlCYUE7EjNDxnkQVOM8
         NPJu4eQiY3sbjHAkYKelC5nnkCMXlg5nf5twurGH/WmhHq05TMD8LVPeek9+VasImO
         x2g+IklHjAB+YqVhAWCzw9xNLzGSzsAQjB7PXZrQJdlwQ4L5euD4AeE7gi8Sogd8Eo
         5H0p0tGDEt3CpbyNra8USdODs1fxCCyhxlMy9lFxKosClr3RWkCh0VLTlO1Gspc+e9
         dNvnDg70IiTMHdI/vUCfZ3/RpEZ9DTe6HFozI8K54rBMrkmeBiZkNlgy/aoy+eNOq9
         fuiWX30CJ9/wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE228C41671;
        Mon, 17 Apr 2023 09:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: clear actions pointer in miss cookie init
 fail
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168172261783.15038.5439553315142258654.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 09:10:17 +0000
References: <20230415153309.241940-1-pctammela@mojatatu.com>
In-Reply-To: <20230415153309.241940-1-pctammela@mojatatu.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, marcelo.leitner@gmail.com,
        paulb@nvidia.com, simon.horman@corigine.com, oswalpalash@gmail.com
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

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 15 Apr 2023 12:33:09 -0300 you wrote:
> Palash reports a UAF when using a modified version of syzkaller[1].
> 
> When 'tcf_exts_miss_cookie_base_alloc()' fails in 'tcf_exts_init_ex()'
> a call to 'tcf_exts_destroy()' is made to free up the tcf_exts
> resources.
> In flower, a call to '__fl_put()' when 'tcf_exts_init_ex()' fails is made;
> Then calling 'tcf_exts_destroy()', which triggers an UAF since the
> already freed tcf_exts action pointer is lingering in the struct.
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: clear actions pointer in miss cookie init fail
    https://git.kernel.org/netdev/net/c/338469d677e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


