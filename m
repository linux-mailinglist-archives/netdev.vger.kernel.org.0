Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECF05A8EB4
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiIAGuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232995AbiIAGuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:50:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663CF61103;
        Wed, 31 Aug 2022 23:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 445F0B82475;
        Thu,  1 Sep 2022 06:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B91D0C433D6;
        Thu,  1 Sep 2022 06:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662015014;
        bh=h1oiY9w4cNEx8MJKBHCH3T5N0k2k5oJzR61LVSvcHrg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gd1ErZ+q7NwGcGtyf0/rwW8SeFcTxhoG3P2PscNUUIDHNPRY0GY7jRPRmgSkbfm7R
         MWImIKeOBKRi+jkEtTu93tVyGo3lNdXRJAa2rJra0XbzY6i2COrhYtl2oKRufpc0Fc
         cAJkAjY9ritbMKxxNEksik3bI8vthjl3TXQ8wrtLhhkgx6cAt6avSRt7Pmp8yJsbvA
         t3PycBJYozJtPtYli7bc37GdzLJpGkPhu/VscGcLHHeB2vVjqQacpf1IS+9ohKqvbk
         3Ibu3qrxueRRbMAuRlBC3N8XCre1VuTNCDQ4k4pjtIkFO/9Ip0GLqcUDTrmRaSDnpV
         D1dr+TiPtf3EA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9538DE924DA;
        Thu,  1 Sep 2022 06:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2] net: sched: remove redundant NULL check in change
 hook function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166201501460.7647.7189614631931905429.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Sep 2022 06:50:14 +0000
References: <20220829071219.208646-1-shaozhengchao@huawei.com>
In-Reply-To: <20220829071219.208646-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org, toke@toke.dk,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, stephen@networkplumber.org,
        cake@lists.bufferbloat.net, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 29 Aug 2022 15:12:19 +0800 you wrote:
> Currently, the change function can be called by two ways. The one way is
> that qdisc_change() will call it. Before calling change function,
> qdisc_change() ensures tca[TCA_OPTIONS] is not empty. The other way is
> that .init() will call it. The opt parameter is also checked before
> calling change function in .init(). Therefore, it's no need to check the
> input parameter opt in change function.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: sched: remove redundant NULL check in change hook function
    https://git.kernel.org/netdev/net-next/c/a102c8973db7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


