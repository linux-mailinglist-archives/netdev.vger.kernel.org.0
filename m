Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059804BB104
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 06:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiBRFAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 00:00:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiBRFAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 00:00:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B5B2BAA01;
        Thu, 17 Feb 2022 21:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C78E861E71;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FFE2C340F5;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645160412;
        bh=eEb88DaBT3wMJmmi/zyOW+H06j/ERdP2Q8iq14+myTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TJ51cxd5EQ5SkbI1a2qAU0+vTomZIrMnQv9GRMozjRV7rDL1aP+mPlTWBnMeW0YnH
         5jghwRMYvBTroVx5aMJCAz8l/EwQPHKD5Za3mzfTCqZVUcvcH8MLeUMrUa+KW0eX7l
         fahuiIoNtpDIlxQ3Bt9x7x0Az8/JzYKc6TIh1jFmWEbb39cPk2bfq8K9GHaYDvh/It
         ghT2JGonYvZyYByvxfzDBV/uiu5PcCOD5L7dxIcAENjH4ZSo9m/Zgi8aR5JKQ9tM8q
         AL/gk4+FcS1kMEUE1a+0e/4VcYDpn4CDr4TnuEgP88WenvvRqWOlpZFuk1yDSkpM4n
         dTHgEwTD9SchQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0D590E7BB18;
        Fri, 18 Feb 2022 05:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] s390/qeth: Remove redundant 'flush_workqueue()'
 calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164516041204.28752.11480092833354326315.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 05:00:12 +0000
References: <20220216075155.940-1-vulab@iscas.ac.cn>
In-Reply-To: <20220216075155.940-1-vulab@iscas.ac.cn>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     wintera@linux.ibm.com, wenjia@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Feb 2022 07:51:55 +0000 you wrote:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> Acked-by: Alexandra Winter <wintera@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net-next] s390/qeth: Remove redundant 'flush_workqueue()' calls
    https://git.kernel.org/netdev/net-next/c/129c77b5692d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


