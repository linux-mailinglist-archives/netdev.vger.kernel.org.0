Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A62524043
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 00:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348756AbiEKWaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 18:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348740AbiEKWaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 18:30:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D0A219C02
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 15:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 616BAB8263F
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 22:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F6C1C34114;
        Wed, 11 May 2022 22:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652308212;
        bh=U//fC6CIDuwmG9hYfT7mpnpw9E+KKA6sG91R5ICCfBA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XYuXBFlUZrvmkxsXdRnWUegp8YF+T7UZj4vidp7RIxKukcAhDV3n9yI9OYTUMpPE7
         QBOirRQUU+gbF2b3UNQbw4/v4FRDfQrFwXRhfshOuZD1rhfRvAZpTA+gmjm2kEMNXz
         eqj+6scDr9HuB1f7R8tj6pHf3J1lDLd7gYCvsVA3T1o8OwrgyA/omqTpIwf1DQqzQx
         ABtoHdZhy87paxG1GciPmkmc/BsFF+uwh5dAQbL+aHvWmzvkm48wod/d+bgCakruS5
         Xj6umz5uQjcnmqKdaE77WiepdCsxyHJk0OaE4cDtH+Kvnk5ARd6JMx35gycQTmYISh
         CSSO6DBtDdbTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A299E8DBDA;
        Wed, 11 May 2022 22:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] net/sched: act_pedit: really ensure the skb is
 writable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165230821203.9762.14279513076703496323.git-patchwork-notify@kernel.org>
Date:   Wed, 11 May 2022 22:30:12 +0000
References: <1fcf78e6679d0a287dd61bb0f04730ce33b3255d.1652194627.git.pabeni@redhat.com>
In-Reply-To: <1fcf78e6679d0a287dd61bb0f04730ce33b3255d.1652194627.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 10 May 2022 16:57:34 +0200 you wrote:
> Currently pedit tries to ensure that the accessed skb offset
> is writable via skb_unclone(). The action potentially allows
> touching any skb bytes, so it may end-up modifying shared data.
> 
> The above causes some sporadic MPTCP self-test failures, due to
> this code:
> 
> [...]

Here is the summary with links:
  - [v3,net] net/sched: act_pedit: really ensure the skb is writable
    https://git.kernel.org/netdev/net/c/8b796475fd78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


