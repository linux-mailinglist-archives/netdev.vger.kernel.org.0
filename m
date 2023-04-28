Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72E6C6F1382
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 10:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345550AbjD1Iuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 04:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345489AbjD1Iub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 04:50:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0B419A7
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 01:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A213664214
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 08:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04C0FC433A0;
        Fri, 28 Apr 2023 08:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682671820;
        bh=VhZHqupUw92raKtlJxX+8wkibzCvpp5/BzDDQkz3bgw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dGmGaG3mW+CCDLbiKAJD7+Lj4m+a0IwCVRfWIP/lOh33v+K5MPEa/ng1BTU6nt+zd
         Cw/qCLTPPzPHjlEcIN2dw8VMQ8583xep5uIIiSdo3HN//Ex/mWn1fm8FtCWXX+HGbs
         qKL68qT1GxfGnZj2JcQrsRu3bjZXyso34xoIkWeb3+RlAtRAZ5/XnA5uPEx24/puxS
         Frf1oF8sHfK5jiAs02NDlDDu9K76X6szIReZZ286eQq/dhbWx8gkdSV8nJLowv1l/z
         tvCkg+vJRQXUoq++EkOQuyXPGWeFkjAIVREppXucvkazbZ2Y5w/+JF/owBK8JOmchV
         UoluUXfsIQizg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9EF2E270D4;
        Fri, 28 Apr 2023 08:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/sched: cls_api: remove block_cb from driver_list
 before freeing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168267181988.3488.6278873622763468931.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Apr 2023 08:50:19 +0000
References: <20230426123111.2151294-1-vladbu@nvidia.com>
In-Reply-To: <20230426123111.2151294-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, pablo@netfilter.org,
        simon.horman@corigine.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 26 Apr 2023 14:31:11 +0200 you wrote:
> Error handler of tcf_block_bind() frees the whole bo->cb_list on error.
> However, by that time the flow_block_cb instances are already in the driver
> list because driver ndo_setup_tc() callback is called before that up the
> call chain in tcf_block_offload_cmd(). This leaves dangling pointers to
> freed objects in the list and causes use-after-free[0]. Fix it by also
> removing flow_block_cb instances from driver_list before deallocating them.
> 
> [...]

Here is the summary with links:
  - [net] net/sched: cls_api: remove block_cb from driver_list before freeing
    https://git.kernel.org/netdev/net/c/da94a7781fc3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


