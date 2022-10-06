Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF40E5F5FDC
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 06:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiJFEA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 00:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiJFEAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 00:00:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5075A3C2;
        Wed,  5 Oct 2022 21:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5950CB81FF2;
        Thu,  6 Oct 2022 04:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 120E9C433D7;
        Thu,  6 Oct 2022 04:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665028817;
        bh=CQqcFZBo7OajSDdbV01LBXwWgFNml+B9012Zp0rP58I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Q4Wu5yEetzAX3pXo3CviorQB2Gc7xm70podVCurVEG8R4grsAv4CfGhIWndnspZQa
         LJycq28YG1+7PcKaFFBP4NN6c5/PgyuCaKdadeQXZt7Z536X7SxPv759Q+ZCnc9gKd
         hnWQ9+2hOir78b2rWdZqv8aXPrElxW463BtxCa4mrhpPKivkH094DXcOtaPDwjbUD1
         39r1Yq6SXwWFqhTEbi/a+LYrP/V4HWSSXWgxqXtaH9Oh6ayCggd7Ms6BRGdUFISeG/
         SZtpaKkwDaW69pHXNTHL4FPWpjtg71mU4i76IUOoIpa5Xk48QdDgHLVUrTWBsuyUoe
         y6fYDJR5ZMnmw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1567E21EC2;
        Thu,  6 Oct 2022 04:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net/sched: taprio: make qdisc_leaf() see the
 per-netdev-queue pfifo child qdiscs"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166502881691.31263.4459255074695188698.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Oct 2022 04:00:16 +0000
References: <20221004220100.1650558-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221004220100.1650558-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        olteanv@gmail.com, kurt@linutronix.de,
        linux-kernel@vger.kernel.org, muhammad.husaini.zulkifli@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  5 Oct 2022 01:01:00 +0300 you wrote:
> taprio_attach() has this logic at the end, which should have been
> removed with the blamed patch (which is now being reverted):
> 
> 	/* access to the child qdiscs is not needed in offload mode */
> 	if (FULL_OFFLOAD_IS_ENABLED(q->flags)) {
> 		kfree(q->qdiscs);
> 		q->qdiscs = NULL;
> 	}
> 
> [...]

Here is the summary with links:
  - [net] Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"
    https://git.kernel.org/netdev/net/c/af7b29b1deaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


