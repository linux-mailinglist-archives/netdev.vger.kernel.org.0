Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E3F55DDC1
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234393AbiF0LKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 07:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233757AbiF0LKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 07:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB54364DF
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 04:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD5BB810FD
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C142C341CB;
        Mon, 27 Jun 2022 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656328213;
        bh=I85O8ODVH6Gs/qG5OPOm6663qFRunZHh+XFmI6Ntz6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ue5TDg1EabPF5WF3KN0AsCz1NlB1nccd1YJEyWGuM/SFatzSVGAWXRLqEu+YSHRsN
         JFerBHcKSkgXKJqF6WF07h4KUNwtDaSpWQLr83uOz+W1leA0bSizArN25FD2mwsmct
         7ac17TLU9QaYeFZvtpuZsUcsSy9G9S4kDAnQ3/mGhrpuRacohckRZO1FB9bWhUgnr0
         9m6i//aGiqrm7zdQAPHvJ8UNrA8/BuZ8q1d1CKO4KqjE3mCp+6KljY6eZTbVghEeUY
         dNF7DKmdGfFlc67yhv+VDXd5wgFI35A/ymabGbi2Pb+AW0V0o5OX+YXfmSIVbnw9Af
         O5n2AiBiYjIUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F1CEFE49BB9;
        Mon, 27 Jun 2022 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipmr: fix a lockdep splat in ipmr_rtm_dumplink()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165632821298.18870.3356988054037059448.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Jun 2022 11:10:12 +0000
References: <20220625064722.3722045-1-edumazet@google.com>
In-Reply-To: <20220625064722.3722045-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 25 Jun 2022 06:47:22 +0000 you wrote:
> vif_dev_read() should be used from RCU protected sections only.
> 
> ipmr_rtm_dumplink() is holding RTNL, so the data structures
> can not be changed.
> 
> syzbot reported:
> 
> [...]

Here is the summary with links:
  - [net-next] ipmr: fix a lockdep splat in ipmr_rtm_dumplink()
    https://git.kernel.org/netdev/net-next/c/0fcae3c8b1b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


