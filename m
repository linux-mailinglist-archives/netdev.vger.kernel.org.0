Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C10162ED9A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 07:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241116AbiKRGaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 01:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbiKRGa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 01:30:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA6998250;
        Thu, 17 Nov 2022 22:30:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 908AB6233E;
        Fri, 18 Nov 2022 06:30:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D968EC43147;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668753024;
        bh=bRJ2+zhFpcHmJMyJI7mb75xTmf9/NG6tCX8mCqGhlb0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I6cACDZjLButOUobuhE+fw0jyZ8vnJBexqPmHdiLNSRqtiMzRzgczTokZ6Cxwo+vc
         C+P9HAYoa6yBUSm4m2PL1S4KAPE7GS3cE5mPw9ISuJ/PpYxG/fNHuYJHLJAF6brmzG
         M3GXmAK5V5jT1UjfmN4qTzLyv7A6SWn2NzuzLFoIlKx/iXWZHOqZa+lo84okvjnnET
         o05+dOLdGHuWnXTGXahPP1tw/j3OfmjZhcpPwOzlE6f0CYQVo2DI7JSfhjFPsxehTb
         Kttjdho2g0D3dqY4ixwGFdlz/D1lSUCPNOgOasQamq0lok85Ju9xniziZpaH7+W3Z+
         eh+jQuHKdselA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF61FE50D72;
        Fri, 18 Nov 2022 06:30:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sctp: change to include linux/sctp.h in
 net/sctp/checksum.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166875302471.3603.13293822718492668637.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 06:30:24 +0000
References: <ca7ea96d62a26732f0491153c3979dc1c0d8d34a.1668526793.git.lucien.xin@gmail.com>
In-Reply-To: <ca7ea96d62a26732f0491153c3979dc1c0d8d34a.1668526793.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, marcelo.leitner@gmail.com, nhorman@tuxdriver.com
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

On Tue, 15 Nov 2022 10:39:53 -0500 you wrote:
> Currently "net/sctp/checksum.h" including "net/sctp/sctp.h" is
> included in quite some places in netfilter and openswitch and
> net/sched. It's not necessary to include "net/sctp/sctp.h" if
> a module does not have dependence on SCTP, "linux/sctp.h" is
> the right one to include.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] sctp: change to include linux/sctp.h in net/sctp/checksum.h
    https://git.kernel.org/netdev/net-next/c/b78c4162823d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


