Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3063F5509A5
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiFSKaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbiFSKaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:30:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28224D101
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 03:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B443760FF9
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 10:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 15286C3411D;
        Sun, 19 Jun 2022 10:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655634613;
        bh=g83gWOA8Yv/bNf5/LpLrgRZ8C77axOg8shsuAw9w7RA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e5vQqUFoBRU2Uf6UMAPFEqyXkvgo16CPmB3F/NFoMwPjA/Al31ZKoO60cmEwEbd9l
         LcvtRz5857Rgv/NvHbnPo/7dpOas3MdUAF8GHzkzdxgrqa5V4FNJvcRS6ra0LBr7dv
         gSpFsdF3XlvsE6hnLcv3qY7hyylzrGU+4LbavgjJ/qljMoW9MJnNUc4MVIDQLVc2CC
         4znL8Y/3m7viWBDG66Ywq6CejfqhljZGFeS8k4Va2xllHH5VEeIyvq0lEzY8fdHsAf
         Ff3cQDYZ53vb/wq8pbnYQ89k6xtD610MXJyJbWxME7NqfnMFpLygQBxRoxiPMXHIz1
         HyjK8rteIf9vw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EDAD6E7387E;
        Sun, 19 Jun 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "nfp: update nfp_X logging definitions"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165563461296.4100.11017570160841679295.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 10:30:12 +0000
References: <20220619081530.228400-1-simon.horman@corigine.com>
In-Reply-To: <20220619081530.228400-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, oss-drivers@corigine.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sun, 19 Jun 2022 10:15:30 +0200 you wrote:
> This reverts commit 9386ebccfc59 ("nfp: update nfp_X logging definitions")
> 
> The reverted patch was intended to improve logging for the NFP driver by
> including information such as the source code file and number in log
> messages.
> 
> Unfortunately our experience is that this has not improved things as
> we had hoped. The resulting logs are inconsistent with (most) other
> kernel log messages. And rely on knowledge of the source code version
> in order for the extra information to be useful.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "nfp: update nfp_X logging definitions"
    https://git.kernel.org/netdev/net-next/c/41a36d4e5a14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


