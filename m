Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4751613B81
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbiJaQkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiJaQkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:40:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D882DC3;
        Mon, 31 Oct 2022 09:40:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E9FD61312;
        Mon, 31 Oct 2022 16:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A19AC43470;
        Mon, 31 Oct 2022 16:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667234429;
        bh=DsMiCisZKHZnpf4lQ57kkUJexlUaU0Y7eJucnFezUKQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oYrBUF3ArVbSz7g4FwzfEHibmR5cALd3C9cEXPHllGT7dqETorCvZWQH38Nj65ip2
         p2PRleTP3VM5bYaMUyr8ood92RWizc0G4+zpo3Lt53Bc3jGG5Qm4oc5kwSwAHVo4KG
         wHMY8RtFjSYNnK3qpmZ0XjB/62qwgSlSJ4dw8s7qZds8w1gfLzfyDfD8R6FSCNubdx
         lbKsHgomK6iU5SZh8dIkFOTTn4bHqPM8YPxQ+oAhdHMWYZHjtKTBu8OLoliL9KrNYG
         fGFsK/cL2CuGzj0kJPzYvzrjaG8R6iLgFp20x6DIDYeTYd6rYVFnqzzIleFFn8Z9hS
         G1U4THSroTlKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F879E270D6;
        Mon, 31 Oct 2022 16:40:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] openvswitch: add missing resv_start_op initialization for
 dp_vport_genl_family
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166723442945.1920.10166760229708956743.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 16:40:29 +0000
References: <20221031081210.2852708-1-william.xuanziyang@huawei.com>
In-Reply-To: <20221031081210.2852708-1-william.xuanziyang@huawei.com>
To:     Ziyang Xuan (William) <william.xuanziyang@huawei.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Oct 2022 16:12:10 +0800 you wrote:
> I got a warning using the latest mainline codes to start vms as following:
> 
> ===================================================
> WARNING: CPU: 1 PID: 1 at net/netlink/genetlink.c:383 genl_register_family+0x6c/0x76c
> CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc2-00886-g882ad2a2a8ff #43
> ...
> Call trace:
>  genl_register_family+0x6c/0x76c
>  dp_init+0xa8/0x124
>  do_one_initcall+0x84/0x450
> 
> [...]

Here is the summary with links:
  - [net] openvswitch: add missing resv_start_op initialization for dp_vport_genl_family
    https://git.kernel.org/bpf/bpf/c/e4ba4554209f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


