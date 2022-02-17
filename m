Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7814BAAA3
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 21:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245670AbiBQUKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 15:10:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbiBQUKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 15:10:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754A67ED9B;
        Thu, 17 Feb 2022 12:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BF4FB821B1;
        Thu, 17 Feb 2022 20:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4AFCC340ED;
        Thu, 17 Feb 2022 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645128610;
        bh=UAYBT20P+hGmI3uwAk/P1huTmMtTCHA8max253/7s7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M43Qvo8mZNu6K2kc0O7zoqKBmeJpZLIjmzzjcoNVkRTja8dh+KKOJXOpC0BEqpOgX
         a151+zkmWAjoLO4wsgOnzGTf0wHzz3h81qFZu/3NzF0buKQkZalLsTYTAAps0SEZgz
         2HTQAWh/PGILvDYrbsycFuDsyBm8veiw+f2PMm7Jpo6tCl0rcLS6e1f4//+kQ4EpqV
         929ZeGGe01jgCSPkTRpS+DcPlSih85/3Yf27KKVc0XM2GUi6Pbmi4o8tNHHhH70TG9
         lAGfmT90vfcB44HVUKZ4p9AvwivwOtat0giLoKg4YuUJShWxT6fuNLLr0Puzj/gV2b
         vitZsaJ4FQ9xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D954E7BB08;
        Thu, 17 Feb 2022 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bpf 2022-02-17
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164512861064.20807.750808870297794619.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 20:10:10 +0000
References: <20220217190000.37925-1-alexei.starovoitov@gmail.com>
In-Reply-To: <20220217190000.37925-1-alexei.starovoitov@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, kuba@kernel.org,
        andrii@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Feb 2022 11:00:00 -0800 you wrote:
> Hi David, hi Jakub,
> 
> The following pull-request contains BPF updates for your *net* tree.
> 
> We've added 8 non-merge commits during the last 7 day(s) which contain
> a total of 8 files changed, 119 insertions(+), 15 deletions(-).
> 
> [...]

Here is the summary with links:
  - pull-request: bpf 2022-02-17
    https://git.kernel.org/netdev/net/c/7a2fb9128515

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


