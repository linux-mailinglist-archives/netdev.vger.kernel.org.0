Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91AA16E5AF5
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:51:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjDRHvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDRHvq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:51:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929124C1C;
        Tue, 18 Apr 2023 00:51:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74DE862DF0;
        Tue, 18 Apr 2023 07:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CA3D2C4339B;
        Tue, 18 Apr 2023 07:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681804219;
        bh=ewysq3wuCASTIg2rOKNlf3mJR3OqeJ/n2NrPeJ4lnmY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fLlXHuuViMqml9D5TP+oZHfAEtbnKQAAejJCU0l3PMgFOGb7nklLOozXlpdShmtu1
         T93xvdkZdZIdq3UE9r1CURHg04w1K0OhW4tM+H+nzPcIcHtn3ThyNRDqnJxk1gnkOE
         NtspbTB30uElI3OR6qB3ybeSj7fTIJaauuEyilXpLRf0Vu2vEtHgRtsSPcAQTPVQ2D
         0OGIhj4ZHNpr6T2DWCwgqMW0yK4T1s9fSiaygakGzKTZVyvxW4hAi7CYlxbHfOb/o3
         jpsN0mnFycQMCE57L/emPdCEjPPQGTQYT08OZIFODVM2qGJRF4TZAygqaF69En4eQ8
         m0Ftu1RSitc+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD3B1C4167B;
        Tue, 18 Apr 2023 07:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RESEND net] cxgb4: fix use after free bugs caused by circular
 dependency problem
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168180421970.1332.3923625350941778517.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Apr 2023 07:50:19 +0000
References: <20230415081227.7463-1-duoming@zju.edu.cn>
In-Reply-To: <20230415081227.7463-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, rajur@chelsio.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 15 Apr 2023 16:12:27 +0800 you wrote:
> The flower_stats_timer can schedule flower_stats_work and
> flower_stats_work can also arm the flower_stats_timer. The
> process is shown below:
> 
> ----------- timer schedules work ------------
> ch_flower_stats_cb() //timer handler
>   schedule_work(&adap->flower_stats_work);
> 
> [...]

Here is the summary with links:
  - [RESEND,net] cxgb4: fix use after free bugs caused by circular dependency problem
    https://git.kernel.org/netdev/net/c/e50b9b9e8610

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


